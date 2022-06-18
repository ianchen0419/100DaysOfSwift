//
//  DetailViewController.swift
//  WhitehousePetitions
//
//  Created by Yi An Chen on 2022/4/3.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never

        guard let detailItem = detailItem else { return }
        
        let html = """
        <html>
        <head>
            <meta name ="viewport" content="width=device-width, initial-scale=1">
            <style>
                table {
                    margin-top: 24px;
                    border: 1px solid #ccc;
                    border-collapse: collapse;
                }
        
                th, td {
                    border: 1px solid #ccc;
                }
            </style>
        </head>
        <h2>\(detailItem.title)</h2>
        <p>\(detailItem.body)</p>
        
        <h4>Signature Count</h4>
        <p>\(detailItem.signatureCount)</p>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)

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
