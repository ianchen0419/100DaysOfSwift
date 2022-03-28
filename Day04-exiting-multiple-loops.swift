import UIKit

outerLoop: for i in 1...10 {
    for j in 1...10 {
        let product = i * j
        print("\(i) * \(j) is \(product)")
        
        if product == 50 {
            print("It's a bullseye!")
            break outerLoop // exit both innerLoop and outerLoop
            // break: inneerLoop will be exited, while outerLoop will continue
        }
    }
}

let options = ["up", "down", "left", "right"]
let secretCombination = ["up", "up", "right"]


// labeled statements
outerLoop: for option1 in options {
    for option2 in options {
        for option3 in options {
            print("In loop")
            let attempt = [option1, option2, option3]
            
            if attempt == secretCombination {
                print("The combination is \(attempt)!")
                break outerLoop
            }
        }
    }
}
