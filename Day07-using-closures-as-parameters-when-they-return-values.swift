import UIKit

func travel(action: (String) -> String) {
    print("I'm getting ready to go.")
    let description = action("London")
    print(description)
    print("I arrived!")
}

travel { (place: String) -> String in
    return "I'm going to \(place) in my car"
}

func reduce(_ values: [Int], using closure: (Int, Int) -> Int) -> Int {
    var current = values[0]
    
    for value in values[1...] {
        current = closure(current, value)
    }
    
    return current
}


let numbers = [10, 20, 30]

let sum = reduce(numbers) { (runningTotal: Int, next: Int) -> Int in
    runningTotal + next
}

let sumWithoutTypeAnnotation = reduce(numbers) { (runningTotal, next) in
    runningTotal + next
} // can omit closure's type annotation

print(sum)
print(sumWithoutTypeAnnotation)

let multiplied = reduce(numbers) { (runningTotal: Int, next: Int) in
    runningTotal * next
}
print(multiplied)

let sumNeatly = reduce(numbers, using: +)
print(sumNeatly)
