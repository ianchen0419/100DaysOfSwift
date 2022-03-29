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

class Person {
    var name = "Anonymous"
}

class Customer: Person {
    var id = 12345
}

class Employee: Person {
    var salary = 50_000
}

let customer = Customer()
let employee = Employee()
let people = [customer, employee]

for person in people {
    if let customer = person as? Customer {
        print("I'm a customer, with id \(customer.id)")
    } else if let employee = person as? Employee {
        print("I'm a employee, erning $\(employee.salary)")
    }
}
