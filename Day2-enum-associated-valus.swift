import UIKit

enum Activity {
    case bored
    case running(destination: String)
    case talking(topic: String)
    case singing(volumn: Int)
}

let talking = Activity.talking(topic: "football")
print(talking)

enum Weather {
    case sunny
    case windy(speed: Int)
    case rainy(chance: Int, amount: Int)
}

// enum with associated value try to resolve problems like this
enum ComplexWeather {
    case sunny
    case lightBreeze
    case aBitWindy
    case quiteBlueteryNow
    case nowThatsAStrongWind
    case thisIsSeriousNow
    case itsAHurricane
}
