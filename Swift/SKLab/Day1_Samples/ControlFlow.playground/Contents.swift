//
// For
//

for i in 0..<10 {
    print("For 반복문 \(i)")
}
for item in [1, 2, 3, 4, 5] {
    print(item)
}

// With-Dictionary

var roomCapacity: [String:Int] = ["Bansky":4, "Rivera":8, "Kahlo":8, "Picasso": 10]
for (roomName, capacity) in roomCapacity {
    // 튜플을 이용한 딕셔너리 원소 순회
}


//
// While, Repeat-While
//

var i = 0
while i < 10 {
    i += 1
}

repeat {
    i += 1
} while i < 20


//
// if, guard
//


let array = [1, 2, 3, -1, 4, 5]

for item in array {
    guard item > 0 else {
        print("0 이하의 값 발견")
        break
    }
}

//
// Switch - Case
//

let value = (1, 4)

switch value {
case (0, 0):
    print("0, 0")
case (0, 1..<10):
    print("0, 1..<10")
case (0, let y):
    print("0, \(y)")
case (1, let y) where y >= 3:
    print("1, 3 이상")
default:
    print("Other")
}
