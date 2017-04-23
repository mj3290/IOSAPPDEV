class Employee {
    var name: String?
    var phoneNumber: String?
    var boss: Employee?
    
    func goVacation() {
        print("Wow!")
    }
}


let emploee1 = Employee()
emploee1.name = "Me"
emploee1.phoneNumber = "012-345-6789"

emploee1.goVacation()


class ValueClass {
    var value = 0 {
        willSet {
            print("willSet : \(newValue)")
        }
        didSet {
            print("didSet : \(oldValue)")
        }
    }
}

var obj = ValueClass()
obj.value = 10

class Cat {
    static var species: String = "고양이"
    static func sing() {
        print("Mew~")
    }
}

Cat.species
Cat.sing()


class Car {
    func drive() {
        print("")
    }
}

class Sedan: Car {
    override func drive() {
        print("Comportable")
    }
}

class SportsCar: Car {
    override func drive() {
        print("FAST and Furious")
    }
}