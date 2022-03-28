import UIKit

class Person {
    var name = "John Doe"
    
    static let secretNumber = "123"
    
    init() {
        print("\(name) is alive!")
    }
    
    func printGreeting() {
        print("Hello, I'm \(name)")
    }
    
    deinit {
        print("\(name) is no more!")
    }
}

class John: Person {

}

print(John.secretNumber)

for _ in 1...3 {
    let person = Person()
    person.printGreeting()
}
