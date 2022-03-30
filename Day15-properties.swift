import UIKit

struct Person {
    var clothes: String {
        willSet {
            updateUI(msg: "I'm changing from \(clothes) to \(newValue)")
        }
        
        didSet {
            updateUI(msg: "I just changed from \(oldValue) to \(clothes)")
        }
    }
}

func updateUI(msg: String) {
    print(msg)
}

var taylor = Person(clothes: "T-shirts")
taylor.clothes = "short skirts"

struct NewPerson {
    var age: Int
    
    var ageInDogYears: Int {
//        get {
//            return age * 7
//        }
        
        return age * 7
    }
}

var fan = NewPerson(age: 25)
print(fan.ageInDogYears)
