enum TaskType {
    case call, report
    case meet
    
    var typeTitle : String {
        let titleString: String
        switch self {
        case .call:
            titleString = "Call"
        case .report:
            titleString = "Report"
        case .meet:
            titleString = "Meet"
        }
        return titleString
    }
    
    func showTaskTitle() {
        print(self.typeTitle)
    }
}

let type1 = TaskType.call
let type2: TaskType = .report

type1.typeTitle
type2.showTaskTitle()


enum AreaCode: String {
    case seoul = "02"
    case kyoungki = "031"
}

let code = AreaCode(rawValue: "02")!
print("Seoul area code : \(code.rawValue)")

enum Day: Int {
    case am
    case pm
}

let day = Day(rawValue: 1)!
print("value : \(day.rawValue)")


enum FlightStatus {
    case onTime
    case delayed(Int)
}

let flight = FlightStatus.delayed(1)
switch flight {
case .onTime:
    print("OnTime")
case .delayed(let hour):
    print("Delayed \(hour)")
}

