import UIKit

enum PasswordError: Error {
    case obvious
}

func checkPassword(_ password: String) throws -> Bool {
    if password == "password" {
        throw PasswordError.obvious
    }
    
    return true
}

do {
    try checkPassword("password")
    print("That password is good!")
} catch {
    print("You can't use that password.")
}

// try? will changes throwing functions into functions that return an optional. If function throws error, it will return `nil`
if let result = try? checkPassword("password") {
    print("Result was \(result)")
} else {
    print("D'oh.")
}

// try! will use on the function will never fail, if the function does throw error, our code will crash
try! checkPassword("sekrit")
print("OK!")
