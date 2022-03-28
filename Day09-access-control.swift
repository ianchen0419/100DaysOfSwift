import UIKit

struct Person {
    private var id: String
    // only method inside the person can read out the id
    
    init(id: String) {
        self.id = id
    }
    
    func identify() -> String {
        return "My social security number is \(id)"
    }
    
}


let ed = Person(id: "12345")
// print(ed.id) // not allowed
ed.identify()
