//
//  ViewController.swift
//  Debugging
//
//  Created by 陳怡安 on 2022/4/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        assert(1 == 1, "Math failure!") // won't show
//        assert(1 == 2, "Math failure!") // show and terminate app
        
        assert(myReallySlowMethod() == true, "The slow method returned false, which is a bad thing.")
    }
    
    func myReallySlowMethod() {
        
    }

}

