//
//  ViewController.swift
//  ShoppingList
//
//  Created by Yi An Chen on 2022/4/2.
//

import UIKit

class ViewController: UITableViewController {
    var allProducts = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForProduct))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"), style: .plain, target: self, action: #selector(openActionSheet))
        
        navigationItem.leftBarButtonItem?.isEnabled = false
    }
    
    @objc func promptForProduct() {
        let ac = UIAlertController(title: "Enter Items", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Add to list", style: .default) {
            [weak self, weak ac] _ in
            guard let product = ac?.textFields?[0].text else { return }
            self?.addProduct(product)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func openActionSheet() {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Share to others", style: .default, handler: shareList))
        ac.addAction(UIAlertAction(title: "Reset all list", style: .destructive, handler: alertForDelete))
        ac.addAction(UIAlertAction(title: "Cencel", style: .cancel))
        
        ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(ac, animated: true)
    }
    
    func shareList(action: UIAlertAction!) {
        let allProductsString = allProducts.joined(separator: "\n")
        let shareString = "This is my shopping list: \n\(allProductsString)"
        
        let vc = UIActivityViewController(activityItems: [shareString], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(vc, animated: true)
    }
    
    func alertForDelete(action: UIAlertAction!) {
        let ac = UIAlertController(title: "Do you want to delete?", message: "This action will delete all permanently", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: resetList))
        
        present(ac, animated: true)
        
    }
    
    func resetList(action: UIAlertAction!) {
        allProducts = []
        tableView.reloadData()
        navigationItem.leftBarButtonItem?.isEnabled = false
    }
    
    func addProduct(_ product: String) {
        allProducts.insert(product, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        navigationItem.leftBarButtonItem?.isEnabled = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allProducts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Product", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = allProducts[indexPath.row]
        cell.contentConfiguration = content
        cell.selectionStyle = .none
        return cell
    }

}

