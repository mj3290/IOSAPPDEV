func sayHello() {
    print("Hello")
}

let fnObj = sayHello

let fnObj1: () -> () = sayHello
let fnObj2: (Void) -> Void = sayHello


func nextNumber(value: Int) -> Int {
    return value + 1
}

let fnObj3: (Int) -> Int = nextNumber
fnObj3(3)

func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}

func multiplyTwoInts(_ a: Int, _ b: Int) -> Int {
    return a * b
}

var mathFunction: (Int, Int) -> Int = addTwoInts
mathFunction(2, 3)

mathFunction = multiplyTwoInts
mathFunction(2, 3)


let array = [1, 3, 4, 2, 5]
func sortFn(_ a: Int, _ b: Int) -> Bool {
    return a < b
}
array.sorted(by: sortFn)
array.sorted(by: { (a, b) -> Bool in
    a < b
})
array.sorted { return $0 < $1 }
