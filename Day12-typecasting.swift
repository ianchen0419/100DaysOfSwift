import UIKit

class Animal {}
class Fish: Animal { }

class Dog: Animal {
    func makeNoise() {
        print("Woof!")
    }
}

let pets = [Fish(), Dog(), Fish(), Dog()] // [Animal]

// as?, it will be nil if the typecast failed, or a converted type otherwise.

for pet in pets {
    if let dog = pet as? Dog {
        dog.makeNoise()
    }
}

//Woof!
//Woof!
