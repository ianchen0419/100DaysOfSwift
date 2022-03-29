import UIKit

let str = "5"
let num = Int(str) // failable initializer

struct Person {
    var id: String
    
    init?(id: String) {
        if id.count == 9 {
            self.id = id
        } else {
            return nil
        }
    }
}

let person = Person(id: "123123123") // Person?
