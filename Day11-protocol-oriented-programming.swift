import UIKit

protocol Identifiable {
    var id: String { get set }
    func identify()
}

extension Identifiable {
    func identify() {
        print("My ID is \(id).")
    }
}

struct User: Identifiable {
    var id: String
}

let ianchen0419 = User(id: "ianchen0419")
ianchen0419.identify()
