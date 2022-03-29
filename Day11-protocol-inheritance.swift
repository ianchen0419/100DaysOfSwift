import UIKit

protocol Payable {
    func calculateWages() -> Int
}

protocol NeedsTraining {
    func study()
}

protocol HasVacation {
    func takeVacation(days: Int)
}

protocol Employee: Payable, NeedsTraining, HasVacation { }

//protocol Computer {
//    var price: Double { get set }
//    var weight: Int { get set }
//    var cpu: String { get set }
//    var memory: Int { get set }
//    var storage: Int { get set }
//}
//
//protocol Laptop {
//    var price: Double { get set }
//    var weight: Int { get set }
//    var cpu: String { get set }
//    var memory: Int { get set }
//    var storage: Int { get set }
//    var screenSize: Int { get set }
//}

protocol Product {
    var price: Double { get set }
    var weight: Int { get set }
}

protocol Computer: Product {
    var cpu: String { get set }
    var memory: Int { get set }
    var storage: Int { get set }
}

protocol Laptop: Computer {
    var screenSize: Int { get set }
}
