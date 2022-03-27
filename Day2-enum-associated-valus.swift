import UIKit

enum Activity {
    case bored
    case running(destination: String)
    case talking(topic: String)
    case singing(volumn: Int)
}

let talking = Activity.talking(topic: "football")
print(talking)
