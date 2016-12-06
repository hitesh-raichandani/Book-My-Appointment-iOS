//
//  WebServiceHelper.swift
//  Book My Appointment
//
//  Created by Hitesh Raichandani on 11/27/16.
//  Copyright © 2016 Book My Appointment. All rights reserved.
//

class WebServiceHelper: NSObject{
    
    var data: NSMutableData = NSMutableData()
    
    static func getData(url: String){
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
            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                // now we have the todo
                // let's just print it to prove we can access it
//                print("The todo is: \(todo)")
                
                // the todo object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
                guard let todoTitle = todo["title"] as? String else {
                    print("Could not get todo title from JSON")
                    return
                }
//                print("The title is: \(todoTitle)")
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
//                print(results)
            }
        }catch{
            print("Somthing wrong")
        }
    }
}
