import UIKit

let score = 85

switch score {
case 0..<50:
    print("You failed badly.")
case 50..<85:
    print("You did OK.")
default:
    print("You did great!")
}

let names = ["Piper", "Alex", "Suzanne", "Gloria"]
print(names[1...3]) // ["Alex", "Suzanne", "Gloria"]
print(names[1...]) // ["Alex", "Suzanne", "Gloria"]

/*
 * Extra learning
 */

let range: ClosedRange = 0...10
print(range.first!) // 0
print(range.last!)  // 10

let nicknames = ["Antoine", "Maaike", "Jaap"]
for index in 0...2 {
    print("Name \(index) is \(nicknames[index])")
}
// Name 0 is Antoine
// Name 1 is Maaike
// Name 2 is Jaap

let halfRange: Range = 0..<10
print(range.first!) // 0
print(range.last!) // 9

print(nicknames[0..<nicknames.count]) // ["Antoine", "Maaike", "Jaap"]

