func greeting() {
    print("Hello Swift")
}

greeting()

func favoriteDrink() -> String {
    return "Coffee"
}
let drink = favoriteDrink()


func ratingRecord(history: [Double]) -> (average:Double, min:Double, max:Double) {
    var sum = 0.0, min = history[0], max = history[0]
    
    for value in history {
        if min > value { min = value }
        if max < value { max = value }
        sum += value
    }
    let average = sum / Double(history.count)
    return (average, min, max)
}

let record = ratingRecord(history: [4.5, 3.0, 5.0, 2.5])
