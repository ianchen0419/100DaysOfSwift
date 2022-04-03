//
//  ViewController.swift
//  WhitehousePetitions
//
//  Created by Yi An Chen on 2022/4/2.
//

import UIKit
// FIFO blocks
// QoS: decide what level of service this code should be given

// 4 background quenes
// 1. User Interactive: this is the highest priority background thread, and should be used when you want a background thread to do work that is important to keep your user interface working. this parameter will ask system to dedicate nearly all available CPU time to you to get the job done ASAP
// 2. User Initiated: this should be used to execute threads requested by the user that are now waiting for in order to continue using the app
// 3. Utility: this should be used for long running tasks the users aware of but not necessarily desperate for now
// 4. Background: this is for long running tasks the user isn't actively aware of or at least doesn't care about its progress or when it compeletes

// Thread
// 1. By default, our own code executes on only one CPU
// 2. All UI must occur on the main thread (initial thread)
// 3. Can't control when threads execute, or in what order
// 4. Because of 3, be careful to ensure only one thread modifiers our data at one time

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
        // run the fetchJSON method on the current object our view controller in the background
    }
    
    @objc func fetchJSON() {
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
                parse(json: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        // run showError method on our main thread
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
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

