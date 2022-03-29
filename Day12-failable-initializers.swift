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

struct Empolyee {
    var username: String
    var password: String
    
    init?(username: String, password: String) {
        guard password.count >= 8 else { return nil }
        guard password.lowercased() != "password" else { return nil }
        
        self.username = username
        self.password = password
    }
}

let tim = Empolyee(username: "TimC", password: "app1e")
print(tim) // nil
let craig = Empolyee(username: "CraigF", password: "ha1rf0rce0ne")
print(craig) // Optional(__lldb_expr_20.Empolyee(username: "CraigF", password: "ha1rf0rce0ne"))
