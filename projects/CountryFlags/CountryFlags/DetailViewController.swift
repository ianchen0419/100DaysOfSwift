//
//  DetailViewController.swift
//  CountryFlags
//
//  Created by Yi An Chen on 2022/4/1.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var selectedCountry: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = selectedCountry
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTaped))
        
        if let image = selectedImage {
            imageView.image = UIImage(named: image)
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
    
    @objc func shareTaped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else { return }
        guard let country = selectedCountry else { return }
        
        let shareText = "This is country flag of \(country)"
        
        let vc = UIActivityViewController(activityItems: [image, shareText], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
//    @objc func shareTapped() {
//            guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
//                print("No image found")
//                return
//            }
//            guard let imageTitle = selectedImage else {
//                print("No image title")
//                return
//            }
//
//            let vc = UIActivityViewController(activityItems: [image, imageTitle], applicationActivities: [])
//            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem // for iPad
//            present(vc, animated: true)
//        }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
