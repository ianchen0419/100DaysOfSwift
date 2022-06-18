//
//  ViewController.swift
//  Hangman
//
//  Created by Yi An Chen on 2022/4/5.
//

import UIKit

class ViewController: UIViewController {
    var answerLabel: UILabel!
    var lifeLabel: UILabel!
//    var scoreLabel: UILabel!
    var activedButtons = [UIButton]()
    
    var lifeScore = 7 {
        didSet {
            lifeLabel.text = lifeText
        }
    }
    
    var questions = [String]()
    var word = ""
    var usedLetters = [String]() {
        didSet {
            answerLabel.text = answerText
        }
    }
    var answerText: String {
        var promptWord = ""
        
        for letter in word {
            let strLetter = String(letter)
            if usedLetters.contains(strLetter) {
                promptWord += strLetter
            } else {
                promptWord += "?"
            }
        }
        return promptWord
    }
    
    var lifeText: String {
        let lifeAmount = lifeScore
        let deathAmount = 7 - lifeScore
        
        let lifeString = String.init(repeating: "♥", count: lifeAmount)
        let deathString = String.init(repeating: "♡", count: deathAmount)
        return lifeString + deathString
    }
    
    let alphabets = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
//        scoreLabel = UILabel()
//        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
//        scoreLabel.textAlignment = .right
//        scoreLabel.text = "SCORE"
//        view.addSubview(scoreLabel)
        
        lifeLabel = UILabel()
        lifeLabel.translatesAutoresizingMaskIntoConstraints = false
        lifeLabel.textAlignment = .left
        lifeLabel.text = lifeText
        view.addSubview(lifeLabel)
        
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.textAlignment = .center
        answerLabel.numberOfLines = 1
        answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answerLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        view.addSubview(answerLabel)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
//            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
//            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            lifeLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            lifeLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 300),
            buttonsView.heightAnchor.constraint(equalToConstant: 350),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            
            answerLabel.topAnchor.constraint(equalTo: lifeLabel.bottomAnchor, constant: 20),
            answerLabel.bottomAnchor.constraint(equalTo: buttonsView.topAnchor, constant: -20),
            answerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        let width = 75
        let height = 50
        
        for (index, letter) in alphabets.enumerated() {
            let letterButton = UIButton(type: .system)
            letterButton.setTitle(letter, for: .normal)
            letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            
            let column = (index + 0) % 4
            let row = (index + 0) / 4
            
            let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
            letterButton.frame = frame
            
            buttonsView.addSubview(letterButton)
        }
        
//        answerLabel.backgroundColor = .red
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let letter = sender.titleLabel?.text else { return }
        usedLetters.append(letter)
        if word.contains(letter) == false {
            if lifeScore > 0 {
                lifeScore -= 1
            } else {
                let ac = UIAlertController(title: "You're die", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: startGame))
                present(ac, animated: true)
            }
        } else {
            // success
            if answerText.contains("?") == false {
                let ac = UIAlertController(title: "Bravo!", message: "You are winning", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Play again", style: .default, handler: startGame))
                present(ac, animated: true)
            }
        }
        activedButtons.append(sender)
        sender.isHidden = true
    }
    
    func startGame(action: UIAlertAction?) {
        questions.shuffle()
        word = questions[0]
        answerLabel.text = answerText
        
        for button in activedButtons {
            button.isHidden = false
        }
        
        lifeScore = 7
        usedLetters = [String]()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    func loadData() {
        if let url = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let contents = try? String(contentsOf: url) {
                questions = contents.components(separatedBy: "\r\n")
                startGame(action: nil)
            }
        }
    }


}

