import UIKit

var number = 1

repeat {
    print(number)
    number += 1
} while number <= 20
            
print("Ready or not, here I come!")

while false {
        print("This is false") // never run
}

repeat {
    print("This is false") // run once
} while false

let numbers = [1, 2, 3, 4, 5]
var random = numbers.shuffled()

while random == numbers {
    random = numbers.shuffled()
}

var lessRandom: [Int]
repeat {
    random = numbers.shuffled()
} while random == numbers
