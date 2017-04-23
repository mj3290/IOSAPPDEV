//
//  ScoreViewController.swift
//  OneToFifty
//
//  Created by Kim Dong-woo on 2017. 4. 20..
//  Copyright © 2017년 Kim Dong-woo. All rights reserved.
//

import UIKit
import CoreData

class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var scoreView: UITableView!
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("index : \(indexPath.row)")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ScoreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)
        
        let score = ScoreList[indexPath.row]
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        if let date:Date = score.date as? Date {
            cell.textLabel?.text = dateFormatter.string(from: date)
        }
 
        cell.detailTextLabel?.text = "\(score.score!)"
        
        return cell
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(NSHomeDirectory())
        scoreView.delegate = self;
     }
    
    override func viewWillAppear(_ animated: Bool) {
        scoreView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func removeAllScore(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext  = appDelegate.persistentContainer.viewContext
        
        do {
            let request : NSFetchRequest<ScoreBoard> = ScoreBoard.fetchRequest()
            let scores : [ScoreBoard] = try! context.fetch(request)
            
            for data in scores{
                context.delete(data)
            }
            try context.save()
        }
        catch let error {
            print("save error : \(error.localizedDescription)")
        }
        
        ScoreList.removeAll()
        scoreView.reloadData()
    }
   
    /*
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
