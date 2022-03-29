import UIKit

let python = ["Eric", "Graham", "John", "Michael", "Terry", "Terry"]
let beatles = Set(["John", "Paul", "George", "Ringo"])

extension Collection {
    func summarize() {
        print("There are \(count) of us.")
        
        for name in self {
            print(name)
        }
    }
}

python.summarize()
beatles.summarize()
