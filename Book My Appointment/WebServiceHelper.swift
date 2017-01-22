//
//  WebServiceHelper.swift
//  Book My Appointment
//
//  Created by Hitesh Raichandani on 11/27/16.
//  Copyright © 2016 Book My Appointment. All rights reserved.
//

import GooglePlaces

class WebServiceHelper: NSObject{
    
    var data: NSMutableData = NSMutableData()
    
    static func getData(url: String, obj: AnyObject){

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
            // parse the result as JSON, since that's what the API provides
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions()) as! [String : AnyObject]
                
                if let results = jsonResult["results"] as? [[String : AnyObject]] {
                    for result in results{
                        print(result)
                        
                        if obj is Array<Place>{
                            let place = Place()
                            place.placeName = result["place_name"] as! String?
//                            obj.append(place)
                        }
                        
                        if let addressComponents = result["address_components"] as? [[String : AnyObject]] {
                            
                            let filteredItems = addressComponents.filter{ if let types = $0["types"] as? [String] {
                                return types.contains("administrative_area_level_2") } else { return false } }
                            if !filteredItems.isEmpty {
                                print(filteredItems[0]["long_name"] as! String)
                            }
                        }
                    }
                }
                
                // now we have the todo
                // let's just print it to prove we can access it
//                print("The json is: \(todo)")
                
                // the todo object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
//                print(todo["results"]["formatted_address"])
                
//                print(type(of: todo))
//                print(todo["results"])
                
//                let a = todo["results"] as! NSArray
//                print(a[0])
                
//                let b: NSDictionary = a[0] as! NSDictionary
//                let dict = a[0] as! [String: AnyObject]
//                let timings = (dict["opening_hours"]! as! [String: AnyObject])["weekday_text"]! as! String controller.text = timings
                
//                print(b["formatted_address"])
//                guard let todoTitle = todo["results"]["formatted_address"] as? String else {
//                    print("Could not get todo title from JSON")
//                    return
//                }
//                print("The title is: \(todoTitle)")
//                return todo
                return
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: URLResponse!) {
        // Received a new request, clear out the data object
        self.data = NSMutableData()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        // Append the received chunk of data to our data object
        self.data.append(data as Data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        // Request complete, self.data should now hold the resulting info
        // Convert the retrieved data in to an object through JSON deserialization
        
        do{
            if let jsonResult = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                
                let results: NSArray = (jsonResult["results"] as? NSArray)!
                print(results)
            }
        }catch{
            print("Somthing wrong")
        }
    }
}
