//
//  ActionViewController.swift
//  Extension
//
//  Created by 陳怡安 on 2022/5/2.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {
    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageHost = ""
    var pageJavaScript = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(chooseFunction))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    let urlString = javaScriptValues["URL"] as? String ?? ""
                    let host = URL(string: urlString)?.host ?? ""
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageHost = host
                    
                    let dict = UserDefaults.standard.object(forKey: "SavedJavaScript") as? [String: String] ?? [String: String]()
                    guard let history = dict[host] else { return }
                    self?.pageJavaScript = history
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                        self?.script.text = self?.pageJavaScript
                    }
                    
                    
                }
            }
        }
        
    }

    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["CustomJavaScript": script.text as Any]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
        
        var dict = UserDefaults.standard.object(forKey: "SavedJavaScript") as? [String: String] ?? [String: String]()
        dict[pageHost] = script.text
        UserDefaults.standard.set(dict, forKey: "SavedJavaScript")
    }
    
    @objc func chooseFunction() {
        let ac = UIAlertController(title: "Select functions", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Alert title", style: .default) { [weak self] _ in
            self?.script.text = "alert(document.title);"
        })
        ac.addAction(UIAlertAction(title: "Alert device's dimension", style: .default) { [weak self] _ in
            self?.script.text = """
                alert(`device width: ${innerWidth} / device height: ${innerHeight}`)
            """
        })
        ac.addAction(UIAlertAction(title: "Alert page's dimension", style: .default))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window) // for rotated screen
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
        
    }

}
