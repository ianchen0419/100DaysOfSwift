//
//  Country.swift
//  CountryLists
//
//  Created by Yi An Chen on 2022/4/15.
//

import Foundation

struct Country: Codable {
    let name: Name
    let capital: [String]?
    let population: Int
    let languages: [String: String]?
    let currencies: [String: Currency]?
    let area: Double
    let flag: String?
}

struct Currency: Codable {
    let name: String
    let symbol: String?
}


struct Name: Codable {
    let common: String
}
