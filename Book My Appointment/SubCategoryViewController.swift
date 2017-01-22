//
//  SubCategoryViewController.swift
//  Book My Appointment
//
//  Created by Hitesh Raichandani on 11/21/16.
//  Copyright © 2016 Book My Appointment. All rights reserved.
//

import UIKit

class SubCategoryViewController: UITableViewController {
    
    var selectedCategory: String?
    let cellIdentifier = "SubCategoryCell"
    let spListSegue = "ServiceProvidersListViewControllerSegue"
    
    var subCategories: NSDictionary = ["Health": ["Dentist", "Doctor", "Gym", "Hospital", "Physiotherapist", "Veterinary Care"], "Beautician": ["Beauty Salon", "Hair Care", "Spa"]]
    
//    var subC: [String] {
//        get {
//            if let subC = subCategories[selectedCategory] {
//                return subC
//            } else {
//                return [String]
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sub-Category"

//        subCategories.setValue(["DENTIST", "DOCTOR", "GYM", "HOSPITAL", "PHYSIOTHERAPIST", "VETERINARY_CARE"], forUndefinedKey: "Health")
//        subCategories.setValue(["BEAUTY_SALON", "HAIR_CARE", "SPA"], forUndefinedKey: "Beautician")
//        performSegue(withIdentifier: spListSegue, sender: nil)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let subCat = subCategories.value(forKey: selectedCategory!)
        return (subCat as! [String]).count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        // Configure the cell...
        let subCat = subCategories.value(forKey: selectedCategory!)
        cell.textLabel?.text = (subCat as! [String])[indexPath.row]
        return cell
    }
    
    
    // MARK: - Table view Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: spListSegue, sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = tableView.indexPathForSelectedRow {
            print("others--")
            let subCat = subCategories.value(forKey: selectedCategory!)
            let category = (subCat as! [String])[indexPath.row].lowercased().replacingOccurrences(of: " ", with: "_")
            
            let destinationViewController = segue.destination as! ServiceProvidersListViewController
            destinationViewController.selectedFinalCategory = category
            AppState.sharedInstance.category = selectedCategory
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
