import UIKit

enum Plant: Int {
    case mercury = 1 // and now, earth is 3 planet
    case venus
    case earth
    case mars
}
// swift will automatically assign each of those a number starting from 0
let earth = Plant(rawValue: 2)

print(Plant.mercury.rawValue) // 1
print(Plant.earth.rawValue) // 3

enum Mood {
    case happy
    case sad
    case grumpy
    case sleepy
    case hungry
}

// If we need to download a data from server to get user's mood data list, we need know the value of enum `Mood` items represented
enum MoodWithValue: Int {
    case happy
    case sad
    case grumpy
    case sleepy
    case hungry
}
