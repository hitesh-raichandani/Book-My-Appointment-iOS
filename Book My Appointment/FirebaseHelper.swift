//
//  FirebaseHelper.swift
//  Book My Appointment
//
//  Created by Hitesh Raichandani on 12/9/16.
//  Copyright © 2016 Book My Appointment. All rights reserved.
//

import Foundation
import FirebaseDatabase


public class FirebaseHelper: NSObject {
    
    static let rootRef = FIRDatabase.database().reference()
    
    static func save(child: String!, value: NSDictionary!) {
        print("FirebaseHelper: ", "Save");
        rootRef.child(child).setValue(value);
    }
    
    static func save(child: String!, uid: String!, value: NSDictionary!) {
        rootRef.child(child).child(uid).setValue(value);
    }
    
    static func delete(child: String!){
        rootRef.child(child).removeValue()
    }

}
