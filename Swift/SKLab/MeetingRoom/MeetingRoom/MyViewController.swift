//
//  MyViewController.swift
//  MeetingRoom
//
//  Created by Kim Dong-woo on 2017. 4. 13..
//  Copyright © 2017년 Kim Dong-woo. All rights reserved.
//

import UIKit

class MyViewController: UIViewController, UITableViewDataSource {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       
        return MeetingRooms.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingRoom", for: indexPath)
        
        let room = MeetingRooms[indexPath.row]
        
        cell.textLabel?.text = room.title
        cell.detailTextLabel?.text = "\(room.capacity)"
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
