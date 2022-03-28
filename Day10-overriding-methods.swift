import UIKit

class Dog {
    func makeNoice() {
        print("Woof!")
    }
}

class Poodle: Dog {
    override func makeNoice() {
        print("Yip!")
    }
}

let poppy = Poodle()
poppy.makeNoice()
