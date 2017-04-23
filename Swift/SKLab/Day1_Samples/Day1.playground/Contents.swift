//
// Protocol
//

protocol Singing { func sing() }
extension Singing {
    func singsing() { print("sing sing") }
}
class Bird: Singing {
    func sing() { print("Bird sing") }
}
extension Bird {
    func fly() { print("fly") }
}
extension String {
    func toInt() -> Int { return Int(self)!}
}
struct Cat: Singing {
    func sing() { print("Cat sing") }
}
let cat = Cat()
cat.singsing()

enum MyEnum: Singing {
    case one
    func sing() { print("Enum sing") }
}


//
// Clousre
//

func addTwoInt(_ a: Int, _ b: Int) -> Int { return a + b }
func addTwoInt(_ a: Int, _ b: Int, handler:((Int) -> Void)? ) {
    if let fn = handler {
        fn(a + b)
    }
}
func getAddFunc() -> (Int, Int) -> Int {
//    return { (a: Int, b: Int) -> Int in a + b }
    return { $0 + $1 }
}

let addFn = getAddFunc()
addFn(1, 2)
getAddFunc()(2, 3)

let retAdd = addTwoInt(1, 2)
print("1 + 2 = \(retAdd)")
addTwoInt(3, 4) { (ret : Int) in
    print("3 + 4 = \(ret)")
}
addTwoInt(5, 6, handler: nil)


func multiplyTwoInt(_ a: Int, _ b: Int) -> Int { return a * b }
var mathFn: (Int, Int) -> Int = addTwoInt
mathFn(2, 3)
mathFn = multiplyTwoInt
mathFn(2, 3)
mathFn = { (a: Int, b: Int) -> Int in return (a + b) * 2 }

let intArray = [1, 3, 2, 5, 4]
intArray.sorted(by: { (a: Int, b: Int) -> Bool in return a < b})
intArray.sorted(by: { (a, b) in return a < b})
intArray.sorted(by: { (a, b) in a < b})
intArray.sorted() { (a, b) in a < b}
intArray.sorted{ (a, b) in a < b}
intArray.sorted{ $0 < $1 }
intArray.sorted(by: < )


//
// Initializer
//

class MyClass {
//    var prop8 = 1
//    var prop9 : Int?
    var prop1, prop2 : Int
    convenience init() {
        self.init(prop1: 0, prop2: 0)
    }
    init(prop1 : Int, prop2 : Int) {
        self.prop1 = prop1; self.prop2 = prop2
    }
}

class Child: MyClass {
    var prop3: Int
    init(prop3 : Int) {
        self.prop3 = prop3
        super.init(prop1: 0, prop2: 0)
    }
    override init(prop1: Int, prop2: Int) {
        self.prop3 = 0
        super.init(prop1: prop1, prop2: prop2)
    }
}
let child1 = Child(prop1: 10, prop2: 10)
let child2 = Child()
let child3 = Child(prop3: 10)

// Failable Initializer
class YourClass {
    init?(_ value: Bool) {
        if value {
            return nil
        }
    }
}
let your: YourClass? = YourClass(false)

//
// Optional
//

let dictionary = ["a":1, "b":2]
let v1 = dictionary["a"]
let v2 = dictionary["c"]

if let item1 = v1, let item2 = v2 {
}
// optional binding - chain
//if let obj1 = func1(), let obj2 = obj1.func2() {
//    
//}

let num1: Int? = Int("123")
let num2: Int? = Int("abc")
let num3: Int = Int("111")!

let str1: String = String(1234)

func sayHello(msg: String?) {
    if let m = msg {
        print(m.lowercased())
    }
    
    guard let n = msg else {
        print("msg is nil")
        return
    }
    print(n.lowercased())
    
}

sayHello(msg: nil)
sayHello(msg: "Swift")



let i1 = 100
let i2 = i1.advanced(by: 1)

let i3: Int? = Int("123")?.advanced(by: 1)
let i4 = Int("abc")?.advanced(by: 1)

let i5: Int = Int("123")!.advanced(by: 1)
//let i6 = Int("abc")!.advanced(by: 1)

let i7 = Int("123") ?? 0
let i8 = Int("abc") ?? 0

let array1 : [Int]?
let array2 : [Int?]
let array3 : [Int?]?

var intVal: Int? = 0

let ret = intVal! + 1

//intVal = nil

//let ret2 = intVal! + 1

if let val = intVal {
    print("val : \(val + 1)")
}
else {
    print("intVal is nil")
}

if intVal != nil {
    intVal! + 1
}


//
// Struct
//
struct Task {
    var title: String
    var time: Int
}

//let task1 = Task()
let task2 = Task(title: "task1", time: 1)

var todayTasks = [Task]()
todayTasks.append(task2)
todayTasks += [ Task(title:"task2", time:2) ]


//
// Function
//
func sayHello(msg: String) {
    print("hello \(msg)")
}

sayHello(msg: "Swift")


func sayHello(msg: String, when arg: Int) {
    print("hello \(msg), times : \(arg)")
}

sayHello(msg: "Swift", when: 0)

func sayHello(_ msg: String) {
    print("Hello \(msg)!")
}
sayHello("iOS")
