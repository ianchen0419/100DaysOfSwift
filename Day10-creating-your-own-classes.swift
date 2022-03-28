import UIKit

class Dog {
    var name: String
    var breed: String
    
    init(name: String, breed: String) {
        self.name = name
        self.breed = breed
    }
    // class always need custom initializer
}

let poppy = Dog(name: "Poppy", breed: "Poodle")
