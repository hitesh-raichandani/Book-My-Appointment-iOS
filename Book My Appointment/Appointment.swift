//
//  Appointment.swift
//  Book My Appointment
//
//  Created by Hitesh Raichandani on 12/9/16.
//  Copyright © 2016 Book My Appointment. All rights reserved.
//

import Foundation

class Appointment: NSObject {
    
    var appointmentID: Int?
    var userID: Int?
    var serviceProviderID: String?
    var serviceProviderName: String?
    var lat: Double?
    var lng: Double?
    var date: String?
    var time: String?
    var timeText: String?
    var status: String?
    var speciality: String?
    
}
