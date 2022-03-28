import UIKit

struct User {
    var username: String
}

var user = User(username: "ianchen0419")

struct UserWithInit {
    var username: String
    
    init() {
        username = "Anonymous"
        print("Creating a new user!")
    }
}
var newUser = UserWithInit()
newUser.username = "ianchen0419"

struct UserTest {
    var username = "Anonymous"
}
var userTest = UserTest()
userTest.username = "ianchen0419"

