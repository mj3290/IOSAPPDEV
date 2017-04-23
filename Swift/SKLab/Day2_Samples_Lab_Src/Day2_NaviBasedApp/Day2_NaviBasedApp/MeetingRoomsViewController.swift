
import UIKit

class MeetingRoomsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return meetingRooms.count
        }
        else {
            return seminarRooms.count
        }
    }

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingRoomCell", for: indexPath)
        
        let room = meetingRooms[indexPath.row]
        
        cell.textLabel?.text = room.title
        cell.detailTextLabel?.text = "\(room.capacity)"
        
        return cell
    }
    else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeminarRoomCell", for: indexPath)
        
        let room = seminarRooms[indexPath.row]
        
        cell.textLabel?.text = room.title
        cell.detailTextLabel?.text = "\(room.capacity)"
        
        return cell
    }
}
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Meeting Room"
        }
        else {
            return "Seminar Room"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let room = meetingRooms[indexPath.row]
            print("Meeting Room : \(room.title)")
        }
        else {
            let room = seminarRooms[indexPath.row]
        }
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = self.tableView.indexPath(for: cell)!
        
        let detailVC = segue.destination as! DetailViewController
        
        let room = meetingRooms[indexPath.row]
        detailVC.data = room.title
        
    }
}
