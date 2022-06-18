//
//  Person.swift
//  NamesToFaces
//
//  Created by Yi An Chen on 2022/4/8.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
