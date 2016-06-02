//: Playground - noun: a place where people can play

import UIKit

var str = "foundPalindrome"

var strLength = count(str)

if strLength % 2 == 0 {
    println(strLength / 2)
} else {
    println(strLength / 2)
    for c in str {
        
    }
    for i in 0..<strLength / 2 {
//        println(Array(str)[i])
        println("\(Array(str)[i]) - \(Array(str)[(strLength - 1) - i])")
    }
}