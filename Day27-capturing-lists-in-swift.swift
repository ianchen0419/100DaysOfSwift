import UIKit

class Singer {
    func playSong() {
        print("Shake it off!")
    }
    
    deinit {
        print("I'm die")
    }
}

for _ in 1...2 {
    let singer = Singer()
    singer.playSong()
}


/*
 * Strong capturing (Default), the closure will capture any external values that are used inside the closure, and make sure they never get destroyed
 */

func sing() -> () -> Void {
    let taylor = Singer()
    
    let singing = {
        taylor.playSong()
        // taylor is stays alive for as long as the closure exists somewhere, even after the function has returned
        return
    }
    
    return singing
}

let singFunction = sing()
singFunction()


/*
 * Weak capturing
 1. Weakly captured values aren't kept alive by the closure, so they might be destroyed and be set to nil
 2. As a result of 1, weakly capture values are always optional in Swift. This stops you assuming they are present when infact they might not be
 
 capture list can be determine how values used inside the closure should be captured
 */

func weakSing() -> () -> Void {
    let taylor = Singer()
    
    let singing = { [weak taylor] in
        taylor?.playSong() // taylor is only exists inside `weakSing()`
        return
    }
    
    return singing
}
// `[weak taylor]` is our capture list
let weakSingFunction = weakSing()
weakSingFunction()

/*
 * Unowned capturing
   Unowned capturing allows value to become nil at any point in the future, while you can work with them as if they are always going to be there, doesn't need to unwrap optionals
 */


func unownedSing() -> () -> Void {
    let taylor = Singer()
    
    let singing = { [unowned taylor] in
        taylor.playSong() // will crash
        return
    }
    // Unowned taylor says I know for sure that taylor will always exist for the lifetime of the closure I'm sending back so I don't need to hold on to the memory
    // but in practice, taylor will be destroyed almost immediately so the code will crash
    
    return singing
}

/*
 * Capture lists alongside parameters
   capture lists comes first
 */

//writeToLog { [weak self] user, message in
//    self?.addToLog("\(user) triggered event: \(message)")
//}

/*
 * Strong reference cycles (retain cycle)
 */

class House {
    var ownerDetails: (() -> Void)?
    
    func printDetails() {
        print("This is a great house.")
    }
    
    deinit {
        print("I'm being demolished!")
    }
}

class Owner {
    var houseDetails: (() -> Void)?
    
    func printDetails() {
        print("I own a house.")
    }
    
    deinit {
        print("I'm dying!")
    }
}

print("Creating a house and an owner")

do {
    let house = House()
    let owner = Owner()
    house.ownerDetails = owner.printDetails
    owner.houseDetails = house.printDetails
    // memory leak
}

print("Done")

print("Creating a house and an owner safely")

do {
    let house = House()
    let owner = Owner()
    house.ownerDetails = { [weak owner] in owner?.printDetails() }
    owner.houseDetails = { [weak house] in house?.printDetails() }
    // at leat one `weak` is enough
}

print("Done safely")

/*
 * Accidental strong reference
 */
func singAgain() -> () -> Void {
    let taylor = Singer()
    let adele = Singer()
    
    let singing = { [unowned taylor, adele] in
        taylor.playSong()
        adele.playSong()
        return
    }
    // taylor is captured by unowned, adele is captured strongly
    
    return singing
}

//[unowned taylor, unowned adele]


/*
 * Copying of closures
 */

var numberOfLinesLogged = 0

let logger1 = {
    numberOfLinesLogged += 1
    print("Lines logged: \(numberOfLinesLogged)")
}

logger1()
let logger2 = logger1
logger2()
logger1()
logger2()
// 1, 2, 3, 4

/*
 * Summarize
 */

// Unowned: if the captured value will never go away while the closure has any change of being called, use unowned
// Weak: if you have a strong reference cycle situation, one of them should use weak capturing (first destroyed one need weak)
// Strong: if no strong reference issue, use strong capturing
