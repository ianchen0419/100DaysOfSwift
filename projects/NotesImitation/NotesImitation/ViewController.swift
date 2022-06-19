//
//  ViewController.swift
//  NotesImitation
//
//  Created by 陳怡安 on 2022/5/14.
//

import UIKit

class ViewController: UITableViewController {
    var notes = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes Imitation"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let add = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNote))
        toolbarItems = [spacer, add]
        navigationController?.isToolbarHidden = false
        
        let savedNotes = UserDefaults.standard.object(forKey: "SavedNotes") as? [String] ?? [String]()
        notes = savedNotes
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        let title = notes[indexPath.row].components(separatedBy: "\n")[0]
        if title.isEmpty {
            cell.textLabel?.text = "New Note"
        } else {
            cell.textLabel?.text = title
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            detailVC.note = notes[indexPath.row]
            detailVC.homeVC = self
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    
    @objc func addNote() {
        let newNote = ""
        notes.append(newNote)
        
        UserDefaults.standard.set(notes, forKey: "SavedNotes")
        tableView.reloadData()
    }
    
    func save(oldNote: String, newNote: String) {
        if let index = notes.firstIndex(of: oldNote) {
            notes[index] = newNote
            saveToLocal()
        }
    }
    
    func delete(_ note: String) {
        if let index = notes.firstIndex(of: note) {
            notes.remove(at: index)
            saveToLocal()
        }
    }
    
    func saveToLocal() {
        UserDefaults.standard.set(notes, forKey: "SavedNotes")
        tableView.reloadData()
    }


}

