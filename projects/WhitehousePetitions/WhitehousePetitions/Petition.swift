//
//  Petition.swift
//  WhitehousePetitions
//
//  Created by Yi An Chen on 2022/4/2.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}

