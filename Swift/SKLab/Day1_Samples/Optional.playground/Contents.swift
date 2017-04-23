var intVal: Int = 0
// 에러
//intVal = nil

var intOptVal: Int? = 0
intOptVal = nil

var strOptVal: String? = nil

intOptVal = 1
//let ret = intOptVal + 2


if let val = intOptVal {
    print("plus one = \(val + 1)")
}
else {
    print("nil이다!")
}

let ret = intOptVal! + 1


var doubleOptVal: Double! = 1
let ret2 = doubleOptVal + 2

doubleOptVal = nil
//let ret3 = doubleOptVal + 3

