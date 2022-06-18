//
//  ViewController.swift
//  StormViewer
//
//  Created by Yi An Chen on 2022/3/30.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        performSelector(inBackground: #selector(loadPictures), with: nil)
    }
    
    @objc func loadPictures() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath! // iOS always has to have one
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        // fm, paths, items will all be destroyed as soon as viewDidLoad finished
        
        for item in items {
            if item.hasPrefix("nssl") {
                // this is a picture to load!
                pictures.append(item)
            }
        }
        pictures = pictures.sorted()
        performSelector(onMainThread: #selector(reloadData), with: nil, waitUntilDone: false)
    }
    
    @objc func reloadData() {
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "Bad") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedImageIndex = indexPath.row
            vc.totalImageNumber = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func shareTapped() {
        let text = "Storm Viewer is the greatest app!"
        
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}

