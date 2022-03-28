import UIKit

// all parameters passed into a swift function are constants, so you can't change them
// if you want to change, you can pass in one or more parameters as `inout`
// `inout` means they can be changed inside your function, and those changes reflect in the original value outside the function

func doubleInPlace(number: inout Int) {
    number *= 2
}

// need to use variable intergre
var myNum = 10
doubleInPlace(number: &myNum)
print(myNum)

func +(leftNumber: Int, rightNumber: Int) -> Int {
    // code here
    return 0
}

func +=(leftNumber: inout Int, rightNumber: Int) {
    //code here
}
