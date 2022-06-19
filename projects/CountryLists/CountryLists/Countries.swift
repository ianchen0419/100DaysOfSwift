//
//  Countries.swift
//  CountryLists
//
//  Created by Yi An Chen on 2022/4/15.
//

import Foundation

struct Countries: Codable {
    var results: [Country]
    
    init() {
        guard let url = Bundle.main.url(forResource: "countries", withExtension: "json") else {
            fatalError("Failed to locate file in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load tile from bundle.")
        }
        
        guard let loaded = try? JSONDecoder().decode([Country].self, from: data) else {
            fatalError("Failed to decode file from bundle.")
        }
        
        self.results = loaded
    }
}
