import UIKit

let str = "5"
let num = Int(str)! // crash operator

let url = URL(string: "https://www.apple.com")! // safe
//let url = URL(string: "https://www.\(website)")! // unsaefe

let randomNumber = (1...10).randomElement()! // safe

//var items = [Int]()
//
//for i in 1...10 {
//    if isLuckyNumber(i) {
//        items.append(i)
//    }
//}
//
//let randomNumber = items.randomElement()! // unsafe


enum Direction: CaseIterable {
    case north, south, east, west
}

let randomDirection = Direction.allCases.randomElement()! // safe

enum GoodDirection: CaseIterable {
    case north, south, east, west

    static func random() -> Direction {
        Direction.allCases.randomElement()! // better solution
    }
}
let GoodRandomDirection = GoodDirection.random()

