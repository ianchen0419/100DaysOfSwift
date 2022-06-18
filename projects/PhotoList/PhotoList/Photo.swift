//
//  Photo.swift
//  PhotoList
//
//  Created by Yi An Chen on 2022/4/10.
//

import Foundation

class Photo: Codable {
    var image: String
    var caption: String
    
    init(image: String, caption: String) {
        self.image = image
        self.caption = caption
    }
}
