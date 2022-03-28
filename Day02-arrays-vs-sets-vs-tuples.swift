import UIKit

// if you need a specific fixed collection of related values, where each item has a precise position or name, use `Tuple`
let address = (house: 555, street: "Taylor Swift Avenue", city: "Nashville")

// if needed collection of values that must be unique, or you need to be able to check whether a specific item is in there extremely quickly, use `Set`
let set = Set(["aardvark", "astronaut", "azalea"])

// if you need a collection of values that can contain duplicates or the order of your items matters, you should use an `Array`
let pythons = ["Eric", "Graham", "John", "Michael", "Terry", "Terry"]
