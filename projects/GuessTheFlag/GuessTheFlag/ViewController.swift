//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Yi An Chen on 2022/3/31.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var count = 0
    var score = 0
    var correctAnswer = 0
    var tappedButton: UIButton!
    
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
        
        registerLocal()
    }
    
    func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            if granted {
                print("Yay!")
                self?.scheduleLocal()
            } else {
                print("No!")
            }
        }
    }
    
    func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        
        let content = UNMutableNotificationContent()
        content.title = "Time for GuessTheFlag"
        content.body = "Let's play game and take break!"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 21
        dateComponents.minute = 7
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
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
        var message = ""
        
        if let highestScore = UserDefaults.standard.object(forKey: "HighestScore") as? Int {
            if score > highestScore {
                UserDefaults.standard.set(score, forKey: "HighestScore")
                message = "You've got the highest score of \(score)."
            }
        } else {
            UserDefaults.standard.set(score, forKey: "HighestScore")
            message = "You've got the highest score of \(score)."
        }
        
        let ac = UIAlertController(title: "Final Question", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
            self?.tappedButton.transform = .identity
            self?.score = 0
            self?.count = 0
            self?.askQuestion()
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
        
        count += 1
        
        title = "\(countries[correctAnswer].uppercased()) Score: \(score)"
        
        let ac = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default) { [weak self] _ in
            self?.tappedButton.transform = .identity
            guard let count = self?.count else { return }
            if count >= 10 {
                self?.endQuestion()
            } else {
                self?.askQuestion()
            }
        })
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, options: []) {
            self.tappedButton = sender
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in }
        
        self.present(ac, animated: true)
        
    }
}

