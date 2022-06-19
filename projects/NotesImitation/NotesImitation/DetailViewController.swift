//
//  DetailViewController.swift
//  NotesImitation
//
//  Created by 陳怡安 on 2022/5/14.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var textView: UITextView!
    var note = ""
    var homeVC: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = note
        
        let more = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(more))
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItems = [done, more]
        navigationItem.largeTitleDisplayMode = .never
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window) // for rotated screen
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let newNote = textView.text else { return }
        guard let homeVC = homeVC else { return }

        homeVC.save(oldNote: note, newNote: newNote)
    }
    
    
    @objc func done() {
        textView.endEditing(true)
    }
    
    @objc func more() {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Share", style: .default, handler: share))
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: delete))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?.last
        present(ac, animated: true)
    }
    
    func share(action: UIAlertAction?) {
        let vc = UIActivityViewController(activityItems: [note], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?.last
        present(vc, animated: true)
    }
    
    func delete(action: UIAlertAction?) {
        navigationController?.popToViewController(homeVC, animated: true)
        homeVC.delete(note)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
