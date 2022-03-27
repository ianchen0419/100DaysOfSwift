import UIKit
import Foundation

enum Sizes: Comparable {
    case small
    case medium
    case large
}

let first = Sizes.small
let second = Sizes.large
print(first < second) // true, because `small` comes before `large` in the enum case list
