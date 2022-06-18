//
//  ViewController.swift
//  PhotoList
//
//  Created by Yi An Chen on 2022/4/10.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var photos = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Photo List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if let savedPhotos = UserDefaults.standard.object(forKey: "photos") as? Data {
            do {
                photos = try JSONDecoder().decode([Photo].self, from: savedPhotos)
            } catch {
                print("Failed to load photos.")
            }
        }
    }
    
    @objc func addPhoto() {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = FileManager.documentsDirectory.appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        dismiss(animated: true)
        
        let ac = UIAlertController(title: "Caption of new photo", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let caption = ac?.textFields?[0].text else { return }
            
            let photo = Photo(image: imageName, caption: caption)
            self?.photos.append(photo)
            self?.save()
            self?.tableView.reloadData()
            
        })
        
        present(ac, animated: true)
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Photo", for: indexPath)
        cell.textLabel?.text = photos[indexPath.row].caption
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.photo = photos[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func save() {
        if let savedData = try? JSONEncoder().encode(photos) {
            UserDefaults.standard.set(savedData, forKey: "photos")
        } else {
            print("Failed to save photos.")
        }
    }
}

