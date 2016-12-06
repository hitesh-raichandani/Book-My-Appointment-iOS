//
//  BusinessPageViewController.swift
//  Book My Appointment
//
//  Created by Hitesh Raichandani on 12/2/16.
//  Copyright © 2016 Book My Appointment. All rights reserved.
//

import UIKit
import MapKit

class BusinessPageViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var segueIdentifier = "BookingConfirmationSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        scrollView.contentSize.height = stackView.frame.height + 250
    }
    
    @IBAction func bookNowClicked() {
        performSegue(withIdentifier: segueIdentifier, sender: nil)
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
