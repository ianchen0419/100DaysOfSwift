import UIKit

let str = "5"
let num = Int(str)! // crash operator

let url = URL(string: "https://www.apple.com")! // safe

let website = ""
let urlUnsafe = URL(string: "https://www.\(website)")! // unsafe

let randomNumber = (1...10).randomElement()! // safe

var items = [Int]()

func isLuckyNumber(_ number: Int) -> Bool {
    number.isMultiple(of: 2)
}

for i in 1...10 {
    if isLuckyNumber(i) {
        items.append(i)
    }
}

let randomNumberUnsafe = items.randomElement()! // unsafe

enum Direction: CaseIterable {
    case north, south, east, west
    
    static func random() -> Direction {
        Direction.allCases.randomElement()!
    }
}

let randomDirection = Direction.allCases.randomElement()! // safe

let randomDirectionBetter = Direction.random() // safe and better!


