//
//  Move.swift
//  Four-in-a-Row
//
//  Created by 陳怡安 on 2022/8/1.
//

import GameplayKit
import UIKit

class Move: NSObject, GKGameModelUpdate {
    var value: Int = 0
    var column: Int
    
    init(column: Int) {
        self.column = column
    }
}
