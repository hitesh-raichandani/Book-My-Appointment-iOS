//
//  TabBarControllerViewController.swift
//  Book My Appointment
//
//  Created by Hitesh Raichandani on 11/15/16.
//  Copyright © 2016 Book My Appointment. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBar.items?[0].image = UIImage(named: "home-icon")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[0].title = "Home"
        
        self.tabBar.items?[1].image = UIImage(named: "appointment-icon")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[1].title = "Appointments"
        
        self.tabBar.items?[2].image = UIImage(named: "more-icon-1")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[2].title = "More"
    }

}
