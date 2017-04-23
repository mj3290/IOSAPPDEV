//: Playground - noun: a place where people can play

import UIKit

class myClass {
    var prop1 : Int
    var prop2 : Int
    
    
    convenience init(){
        self.init(p1: 1, p2: 1)
    }
    
    init( p1 : Int, p2 : Int){
        self.prop1 = p1
        self.prop2 = p2
    }
    
    func fff() {
        print("fff")
    }
}


class Child : myClass{
    var prop3 : Int
    init( prop3  : Int){
        self.prop3  = prop3
        super.init(p1: 0, p2: 0)
    }
    override init(p1 : Int, p2 : Int){
        self.prop3 = 0
        super.init(p1: p1, p2: p2)
        
    }
}



let child = Child(prop3 : 0)
child.fff()



class yourClass{
    init?(_ value : Bool){
        if value == nil {
            return nil
        }
    }
    
    deinit{
        print("dinit")
    }
    
}

let your : yourClass? = yourClass(false)

var cls : yourClass! = yourClass(false)

cls = nil




