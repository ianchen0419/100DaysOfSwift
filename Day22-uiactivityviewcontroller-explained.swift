//
//  DetailViewController.swift
//  StormViewer
//
//  Created by Yi An Chen on 2022/3/30.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var selectedImageIndex = 0
    var totalImageNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        title = selectedImage
        title = "Picture \(selectedImageIndex + 1) of \(totalImageNumber)"
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        // the method "shareTapped" will exist, and it will be triggered when the button is tapped
        // UIBarButtonItem is all written by Objective-C
        // by default, Objective-C can't see it's method calls, UIBarButtonItem is trying to reading our Swift method "shareTapped"

        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    // @objc wil tell Swift: this method, please compile it for Swift use, but also make it visible by a usable to Objective-C code, like UIBarButtonItem
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        guard let imageTitle = selectedImage else {
            print("No image title")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image, imageTitle], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem // for iPad
        present(vc, animated: true)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
