//
//  ViewController.swift
//  WordScramble
//
//  Created by Yi An Chen on 2022/4/2.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // We can send the closure somewhere, where it gets stored away and executed later. To make this work, Swift takes a copy of the code and captures any data it references, so it use them later
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        guard let previousWord = UserDefaults.standard.object(forKey: "word") as? String else {
            startGame()
            return
        }
        guard let previousEntites = UserDefaults.standard.object(forKey: "entities") as? [String] else {
            startGame()
            return
        }
        
        title = previousWord
        usedWords = previousEntites
        tableView.reloadData()
        
    }

    @objc func startGame() {
        guard let word = allWords.randomElement() else { return }
        title = word
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
        
        UserDefaults.standard.set(word, forKey: "word")
        UserDefaults.standard.set(usedWords, forKey: "entities")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(lowerAnswer, at: 0)
                    UserDefaults.standard.set(usedWords, forKey: "entities")
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    showErrorMessage(title: "Word not recognized", message: "You can't just make them up, you know!")
                }
            } else {
                showErrorMessage(title: "Word already used", message: "Be more original!")
            }
        } else {
            guard let title = title else { return }
            showErrorMessage(title: "Word not possible", message: "You can't spell that word from \(title.lowercased())")
        }
        
        
    }
    
    func showErrorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        guard tempWord != word else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        let checked = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checked.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound || range.length > 2
        
    }
    

}

