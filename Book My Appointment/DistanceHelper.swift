//
//  DistanceHelper.swift
//  Book My Appointment
//
//  Created by Hitesh Raichandani on 12/7/16.
//  Copyright © 2016 Book My Appointment. All rights reserved.
//

import Foundation

class DistanceCalculator: Double {
    
    static func distance(double lat1, double lon1, double lat2, double lon2, String unit) {
    let theta = lon1 - lon2;
    var dist = Math.sin(deg2rad(lat1)) * Math.sin(deg2rad(lat2)) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * cos(deg2rad(theta));
    dist = acos(dist);
    dist = rad2deg(dist);
    dist = dist * 60 * 1.1515;
    if (unit == "K") {
        dist = dist * 1.609344;
    } else if (unit == "N") {
        dist = dist * 0.8684;
    }
    
    DecimalFormat formatter = new DecimalFormat("##.#");
        return (Double.parseDouble(formatter.format(dist)));
    }
    
    static func deg2rad(deg: Double) -> Double {
        return (deg * Math.PI / 180.0);
    }
    
    static func rad2deg(rad: Double) -> Double {
        return (rad * 180 / Math.PI);
    }
}
