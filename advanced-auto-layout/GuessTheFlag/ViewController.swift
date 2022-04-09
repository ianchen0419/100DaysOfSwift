//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Yi An Chen on 2022/3/31.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        // CALayer don't know what is UIColor, because CALayer is very low. While CALayer does know CGColor
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

//        askQuestion(action: nil)
//
        askQuestion()
    }

//    func askQuestion(action: UIAlertAction!) {
//    func askQuestion(action: UIAlertAction! = nil) {
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = "\(countries[correctAnswer].uppercased()) Score: \(score)"
        
    }
    
    func endQuestion() {
        let ac = UIAlertController(title: "Final Question", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Restart", style: .default) { _ in
            self.score = 0
            self.askQuestion()
        })
        present(ac, animated: true)
    }
    
    @objc func shareTapped() {
        let text = "\(score) score in GuessTheFlag"
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var alertTitle: String
        var alertMessage: String
        
        if sender.tag == correctAnswer {
            alertTitle = "Correct"
            alertMessage = "You're right!"
            score += 1
        } else {
            alertTitle = "Wrong"
            alertMessage = "That’s the flag of \(countries[sender.tag].uppercased())"
            score -= 1
        }
        
        title = "\(countries[correctAnswer].uppercased()) Score: \(score)"
        
        let ac = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default) { _ in
            if self.score >= 10 {
                self.endQuestion()
            } else {
                self.askQuestion()
            }
        })
        present(ac, animated: true)
    }
}

