import UIKit

extension Int {
    func square() -> Int {
        return self * self
    }
}

let number = 8
print(number.square())

extension Int {
    var isEven: Bool {
        return self % 2 == 0
    }
}

