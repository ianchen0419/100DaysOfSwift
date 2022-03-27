import UIKit

let driving = { (place: String) in
    print("I'm going to \(place) in my car")
}

// one of the difference between functions and closures is that you don't use parameter labels when running closures
driving("London")
