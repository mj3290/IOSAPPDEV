import Foundation

struct MyStruct {
    var varProp = 1
    let letProp = 1
}

var obj1 = MyStruct()
obj1.varProp = 2
//obj1.letProp = 2

print("obj1 : \(obj1)")

let obj2 = MyStruct()
//obj2.varProp = 3
//obj2.letProp = 3
print("obj2 : \(obj2)")


struct Point {
    var x = 0
    var y = 0
}

var p1 = Point()
p1.x = 10
p1.y = 10

var p2 = Point(x: 20, y: 20)

print("point1 : \(p1)")
print("Point2 : \(p2)")

struct Size {
    var width: Double
    var height: Double
    
    var area: Double {
        get {
            return width * height
        }
        set {
            width = sqrt(newValue)
            height = sqrt(newValue)
        }
    }
}

var s1 = Size(width: 30, height: 30)
print("size s1 : \(s1), area : \(s1.area)")

s1.area = 10000
print("size s1 : \(s1), area : \(s1.area)")


struct ValueStruct {
    var value : Int = 0
    func showValue() {
        print("value : \(value)")
    }
    mutating func increse() {
        value += 1
    }
}

var v = ValueStruct()
v.increse()
v.showValue()