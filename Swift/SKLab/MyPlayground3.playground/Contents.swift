//: Playground - noun: a place where people can play

import UIKit
import Foundation

let str1 = "one fish two fish red fish blue fish"

let str2 = "testing, 1, 2 testing"
let str3 = "car : carpet as java : javascript!!&$%^&"




func wordCount( _ str : String ) {
    var findDic:[String:Int] = [:]
    var strArr:[String] = []
    let chSet = CharacterSet(charactersIn: " ,!&$%^&:")
    strArr = str.components(separatedBy: chSet).filter { $0 != "" }
    
    var i: Int = 0
  
    for _ in 0...strArr.count-1 {
        
        var ret = findDic[ strArr[i] ]
        if let r  = ret {
            var ii: Int = r
            ii += 1
            findDic[ strArr[i]] = ii
        }
        else {
            findDic[ strArr[i] ] = 1
        }
        
        i += 1
    }
    
    print( findDic )
    
}

wordCount(str1)
wordCount(str2)
wordCount(str3)



