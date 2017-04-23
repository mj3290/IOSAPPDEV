import Foundation
// Exercise WordCount

func count(words: String) -> [String: Int] {
    var result = [String: Int]()
    
//    let components = words.components(separatedBy: " ")
    let chSet = CharacterSet(charactersIn: " ,!&$%^&:")
    let components = words.components(separatedBy: chSet).filter{ $0 != "" }
    for item in components {
        if let count = result[item] {
            result[item] = count + 1
        }
        else {
            result[item] = 1
        }
    }

    return result
}
count(words: "one fish two fish red fish blue fish")
print(count(words: "testing, 1, 2 testing"))
print(count(words: "car : carpet as java : javascript!!&$%^&"))


// Exercise Task
struct Task {
    var title: String
    var time: Int
}

var sleep = Task(title: "Sleep", time:1200)
var eat = Task(title: "Eat", time:2300)

var todaysTask = [Task]()

todaysTask.append(sleep)
todaysTask += [eat]

print(todaysTask[0])
print(todaysTask[1])
