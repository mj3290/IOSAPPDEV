
import UIKit
import CoreData

class ViewController: UIViewController {

    var todolist : [Todo] = []
    
    func addTodo(title: String, date:Date){
        print("add")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext  = appDelegate.persistentContainer.viewContext
        
        
        let newTodo  = Todo(context: context)
        newTodo.title = title
        newTodo.dueDate = Date() as NSDate
        
        do {
            try context.save()
        }
        catch let error {
            print("save error : \(error.localizedDescription)")
        }
        
        todolist.append(newTodo)
    }
    
    func resolveTodos() {
        print("resolve todo")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext  = appDelegate.persistentContainer.viewContext

        let request : NSFetchRequest<Todo> = Todo.fetchRequest()
        let todos : [Todo] = try! context.fetch(request)
        
        for todo in todos{
            print("todo : \(todo.title!)")
        }
        
        self.todolist = todos
    }
    
    func editTodo(title: String) {
        print("edit")

        let todo = self.todolist.first!
        todo.title = title
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext  = appDelegate.persistentContainer.viewContext
        
        do {
            try context.save()
        }
        catch let error {
            print("save error : \(error.localizedDescription)")
        }
    }
    
    
    func removeTodo() {
        print("remove")

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext  = appDelegate.persistentContainer.viewContext
        
        do {
            let todo = self.todolist.last!

            context.delete(todo)
            try context.save()
        }
        catch let error {
            print("save error : \(error.localizedDescription)")
        }

    }
    
    func removeAll() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext  = appDelegate.persistentContainer.viewContext
        
        do {
            let request : NSFetchRequest<Todo> = Todo.fetchRequest()
            let todos : [Todo] = try! context.fetch(request)
            
            for todo in todos{
                context.delete(todo)
            }
            try context.save()
        }
        catch let error {
            print("save error : \(error.localizedDescription)")
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addTodo(title: "퇴근", date: Date())
        addTodo(title: "회식", date: Date())
        addTodo(title: "아침점검", date: Date())
        addTodo(title: "목욕", date: Date())
        
        editTodo(title:"야근")
        removeTodo()
        resolveTodos()
        
        removeAll()
        
        resolveTodos()
        
        print(NSHomeDirectory())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       
    }


}

