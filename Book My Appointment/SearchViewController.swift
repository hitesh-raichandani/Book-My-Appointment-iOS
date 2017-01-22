//
//  SearchViewController.swift
//  Book My Appointment
//
//  Created by Hitesh Raichandani on 11/26/16.
//  Copyright © 2016 Book My Appointment. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchViewController: UIViewController, UISearchDisplayDelegate {

    @IBOutlet weak var textField: UITextField?
    var fetcher: GMSAutocompleteFetcher?
//    vsr result: String?
    var segueIdentifier = "BusinessViewControllerSegue"
    
    // use table data source
    var searchBar: UISearchBar?
    var tableDataSource: GMSAutocompleteTableDataSource?
    var mySearchDisplayController: UISearchDisplayController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.backgroundColor = UIColor.whiteColor()
//        self.edgesForExtendedLayout = .None
        
        // Set bounds to inner-west Sydney Australia.
        
        performSegue(withIdentifier: segueIdentifier, sender: nil)

        
//        let neBoundsCorner = CLLocationCoordinate2D(latitude: -37.843366,
//                                                    longitude: 151.134002)
//        let swBoundsCorner = CLLocationCoordinate2D(latitude: -33.875725,
//                                                    longitude: 151.200349)
//        let bounds = GMSCoordinateBounds(coordinate: neBoundsCorner,
//                                         coordinate: swBoundsCorner)
//        
//        // Set up the autocomplete filter.
//        let filter = GMSAutocompleteFilter()
//        filter.type = .address
//        
//        // Create the fetcher.
//        fetcher = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
////        fetcher?.delegate = self
//        
////        textField = UITextField(frame: CGRect(x: 5.0, y: 0, width: self.view.bounds.size.width - 5.0, height: 44.0))
////        textField?.autoresizingMask = .flexibleWidth
////        textField?.addTarget(self, action: Selector(("textFieldDidChange:")), for: .editingChanged)
//        textField?.addTarget(self, action: #selector(SearchViewController.textFieldDidChange), for: .editingChanged)
//        
////        var resultText = UITextView(frame: CGRect(x: 0, y: 45.0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 45.0))
////        resultText?.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
////        resultText?.text = "No Results"
////        resultText?.editable = false
////        
////        self.view.addSubview(textField!)
////        self.view.addSubview(resultText!)
//        
//        
//        
//        
//        
//        
//        
//        
//        // Table data source
//        searchBar = UISearchBar(frame: CGRect(x: 0, y: 480.0, width: self.view.bounds.size.width, height: 44.0))
//        
//        tableDataSource = GMSAutocompleteTableDataSource()
//        tableDataSource?.delegate = self
//        
//        mySearchDisplayController = UISearchDisplayController(searchBar: searchBar!, contentsController: self)
//        mySearchDisplayController?.searchResultsDataSource = tableDataSource
//        mySearchDisplayController?.searchResultsDelegate = tableDataSource
//        mySearchDisplayController?.delegate = self
//
//        self.view.addSubview(searchBar!)
    }
    
    func textFieldDidChange(textField: UITextField) {
//        let url: String = "https://maps.googleapis.com/maps/api/place/autocomplete/json?type=dentist&key=AIzaSyBm5MbHM3bhvPpzUlmwlLkGHSCJUccjUIY&input=\(textField.text!)"
        if textField.text != nil {
//            WebServiceHelper.getData(url: url, controller: self)
        }
        //fetcher?.sourceTextHasChanged(textField.text!)
        
    }
    
    
    // Present the Autocomplete view controller when the button is pressed.
//    @IBAction func autocompleteClicked(sender: AnyObject) {
//        let autocompleteController = GMSAutocompleteViewController()
//        autocompleteController.delegate = self
//        self.present(autocompleteController, animated: true, completion: nil)
//    }
    
    
    
    
    
    
    
    // Table data source
    func didUpdateAutocompletePredictionsForTableDataSource(tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator off.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        // Reload table data.
        mySearchDisplayController?.searchResultsTableView.reloadData()
    }
    
    func didRequestAutocompletePredictionsForTableDataSource(tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator on.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        // Reload table data.
        mySearchDisplayController?.searchResultsTableView.reloadData()
    }
    
}

/*
extension SearchViewController: GMSAutocompleteFetcherDelegate {
    /**
     * Called when autocomplete predictions are available.
     * @param predictions an array of GMSAutocompletePrediction objects.
     */
    public func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        let resultsStr = NSMutableString()
        for prediction in predictions {
            print(prediction.attributedPrimaryText.string, " - ", prediction.types)
            
            resultsStr.appendFormat("%@\n", prediction.attributedPrimaryText)
        }
        
        //        resultText?.text = resultsStr as String
        //print("\n\nPlaces\n-----\n", resultsStr as String)
    }

    
    func didFailAutocompleteWithError(_ error: Error) {
//        resultText?.text = error.localizedDescription
        print("\n\nPlaces Error\n-----\n", error.localizedDescription)
    }
}
*/



// Table data source
extension SearchViewController: GMSAutocompleteTableDataSourceDelegate {
    func tableDataSource(_ didAutocompleteWithtableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
        mySearchDisplayController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        tableDataSource?.sourceTextHasChanged(searchString)
//        print(searchString)
        return false
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
        // TODO: Handle the error.
        print("Error: \(error)")
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        
        print(prediction.attributedPrimaryText.string, " - ", prediction.types)
        
        return true
    }
}


// Extension for GMSAutocompleteFetcher
/*
extension SearchViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place ID: ", place.placeID)
        //print("Place address: ", place.formattedAddress)
        //print("Place attributions: ", place.attributions)
        
        // A hotel in Saigon with an attribution.
        let placeID = "ChIJocsg8zqkbUgRDkiljcd10RQ" //place.placeID
        
        GMSPlacesClient.shared().lookUpPlaceID(placeID, callback: { (place: GMSPlace?, error: Error?) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                print("Place name \(place.name)")
                print("Place address \(place.formattedAddress)")
                print("Place placeID \(place.placeID)")
                print("Place attributions \(place.attributions)")
            } else {
                print("No place details for \(placeID)")
            }
        })
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
*/
