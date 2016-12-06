//
//  BookingConfirmationViewController.swift
//  Book My Appointment
//
//  Created by Hitesh Raichandani on 12/5/16.
//  Copyright © 2016 Book My Appointment. All rights reserved.
//

import UIKit

class BookingConfirmationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIPickerView!
    
    // Time for bookings
    var timeDataSource = ["10:00 - 10:30", "10:30 - 11:00", "11:00 - 11:30", "11:30 -12:00", "12:30 - 13:00"]
    var selectedTime: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.timePicker.dataSource = self;
        self.timePicker.delegate = self;
    }

    
    // Picker Delegate Functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeDataSource.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timeDataSource[row]
    }
    
    
    // Get selected Date
    func getSelectedDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let strDate = dateFormatter.string(from: datePicker.date)
        print("\nSelected Date: ", strDate)
        return strDate
    }
    
    // Get selected time slot
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedTime = timeDataSource[row]
        print("\nSelected Time: ", selectedTime)
    }
    
    

    
    // Confirm booking
    @IBAction func confirmBookingClicked() {
        getSelectedDate()
        
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
