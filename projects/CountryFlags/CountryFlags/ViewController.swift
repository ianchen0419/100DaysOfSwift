//
//  ViewController.swift
//  CountryFlags
//
//  Created by Yi An Chen on 2022/4/1.
//

import UIKit

struct Country: Codable {
    let name: String
    let emoji: String
    let image: String
}

class ViewController: UITableViewController {
    var countries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Country Flags"
        loadData()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        cell.textLabel?.text = "\(countries[indexPath.row].emoji) \(countries[indexPath.row].name)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedCountry = countries[indexPath.row].name
            vc.selectedImage = countries[indexPath.row].image
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func loadData() {
        guard let url = Bundle.main.url(forResource: "countries", withExtension: "json") else {
            fatalError("Failed to locate file in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load file from bundle.")
        }
        
        guard let loaded = try? JSONDecoder().decode([Country].self, from: data) else {
            fatalError("Failed to decode file from bundle.")
        }
        
        countries = loaded
    }
}

