import UIKit

class MyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("index : \(indexPath.row)")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetingRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingRoom", for: indexPath)
        let room = meetingRooms[indexPath.row]
        cell.textLabel?.text = room.title
        cell.detailTextLabel?.text = "\(room.capacity)"
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
