//
//  ServiceProvidersListViewController.swift
//  Book My Appointment
//
//  Created by Hitesh Raichandani on 11/22/16.
//  Copyright © 2016 Book My Appointment. All rights reserved.
//

import UIKit
import GooglePlaces
import FloatRatingView

class ServiceProviderListCell: UITableViewCell {
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var serviceProviderTitle: UILabel!
    @IBOutlet weak var serviceProviderRating: FloatRatingView!
    @IBOutlet var distanceToLocation: UILabel!
    
}

class ServiceProvidersListViewController: UITableViewController, CLLocationManagerDelegate {
    
    var placesClient: GMSPlacesClient?
    var locationManager: CLLocationManager!
//    var imageView: UIImageView!
    let cellIdentifier = "ServiceProviderListCell"
    var placesList: GMSPlaceLikelihoodList?
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locVal: CLLocationCoordinate2D = (manager.location?.coordinate)!
        
        WebServiceHelper.getData(url: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?type=dentist&radius=10000&location=\(locVal.latitude),\(locVal.longitude)&key=AIzaSyBm5MbHM3bhvPpzUlmwlLkGHSCJUccjUIY")
        
        print("location = \(locVal.latitude) , \(locVal.longitude)")
    }
    
    func loadFirstPhotoForPlace(placeID: String, imageView: UIImageView) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error)")
            } else {
                if let firstPhoto = photos?.results.first {
                    //self.loadImageForMetadata(photoMetadata: firstPhoto, imageView: imageView)
                }
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata, imageView: UIImageView) {
        GMSPlacesClient.shared()
            .loadPlacePhoto(photoMetadata, constrainedTo: imageView.bounds.size,
                            scale: imageView.window!.screen.scale) { (photo, error) -> Void in
                                if let error = error {
                                    // TODO: handle the error.
                                    print("Error: \(error)")
                                } else {
                                    imageView.image = photo;
                                    print("\n\nphoto : \(photo?.description)\n\n")
                                    //self.imageView.description = photoMetadata.attributions;
                                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        //prk for fetching list of nearby places
        
        
//        imageView = UIImageView()
        placesClient = GMSPlacesClient.shared()
        
        placesClient?.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            guard error == nil else {
                print("Current Place error: \(error!.localizedDescription)")
                return
            }
            
            if let placeLikelihoods = placeLikelihoods {
                
                self.placesList = placeLikelihoods
                print("\n\n-----\n1. ", self.placesList?.likelihoods.count ?? 0)
                self.tableView.reloadData()
//                print("\n\n-----\n", (self.placesList?.likelihoods[0].place.name)!)
//                for likelihood in placeLikelihoods.likelihoods {
//                    let place = likelihood.place
//                    print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
//                    print("Current Place address \(place.formattedAddress)")
//                    print("Current Place attributions \(place.attributions)")
//                    print("Current PlaceID \(place.placeID)")
//                    //self.loadFirstPhotoForPlace(placeID: place.placeID)
//                }
            }
        })
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        locationManager.requestAlwaysAuthorization()
        
        performSegue(withIdentifier: "SearchViewControllerSegue", sender: nil)
        
        //prk end
        
        //let locationManager = CLLocationManager()
        //locationManager.requestWhenInUseAuthorization()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("\n\n-----\n2.Number of rows", self.placesList?.likelihoods.count ?? 0, "\n\n")
        return self.placesList?.likelihoods.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ServiceProviderListCell

        // Configure the cell...
        var place = self.placesList?.likelihoods[indexPath.row].place
        self.loadFirstPhotoForPlace(placeID: (place?.placeID)!, imageView: cell.profilePicture)
        cell.serviceProviderTitle.text = place?.name
        cell.serviceProviderRating.rating = place?.rating ?? 0
        cell.distanceToLocation.text = "0.0"

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
    }

}
