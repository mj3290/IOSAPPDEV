//
// 배열
//

var meetingRooms: Array<String> = ["Bansky", "Kahlo"]

// 새 원소 추가
meetingRooms.append("Picasso")
meetingRooms += ["Cezanne", "Matisse"]
meetingRooms.insert("Rivera", at: 1)

// 원소 접근
meetingRooms.first
meetingRooms.last
meetingRooms[2]

// 원소 삭제
meetingRooms.remove(at: 3)
meetingRooms.removeFirst()


//
// 딕셔너리
//

var roomCapacity: [String:Int] = ["Bansky":4, "Rivera":8, "Kahlo":10]

roomCapacity.count

// 새 원소 추가
roomCapacity["Picasso"] = 10
// 기존 원소의 값 변경
roomCapacity["Kahlo"] = 8

// 값 삭제
roomCapacity["Bansky"] = nil

// 모든 키와 값들
let keys = [String](roomCapacity.keys)
let values = Array(roomCapacity.values)


//
// 셋
//

let line2 : Set<String> = ["홍대입구", "신촌", "이대", "아현", "충정로", "시청", "을지로 입구", "을지로 3가", "을지로 4가", "동대문 운동장", "신당"]
let line3 = Set(["종로3가", "을지로 3가", "충무로", "동대입구"])

let empty = Set<String>()


let intersectStation = line2.intersection(line3)