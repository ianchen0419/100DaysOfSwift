//
//  DetailViewController.swift
//  CapitalCities
//
//  Created by 陳怡安 on 2022/4/23.
//

import WebKit
import UIKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var capitalTitle: String?
    var capitalURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = capitalTitle
        
        webView = WKWebView()
        guard let capitalURL = capitalURL else { return }
        webView.load(URLRequest(url: capitalURL))
        
        view = webView
        
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
