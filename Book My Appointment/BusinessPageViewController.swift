//
//  BusinessPageViewController.swift
//  Book My Appointment
//
//  Created by Hitesh Raichandani on 12/2/16.
//  Copyright © 2016 Book My Appointment. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces
import FloatRatingView




class BusinessPageViewController: UIViewController {

    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var timings: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var ratingBar: FloatRatingView!
    @IBOutlet weak var speciality: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var addressFull: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var phoneNumber: UIButton!
    @IBOutlet weak var website: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var placesClient: GMSPlacesClient?
    var placesList: GMSPlaceLikelihoodList?

    
    var segueIdentifier = "BookingConfirmationSegue"
    
    var place: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.name.text = place!.placeName
        self.addressFull.text = place!.address
        self.ratingBar.rating = place!.rating!
        self.speciality.text = ""
        self.distance.text = String(format:"%.2f", (place?.distance!)!) + " mi"
        //self.timings.text = place!.timings ?? "No Time Available"
        
//        if place!.status == "Closed"{
//            self.status.backgroundColor = UIColor.red
//        }
//        self.status.text = place!.status ?? ""
//        
        self.get_data_from_url(url: "https://maps.googleapis.com/maps/api/place/details/json?placeid=\((place!.placeId)!)&key=AIzaSyBm5MbHM3bhvPpzUlmwlLkGHSCJUccjUIY")

        
        self.loadFirstPhotoForPlace(placeID: (place!.placeId!), imageView: self.profileImage)
        
        placesClient = GMSPlacesClient.shared()
        
        placesClient!.lookUpPlaceID(place!.placeId!, callback: { (place: GMSPlace?, error: Error?) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            if let place_ol = place {
                self.website.setTitle(place_ol.website!.absoluteString ?? "", for: .normal)
                self.place?.phoneNumber = place_ol.phoneNumber! ?? ""
                
//                self.status.text = place?.openNowStatus == 0 ? "Closed" : "Open"
                
                print("\n\n\n\n\n\n----\(self.place!.website)--\(self.place!.phoneNumber)----\n\n\n\n\n\n")
                
                self.loadFirstPhotoForPlace(placeID: (place!.placeID), imageView: self.profileImage)
            } else {
                print("No place details for \(self.place!.placeId)")
            }
        })
//
//        WebServiceHelper.getData(url: "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeID)&key=AIzaSyBm5MbHM3bhvPpzUlmwlLkGHSCJUccjUIY", obj: timings)
//        
        
        // Do any additional setup after loading the view.
//        var url = ""
//        WebServiceHelper.getData(url: url, controller: self)
    }

    func loadFirstPhotoForPlace(placeID: String, imageView: UIImageView) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error)")
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto, imageView: imageView)
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
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            let destinationViewController = segue.destination as! BookingConfirmationViewController
            destinationViewController.place = self.place

    }
    
    
    @IBAction func bookNowClicked() {
        performSegue(withIdentifier: segueIdentifier, sender: nil)
    }
    
    @IBAction func callButtonClicked() {
        let phNo = self.place!.phoneNumber ?? ""
        let phNoUrl = "tel://" + phNo.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        print(phNoUrl)
        UIApplication.shared.open(URL(string: phNoUrl)!)
    }
    
    @IBAction func websiteClicked() {
        UIApplication.shared.open(URL(string: self.website.title(for: .normal)!)!)
    }

    func extract_json(jsonData:Data)
    {
        do{
            let json: AnyObject? = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : AnyObject] as AnyObject?
            
            //print("\n\n\n\n\n\n", json ?? "\n\n\n\noops!\n\n\n")
            
            if let result = json?["result"] as? NSDictionary
            {
//                print(result)
//                let place_name = result["name"] as? String
//                
//                let placeid = result["place_id"] as? String
//                
//                let rating = result["rating"] as? Float
//                let address = result["vicinity"] as? String
                let opening_hours = result["opening_hours"] as? NSDictionary
//                let status = (opening_hours?["open_now"] as? String) == "0" ? "Open" : "Closed"
//                let geo = result["geometry"] as! NSDictionary
//                let loc = geo["location"] as! NSDictionary
//                print(opening_hours)
                
                var timings: Any?
                if let opn = opening_hours {
//                    print(type (of: opn["weekday_text"]), "\n", opn["weekday_text"]!)
                    timings = opn["weekday_text"]!
                }
                self.timings.text = ""
                if timings != nil {
                    for i in 0...(timings as! NSMutableArray).count - 1 {
                        self.timings.text = self.timings.text! + (((timings as! NSMutableArray)[i]) as! String) + "\n"
                    }
                }
                
            }
        }catch{
            print("error trying to convert data to JSON")
            return
        }
    }
    
    
    func get_data_from_url(url:String){
        //        let httpMethod = "GET"
        
        print(url)
        
        let request: NSURLRequest = NSURLRequest(url: NSURL(string: url) as! URL)
        //let connection: NSURLConnection = NSURLConnection(request: request as URLRequest, delegate: self)!
        //connection.start()
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            self.extract_json(jsonData: responseData)
        }
        task.resume()
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
