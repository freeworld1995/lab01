//: Playground - noun: a place where people can play

import UIKit

let title = "adele"

let url = "http://api.mp3.zing.vn/api/mobile/search/song?requestdata={\"q\":\"\(title)\", \"sort\":\"hot\", \"start\":\"0\", \"length\":\"5\"}"

print(url)

let duration = 60 % 60

func secondsToMinutesSeconds (seconds : Int) -> ( minute: Int, second: Int) {
    return ( (seconds % 3600) / 60, (seconds % 3600) % 60)
}

secondsToMinutesSeconds(seconds: 60).minute