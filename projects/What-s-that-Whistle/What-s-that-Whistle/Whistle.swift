//
//  Whistle.swift
//  What-s-that-Whistle
//
//  Created by 陳怡安 on 2022/7/30.
//

import CloudKit
import UIKit

class Whistle: NSObject {
    var recordID: CKRecord.ID!
    var genre: String!
    var comments: String!
    var audio: URL!
}
