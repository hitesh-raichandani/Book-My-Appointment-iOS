//
//  AppState.swift
//  Book My Appointment
//
//  Created by Hitesh Raichandani on 11/15/16.
//  Copyright © 2016 Book My Appointment. All rights reserved.
//

import Foundation
import GooglePlaces

class AppState: NSObject {
    
    static let sharedInstance = AppState()
    
    var signedIn = false
    var location: CLLocation? = nil
    var email: String?
    var category: String?
    
}
