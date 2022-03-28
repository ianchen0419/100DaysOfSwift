import UIKit

struct Person {
    var name: String
    
    mutating func makeAnonymous() {
        name = "Anonymous"
        // swift doesn't know `Person` will be instanced by `let` or by `var`
        // if we use `var person = Person(name: "Ad"), name can be changing afterward, so our method `makeAnonymous()` should work
        // while, for safe reason (can't predict `Person` wil be instanced by `let` or `var`), swift probit we to modify properties in the method
        // if we really use double `var`, we can add `mutating` to note that we will change this property safely
    }
}

var person = Person(name: "Ed")
person.makeAnonymous()
// mutating is only work with double `var` declaration (one in Struct, another in Struct instance)
