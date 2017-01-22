//
//  CategoriesViewController.swift
//  Book My Appointment
//
//  Created by Hitesh Raichandani on 11/20/16.
//  Copyright © 2016 Book My Appointment. All rights reserved.
//

import UIKit
import GooglePlaces

class CategoryTableViewCell: UITableViewCell {
    @IBOutlet var categoryImage: UIImageView!
    @IBOutlet var categoryTitle: UILabel!
}

class CategoriesViewController: UITableViewController, CLLocationManagerDelegate {
    
    //DataSource
    var categories: [String] = []
    var images: [String] = []
    let cellIdentifier = "CategoryCell"
    
    let segueSubCategory = "SubCategoryViewControllerSegue"
    let segueSPList = "DirectServiceProvidersListSegue"
    
    //Search bar
    var fetcher: GMSAutocompleteFetcher?
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = ["Health", "Beautician", "Restaurants", "Event Planner", "Legal Services"]
        images = ["health", "beautician", "restaurants", "event", "law"]
        
//        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        
        // Set the title of view
        title = "Category"
        
//        self.tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: cellIdentifier)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        // Navigation bar button
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(image: UIImage(named: "location"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.plain, target: self, action: #selector(CategoriesViewController.navButtonClicked))
        
        //        textField = UITextField(frame: CGRect(x: 5.0, y: 0, width: self.view.bounds.size.width - 5.0, height: 44.0))
        //        textField?.autoresizingMask = .flexibleWidth
        //        textField?.addTarget(self, action: Selector(("textFieldDidChange:")), for: .editingChanged)
        
        let filter = GMSAutocompleteFilter()
        filter.type = .address  //suitable filter type
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.autocompleteFilter = filter
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        locationManager.requestAlwaysAuthorization()
        
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)-> Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])! as CLPlacemark
//                print(pm.name)
                self.searchController?.searchBar.text = pm.name
                AppState.sharedInstance.location = pm.location
            } else {
                print("Problem with the data received from geocoder")
            }
        })
        
//        let loc = WebServiceHelper.getData(url: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(locVal.latitude),\(locVal.longitude)&type=address&key=AIzaSyBm5MbHM3bhvPpzUlmwlLkGHSCJUccjUIY")
//        
//        let json = try? JSONSerialization.jsonObject(with: loc, options: [])

        
//        guard let locAddress = loc["formatted_address"] as? String else {
//                                print("Could not get todo title from JSON")
//                                return
//                            }
    }
    
    func navButtonClicked() {
        print("Button Clicked")
//        let locVal: CLLocationCoordinate2D = (locationManager.location?.coordinate)!
        
        CLGeocoder().reverseGeocodeLocation(locationManager.location!, completionHandler: {(placemarks, error)-> Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])! as CLPlacemark
//                print(pm.name)
                self.searchController?.searchBar.text = pm.name
                AppState.sharedInstance.location = pm.location
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }



    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CategoryTableViewCell
        // Configure the cell...
        let category = categories[indexPath.row]
        cell.categoryImage.image = UIImage(named: images[indexPath.row])
        cell.categoryTitle.text = "  " + category

        return cell
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
    
    
    // MARK: - Table view Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        print(category)
        if(indexPath.row > 1){
            performSegue(withIdentifier: segueSPList, sender: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            performSegue(withIdentifier: segueSubCategory, sender: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segueSubCategory {
            if let indexPath = tableView.indexPathForSelectedRow {
                let category = categories[indexPath.row]
                let destinationViewController = segue.destination as! SubCategoryViewController
                
                destinationViewController.selectedCategory = category
            }
        }
        else if segue.identifier == segueSPList {
            if let indexPath = tableView.indexPathForSelectedRow {
                var category = categories[indexPath.row]
                if(category == "Event Planner"){
                    category = "church"
                    print("church--")
                } else if(category == "Legal Services"){
                    category = "lawyer"
                    print("lawyer--")
                }
                let destinationViewController = segue.destination as! ServiceProvidersListViewController
                destinationViewController.selectedFinalCategory = category
            }
        }
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

// Search bar
// Handle the user's selection.
extension CategoriesViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        searchController?.searchBar.text = place.name
        AppState.sharedInstance.location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        print("Place name: \(place.name)")
        print("Place ID : \(place.types)")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
