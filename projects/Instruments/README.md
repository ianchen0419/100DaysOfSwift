# Instruments

[Demo](Documentation/demo.png)

## Work with Performance

### Slow shadow - solution (1)

Let shadow render happend in Core Graphic.  
Side effect: the shadow is clipped by Core Graphic Area.

```diff swift:SelectionViewController.swift
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")

        // find the image for this cell, and load its thumbnail
        let currentImage = items[indexPath.row % items.count]
        let imageRootName = currentImage.replacingOccurrences(of: "Large", with: "Thumb")
        let path = Bundle.main.path(forResource: imageRootName, ofType: nil)!
        let original = UIImage(contentsOfFile: path)!

        let renderer = UIGraphicsImageRenderer(size: original.size)

        let rounded = renderer.image { ctx in
+           ctx.cgContext.setShadow(offset: .zero, blur: 200, color: UIColor.black.cgColor)
+           ctx.cgContext.fillEllipse(in: CGRect(origin: .zero, size: original.size))
+           ctx.cgContext.setShadow(offset: .zero, blur: 0, color: nil)

            ctx.cgContext.addEllipse(in: CGRect(origin: CGPoint.zero, size: original.size))
            ctx.cgContext.clip()

            original.draw(at: CGPoint.zero)
        }

        cell.imageView?.image = rounded

        // give the images a nice shadow to make them look a bit more dramatic
-       cell.imageView?.layer.shadowColor = UIColor.black.cgColor
-       cell.imageView?.layer.shadowOpacity = 1
-       cell.imageView?.layer.shadowRadius = 10
-       cell.imageView?.layer.shadowOffset = CGSize.zero

        // each image stores how often it's been tapped
        let defaults = UserDefaults.standard
        cell.textLabel?.text = "\(defaults.integer(forKey: currentImage))"

        return cell
    }
```

### Slow shadow - solution (2)

Specify `90*90` render area for Core Graphic, scale down the CPU loading.

```diff swift:SelectionViewController.swift
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")

		// find the image for this cell, and load its thumbnail
		let currentImage = items[indexPath.row % items.count]
		let imageRootName = currentImage.replacingOccurrences(of: "Large", with: "Thumb")
		let path = Bundle.main.path(forResource: imageRootName, ofType: nil)!
		let original = UIImage(contentsOfFile: path)!

+       let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
-		let renderer = UIGraphicsImageRenderer(size: original.size)
+       let renderer = UIGraphicsImageRenderer(size: renderRect.size)

		let rounded = renderer.image { ctx in
-			ctx.cgContext.addEllipse(in: CGRect(origin: CGPoint.zero, size: original.size))
+           ctx.cgContext.addEllipse(in: renderRect)
			ctx.cgContext.clip()

-			original.draw(at: CGPoint.zero)
+           original.draw(in: renderRect)
		}

		cell.imageView?.image = rounded

		// give the images a nice shadow to make them look a bit more dramatic
		cell.imageView?.layer.shadowColor = UIColor.black.cgColor
		cell.imageView?.layer.shadowOpacity = 1
		cell.imageView?.layer.shadowRadius = 10
		cell.imageView?.layer.shadowOffset = CGSize.zero
+       cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: renderRect).cgPath

		// each image stores how often it's been tapped
		let defaults = UserDefaults.standard
		cell.textLabel?.text = "\(defaults.integer(forKey: currentImage))"

		return cell
    }
```

### Reusable cell - solution (1)

```diff swift:SelectionViewController.swift
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
-		let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")

+       var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "Cell")
+
+       if cell == nil {
+           cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
+       }

		...
    }
```

### Reusable cell - solution (2)

Request cell to go back one back reusably.

```diff swift:SelectionViewController.swift
    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Reactionist"

		tableView.rowHeight = 90
		tableView.separatorStyle = .none

		// load all the JPEGs into our array
		let fm = FileManager.default

		if let tempItems = try? fm.contentsOfDirectory(atPath: Bundle.main.resourcePath!) {
			for item in tempItems {
				if item.range(of: "Large") != nil {
					items.append(item)
				}
			}
		}
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
-		let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
+       let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)


		...
    }
```

### Remove cached image
`UIImage(name: )` will cached image, but we don't want to cache these images

```diff swift:ImageViewController.swift
    override func viewDidLoad() {
        super.viewDidLoad()

        title = image.replacingOccurrences(of: "-Large.jpg", with: "")
+       let path = Bundle.main.path(forResource: image, ofType: nil)!
-       let original = UIImage(named: image)!
+       let original = UIImage(contentsOfFile: path)!


        let renderer = UIGraphicsImageRenderer(size: original.size)

        let rounded = renderer.image { ctx in
            ctx.cgContext.addEllipse(in: CGRect(origin: CGPoint.zero, size: original.size))
            ctx.cgContext.closePath()

            original.draw(at: CGPoint.zero)
        }

        imageView.image = rounded
    }
```

or you can use extension: `UIImage(uncached:)`

```swift
extension UIImage {
    convenience init?(uncached name: String) {
        if let path = Bundle.main.path(forResource: name, ofType: nil) {
            self.init(contentsOfFile: path)
        } else {
            return nil
        }
    }
}
```

### Remove cached and strong owned ViewController

The code has saved and cached every visited detail page, but we don't need this
```diff swift:SelectionViewController.swift
class SelectionViewController: UITableViewController {
    var items = [String]() // this is the array that will store the filenames to load
-   var viewControllers = [UIViewController]() // create a cache of the detail view controllers for faster loading
    var dirty = false
    ...
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ...
-       viewControllers.append(vc)
        navigationController!.pushViewController(vc, animated: true)
    }
}
```

```diff swift:ImageViewController.swift
class ImageViewController: UIViewController {
-   var owner: SelectionViewController!
+   weak var owner: SelectionViewController!
    ...
}
```

`ImageViewController` owns `Timer`, and `Timer` owns `ImageViewController` strongly.

```diff swift:ImageViewController.swift
+   override func viewWillDisappear(_ animated: Bool) {
+       super.viewWillDisappear(animated)
+       animTimer.invalidate()
+   }
```

## Requirements

- iOS 15.4
- Xcode 13.3
