//
//  DetailViewController.swift
//  PhotoList
//
//  Created by Yi An Chen on 2022/4/10.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let photo = photo else { return }
        
        title = photo.caption
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        let path = FileManager.documentsDirectory.appendingPathComponent(photo.image)
        imageView.image = UIImage(contentsOfFile: path.path)
    }
    
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else { return }
        guard let caption = photo?.caption else { return }
        
        let vc = UIActivityViewController(activityItems: [image, caption], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem // for iPad
        present(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
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
