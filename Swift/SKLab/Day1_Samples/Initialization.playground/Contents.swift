class MyClass {
    var prop1 = 1
    var prop2: Int?
    // Initializer가 필요한 프로퍼티 - 없으면 에러
//    var prop3: Int
    var prop4: Int { return 0 }
}

class MyClass2 {
    var prop1, prop2 : Int
    
    init() {
        prop1 = 0; prop2 = 0
    }
    
    init(prop1: Int, prop2: Int) {
        self.prop1 = prop1
        self.prop2 = prop2
    }
}

class MyClass3 {
    var prop1, prop2 : Int
    
    convenience init() {
        self.init(prop1: 0, prop2: 0)
    }
    
    init(prop1: Int, prop2: Int) {
        self.prop1 = prop1
        self.prop2 = prop2
    }
    
    convenience init(prop1: Int) {
        self.init()
        self.prop1 = prop1
    }
}

class MyClass4 {
    var prop1: Int
    var prop2 = 0
    
    func otherTask() {}
    init(prop1: Int) {
//        otherTask()
        self.prop1 = prop1
    }
    
    convenience init() {
//        self.prop2 = 1
        self.init(prop1:0)
        self.prop2 = 1
    }
}

struct MyStruct {
    var value: Int
    init() {
        value = 0
    }
}
let st1 = MyStruct()
//let st2 = MyStruct(value: 10)

//
// 클래스 상속과 Initializer
//

class Parent {
    var value: Int
    init(value: Int) {
        self.value = value
    }
    convenience init() {
        self.init(value:0)
    }
}

class Child1: Parent {
    var value1 = 1
}

let obj1 = Child1(value: 10)
let obj2 = Child1()

class Child2: Parent {
    var value2: Int
    // 모든 부모 클래스의 designated initializer 재정의
    override init(value: Int) {
        value2 = 0
        super.init(value: 0)
    }
}

let obj3 = Child2(value: 20)
let obj4 = Child2()


