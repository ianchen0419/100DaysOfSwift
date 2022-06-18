//
//  ViewController.swift
//  WhitehousePetitions
//
//  Created by Yi An Chen on 2022/4/2.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Whitehouse Petitions"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(showCredit))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearch))
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://hws.dev/petitions-1.json"
        } else {
            urlString = "https://hws.dev/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                // we're OK to parse
                parse(json: data)
                return
            }
        }
        
        showError()
    }
    
    func submitSearch(_ keyword: String) {
        if keyword.isEmpty {
            title = "Whitehouse Petitions"
            filteredPetitions = petitions
        } else {
            title = "Search: \(keyword)"
            filteredPetitions = petitions.filter { $0.title.localizedCaseInsensitiveContains(keyword) }
        }
        
        tableView.reloadData()
    }
    
    @objc func showSearch() {
        let ac = UIAlertController(title: "Search keyword", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Search", style: .default) {
            [weak self, weak ac] _ in
            guard let keyword = ac?.textFields?[0].text else { return }
            self?.submitSearch(keyword)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func showCredit() {
        let ac = UIAlertController(title: "Credit info", message: "Petitions data is come from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }


}

