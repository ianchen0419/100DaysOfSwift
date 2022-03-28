import UIKit

struct Student {
    static var classSize = 0
    // share specific properties and methods across all instance
    var name: String
    
    init(name: String) {
        self.name = name
        Student.classSize += 1
    }
}

let ed = Student(name: "Ed")
let taylor = Student(name: "Taylor")
print(Student.classSize)
