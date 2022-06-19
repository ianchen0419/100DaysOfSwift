import Foundation

/*
 Challenge 1
 
 Create a String extension that adds a withPrefix() method. If the string already contains the prefix it should return itself; if it doesn’t contain the prefix, it should return itself with the prefix added. For example: "pet".withPrefix("car") should return “carpet”.
 */
extension String {
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return self
        } else {
            return prefix + self
        }
    }
}

assert("pet".withPrefix("car") == "carpet", "challenge 1 failed")
assert("carpet".withPrefix("car") == "carpet", "challenge 1 failed")

/*
 Challenge 2
 
 Create a String extension that adds an isNumeric property that returns true if the string holds any sort of number.  v
 */

extension String {
    func isNumeric() -> Bool {
        return Int(self) != nil || Double(self) != nil
    }
}
assert("123".isNumeric() == true, "challenge 2 failed")
assert("123.123".isNumeric() == true, "challenge 2 failed")
assert("12w".isNumeric() == false, "challenge 2 failed")
assert("www".isNumeric() == false, "challenge 2 failed")

/*
 Challenge 3
 
 Create a String extension that adds a lines property that returns an array of all the lines in a string. So, “this\nis\na\ntest” should return an array with four elements.
 */


extension String {
    var lines: Int {
        return self.split(separator: "\n").count
    }
}

let newSentence = """
This is
a sentence
"""

assert("this\nis\na\ntest".lines == 4, "challenge 3 failed")
assert(newSentence.lines == 2, "challenge 3 failed")
assert("string".lines == 1, "challenge 3 failed")
