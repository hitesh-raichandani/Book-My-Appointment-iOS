//
//  AppointmentHistoryViewController.swift
//  Book My Appointment
//
//  Created by Hitesh Raichandani on 11/20/16.
//  Copyright © 2016 Book My Appointment. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AppointmentHistoryCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var speciality: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var status: UILabel!
    
}

class AppointmentHistoryViewController: UITableViewController {
    
    var cellIdentifier = "AppointmentHistoryCell"
    var sectionTitle: [String] = ["Upcomming", "Past"]
    
    var appointmetData = [Appointment()]
//    var bookingData: NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Appointments"

//        let rootRef = FIRDatabase.database().reference().child("appointment")
//        
//        rootRef.child(String(AppState.sharedInstance.email!.hashValue)).observe(.value, with: { snapshot in
//            print(snapshot.ref)
////            if (!(snapshot.value != nil) is NSNull) {
//                print(type(of: snapshot.value!))
//                self.appointmetData =  (snapshot.value as? NSDictionary)!
//                self.tableView.reloadData()
////            }
//        })
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let rootRef = FIRDatabase.database().reference()
        
        rootRef.child("appointment").child(String(AppState.sharedInstance.email!.hashValue)).observe(.value, with: { snapshot in
//            if (!(snapshot.value != nil) is NSNull) {
//                print(type(of: snapshot.value!))
//            self.appointmetData =  (snapshot.value as? NSDictionary)!
            if(snapshot.exists()) {
            let results = (snapshot.value as? NSDictionary)!
            var appointments = [Appointment]()
            
            for (_, value) in results{
                let appointment = Appointment()
                let result = value as! NSDictionary
                appointment.serviceProviderName = result.value(forKey: "serviceProviderName") as! String?
                appointment.serviceProviderID = result.value(forKey: "serviceProviderId") as! String?
                appointment.date = result.value(forKey: "date") as! String?
                appointment.time = result.value(forKey: "time") as! String?
                appointment.lat = result.value(forKey: "lat") as! Double?
                appointment.lng = result.value(forKey: "lng") as! Double?
                appointment.speciality = result.value(forKey: "speciality") as! String?
                appointment.userID = result.value(forKey: "userId") as! Int?
                appointment.appointmentID = result.value(forKey: "appointmentId") as! Int?
                
                let bookRef = rootRef.child("bookings").child(appointment.serviceProviderID!).child(appointment.date!).child(appointment.time!)
                
                bookRef.observe(.value, with: { snapshot in
                    if(snapshot.exists()) {
                        let booking =  (snapshot.value as? NSDictionary)!
                        appointment.status = booking.value(forKey: "status") as? String
                        print(appointment.status ?? "default")
                        self.tableView.reloadData()
                    }
                })

                appointment.timeText = "On " + appointment.date! + " at " + appointment.time!

                appointments.append(appointment)
            }
            self.appointmetData = appointments

            print("--->>>>", appointments.count)
            }
        })
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if( section == 0) {
            return self.appointmetData.count
        }
        else {
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AppointmentHistoryCell
        
        if indexPath.section == 1 {
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.selectionStyle = UITableViewCellSelectionStyle.gray
            cell.isUserInteractionEnabled = false
        }

        // Configure the cell...
        let row = (appointmetData[indexPath.row] as! Appointment)
        cell.title.text = row.serviceProviderName
        cell.status.text = row.status
        cell.time.text = row.timeText
        cell.speciality.text = row.speciality
        
//        let result: NSDictionary = appointmetData[indexPath.row] as! NSDictionary
//        cell.title.text = result.value(forKey: "serviceProviderName") as! String?
//        cell.speciality.text = AppState.sharedInstance.category
//        let time: String = result.value(forKey: "time") as! String
//        cell.time.text = time
//        
//        let spid: String = result.value(forKey: "serviceProviderId") as! String
//        let date: String = result.value(forKey: "date") as! String
//        let rootRef = FIRDatabase.database().reference()
//        
//        let child = "bookings//" + spid + "//" + date + "//" + time
//        rootRef.child(String(child)).observe(.value, with: { snapshot in
//            if(!(snapshot.value != nil) is NSNull){
//                self.bookingData =  (snapshot.value as? NSDictionary)!
//            }
//        })
//        cell.status.text = bookingData.value(forKey: "status") as! String

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
    }

    
    // Add swipe gesture to table view cells
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let more = UITableViewRowAction(style: .normal, title: "More") { action, index in
//            print("more button tapped")
//        }
//        more.backgroundColor = UIColor.lightGray
//        
//        let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
//            print("favorite button tapped")
//        }
//        favorite.backgroundColor = UIColor.orange
//        
//        let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
//            print("share button tapped")
//        }
//        share.backgroundColor = UIColor.blue
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            print("edit button tapped ", index)
        }
        edit.backgroundColor = UIColor.green
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("delete button tapped ")
            
            let rootRef = FIRDatabase.database().reference()
            let row = self.appointmetData[index.row] as! Appointment

            rootRef.child("bookings").child(row.serviceProviderID!).child(row.date!).child(row.time!).removeValue()
            
            rootRef.child("appointment").child(String(row.userID!)).child(String(row.appointmentID!)).removeValue()
            self.appointmetData.remove(at: index.row)
            
            tableView.deleteRows(at: [index], with: .fade)
            
        }
        delete.backgroundColor = UIColor.red
        
//        return [edit, delete]
        return [delete]
    }
    
//    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // the cells you would like the actions to appear needs to be editable
//        return true
//    }
//    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        // you need to implement this method too or you can't swipe to display the actions
//    }
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
