import UIKit

struct Person {
    var name: String
    
    init(name: String) {
        print("\(name) wass born!")
        self.name = name
        // self.name refer to property
        // name refer to parameter
    }
}
