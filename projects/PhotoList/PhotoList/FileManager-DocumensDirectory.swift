//
//  FileManager-DocumensDirectory.swift
//  PhotoList
//
//  Created by Yi An Chen on 2022/4/10.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
