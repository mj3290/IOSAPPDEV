//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
str
1 + 2
print (str)

func sayHello(msg: String){
    print("hello \(msg)")
}

sayHello(msg: "안녕")


func sayHello(msg : String, when arg : Int){
    print("hello \(msg), times : \(arg)")
}

sayHello(msg : "Swift", when :0)


func sayHello(_ msg : String){
    print( "hello \(msg)")
}

sayHello(msg: "test")


sayHello("ios")

struct Point{
    var x = 0
    var y = 0
}

var p1 = Point()
p1.x = 10
p1.y = 20


print(p1)

struct Size{
    var width : Int
    var height : Int
}

var s1 = Size( width: 10, height : 20)
print( s1)

struct ValueStruct{
    var value: Int = 10
    func showValue(){
        print("val : \(value)")
    }
    
    mutating func increase(){
        value += 1
    }
}

var v1 = ValueStruct()
v1.increase()
v1.showValue()

class ValueClass
{
    // stored property
    var value = 0 {
        willSet {   print("willset \(newValue)")}
        didSet { print("willset \(oldValue)")    }
    }
}

var obj = ValueClass()
obj.value = 10
obj.value = 20




struct Task{
    var title : String
    var time : Int
}

var todayTask:[Task] = []
var todayTask2 = Array<Task>()


var t1 = Task( title : "job1", time : 9)
todayTask.append(t1)

var t2 = Task( title : "job2", time : 10)
todayTask.append(t2)

print (todayTask)

todayTask2 += [ Task( title : "j1", time : 1) ]
todayTask2 += [ Task( title : "j2", time : 2) ]


print (todayTask2)



var intVal : Int? = 0
if let val = intVal {
    print("plus one = \(val+1)")
}
else{
    print("nil")
}


var ii = intVal! + 1
print (ii)

if intVal != nil {
    intVal! + 1
}


let dictionary = ["a":1, "b":2]
let v = dictionary["a"]
let v2 = dictionary["c"]

if let item1 = v, let item2 = v2 {
    
}



let num1 : Int? = Int("123")
let num2 : Int? = Int("abc")


let num3 : Int = Int("123")!

let str1 : String = String(1234)

func sayHello2(msg : String?)
{
    if let m =  msg {
        print(m.lowercased())
    }
    
    guard let n  = msg else {
        print( "msg is nil")
        return
    }
    
    print( n.lowercased() )
}

sayHello2(msg  : nil)
sayHello2(msg : "KIM DONG WOO")


let i1 =  100
let i2 = i1.advanced(by: 1)

let i3 = Int("abc")?.advanced(by: 1)


let numstr = "123"
let i4 = Int(numstr) ?? 0
let i5 = Int("abc") ?? 0


let array1 : [Int]?
let array2 : [Int?]
let array3 : [Int?]?


var funcObj1 : (String)->()
let funcObj : (String)->() = sayHello2
funcObj("test")

funcObj1 = funcObj
funcObj1("mytest")

// 클로저

func addTwoInt( _ a : Int, _ b : Int) -> Int { return a + b }

//  클로저 파라미터이면서 옵셔널 적용
func addTwoInt( _ a : Int, _ b : Int, handler:((Int) ->Void)?) {
    if let fn = handler {
        fn( a + b)
    }
}

addTwoInt(3, 4) {
    (ret : Int) in print("3+4=\(ret)")
}

func getAddFunc() -> (Int, Int) -> Int {
   // return { (a: Int, b: Int) -> Int in a + b }
    return { $0 + $1 }
}

let addFn  = getAddFunc()
addFn(1, 2)
getAddFunc()(1,2)


func multiplyTwoInt( _ a : Int, _ b : Int) -> Int {
    return a * b
}

var mathFn : (Int, Int) -> Int
mathFn = { (a: Int, b: Int) -> Int in return (a + b) * 2 }

let intArray = [ 1,4,2,5,7]
intArray.sorted(by : { (a : Int, b: Int) -> Bool in return a < b})
intArray.sorted(by: { (a, b) in return a < b})
intArray.sorted(by: { (a, b) in a < b } )
intArray.sorted() { (a, b) in a < b }
intArray.sorted { (a, b) in a < b }
intArray.sorted{$0 < $1}
intArray.sorted(by: <)


class Wing{
    var prop : Int?
    
    var wings = 2
}

protocol Singing { func sing() }
extension Singing { func singsing() {
        print("sing sing")
    }
}

class Bird : Wing, Singing {
    func sing() {
        if let p = prop {
            print("sing \(p)")
        }
        
    }
}
extension Bird {
    func fly() { print("fly") }
}

extension String {
    func toInt() -> Int {
        return Int(self)!
    }
}

struct Cat : Singing{
    func sing() { print("meow") }
}

let cat = Cat()
cat.singsing()
cat.sing()






