import UIKit
import Foundation

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

/*
 * Extra Learning
 */


enum TrackingEvent: String {
    case loggedIn //rawValue: string of "loggedIn"
}

func track(_ event: TrackingEvent) {
    print("Tracked \(event.rawValue)")
}
track(.loggedIn) // Tracked loggedIn


// enum to array
enum SocialPlatform: String, CaseIterable {
    case twitter
    case facebook
    case instagram
}
print(SocialPlatform.allCases) // Array: ["twitter", "facebook", "instagram"]

// enum and equatable

// enum has built-in equatable like this
enum NewSocialPlatform {
    case twitter
    case facebook
    case instagram
}

let mostUsedPlatform = SocialPlatform.twitter

if mostUsedPlatform == .facebook {
    print("Face news")
} else {
    print("You're totally right!")
}

// whereas, if you use enum with associated values, you should add `Equatable` protocal manually
enum TimeInterval: Equatable {
    case seconds(Int)
    case milliseconds(Int)
    case microseconds(Int)
    case nanoseconds(Int)
}

if TimeInterval.seconds(1) == .seconds(2) {
    print("Matching!")
} else {
    print("Not matching!")
}

// use case with switch fallthrough
enum ImageType {
    case jpeg
    case png
    case gif
}

let imageTypeToDescribe = ImageType.gif

var description = "The image type \(imageTypeToDescribe) is"

switch imageTypeToDescribe {
case .gif:
    description += " animatable, and also"
    fallthrough
default:
    description += " an image."
}
print(description) // The image type gif is animatable, and also an image.
