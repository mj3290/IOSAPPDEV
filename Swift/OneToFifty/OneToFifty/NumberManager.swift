//
//  NumberManager.swift
//  OneToFifty
//
//  Created by Kim Dong-woo on 2017. 4. 20..
//  Copyright © 2017년 Kim Dong-woo. All rights reserved.
//

import Foundation

let isNotCorrect = -1
let nomoreNumber = -2

/// 1~50에 필요한 숫자를 생성 관리
class NumberManager {
    
    private var selectedNumber:Int = 1
    private var curNumber = 1
    
    private var arrNumberSideOne:[Int] = []
    private var arrNumberSideTwo:[Int] = []
    private var dicPressNumber:[Int:Int] = [:]
   
    /// 눌린 숫자 다음 숫자를 돌려준다
    ///
    /// - Parameter clickNumber: 눌린숫자
    /// - Returns: 다음 숫자
    func UpdateNumber( clickNumber : Int ) -> Int {
        if clickNumber != displayValue {
            return isNotCorrect
        }
        
        selectedNumber += 1
        
        let nCount:Int = arrNumberSideTwo.count
        if nCount == 0 {
            return nomoreNumber
        }
        
        let nNext:Int = arrNumberSideTwo[nCount-1]
        arrNumberSideTwo.remove(at: nCount-1)
        
        return nNext
    }
    
    /// 숫자 초기화
    func InitNumber() {
        dicPressNumber.removeAll()
        
        for i in 1...51 {
            dicPressNumber[i] = i
        }
        
        arrNumberSideOne.removeAll()
        arrNumberSideTwo.removeAll()
        
        ScrambleSideOne()
        ScrambleSideTwo()
        
        displayValue = 1
        nextNumber = 1
    }
    
    /// 최초 1~25까지 필요한 숫자를 만든다
    ///
    /// - Returns: 최초 버튼에 보여줄 숫자들
    func getFirstSettingNumber() -> [Int] {
        return arrNumberSideOne
    }
    
    /// 1~25까지 숫자를 랜덤하게 생성
    ///
    /// - Returns: 랜덤하게 생성된 숫자
    private func GetNextNumberSideOne() -> Int {
        
        let nKey:Int = Int(arc4random_uniform(26))
        let nNext = dicPressNumber[nKey]
        if let nVal = nNext {
            let nTemp = nVal
            if nTemp != -1 {
                dicPressNumber[nKey] = -1
                return nTemp
            }
        }
        
        return -1
    }
    
    /// 26~50까지 숫자를 랜덤하게 생성
    ///
    /// - Returns: 랜덤하게 생성된 숫자
    private func GetNextNumberSideTwo() -> Int {
        while true {
            let nKey:Int = Int(arc4random_uniform(51))
            if nKey <= 25 {
                
            }
            else {
                let nNext  = dicPressNumber[nKey]
                
                if let nVal = nNext {
                    let nTemp = nVal
                    if nTemp != -1 {
                        dicPressNumber[nKey] = -1
                        return nTemp
                    }
                }
                else {
                    break
                }
            }
        }
        return -1
    }
    
    /// 숫자를 섞는다 (1~25)
    private func ScrambleSideOne() {
        var index:Int = 0
        while true {
            if index == 25 {
                break
            }
            
            let nVal:Int = GetNextNumberSideOne()
            if nVal == -1 {
                continue
            }
            
            index += 1
            
            print("ScrambleSideOne \(nVal)")
            arrNumberSideOne.append(nVal)
        }
    }
    
    /// 숫자를 섞는다 (26~50)
    private func ScrambleSideTwo() {
        var index:Int = 0
        while true {
            if index == 25 {
                break
            }
            
            let nVal:Int = GetNextNumberSideTwo()
            if nVal == -1 {
                continue
            }
            
            index += 1
            
            print("ScrambleSideTwo \(nVal)")

            arrNumberSideTwo.append(nVal)
        }

    }
    
    
    var displayValue : Int {
        get {
            return selectedNumber
        }
        set {
            selectedNumber = newValue
        }
    }
    
    var nextNumber : Int {
        get {
            curNumber += 1
            return curNumber
        }
        set {
            curNumber =  newValue
        }
    }
}
