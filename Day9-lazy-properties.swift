import UIKit

struct FamilyTree {
    init() {
        print("Creating family tree!")
    }
}


struct Person {
    var name: String
    lazy var familyTree = FamilyTree()
    // only create the Family struct when it's first accessed
    
    init(name: String) {
        self.name = name
    }
}

var ed = Person(name: "Ed")
ed.familyTree
