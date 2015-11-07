//
//  ViewController.swift
//  Zippy
//
//  Created by Jason Heard on 11/7/15.
//  Copyright © 2015 Jason Heard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var zippyTitle: UILabel!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var zipCodeLabel: UILabel!
    @IBOutlet weak var zipCodeInfoLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateInfoLabel: UILabel!
    @IBOutlet weak var cityInfoLabel: UILabel!
    @IBOutlet weak var zipcodeIndicator: UIActivityIndicatorView!
    
    let apiKey = "ia6bDSOSCQG8CUMw6E5gSaj1rf057oiqzpCdiq5UgM3TGPpNuv4nGno7CocKNvbm"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func searchForZipCode(sender: AnyObject) {
        
        var state = ""
        var city = ""
        var zipcode = ""
        var finished = false
        
        callZipcodeApi() { jsonData in
            if(jsonData != nil) {
                state = String(jsonData!["state"]!)
                city = String(jsonData!["city"]!)
                zipcode = self.zipcodeTextField.text!
            } else {
                state = ""
                city = ""
                zipcode = "Zipcode not Found!"
            }
            finished = true
        }
        
        //TODO: HACK: this doesn't feel like the best way to handle the asynchronous task from what I've read.
        while(finished == false) {}
        
        stateInfoLabel.text = state
        cityInfoLabel.text = city
        zipCodeInfoLabel.text = zipcode
        zipcodeTextField.text = ""
    }
    
    func callZipcodeApi(completionHandler: (NSDictionary?) -> Void ) -> NSURLSessionTask {

        
        let jsonUrl = "https://www.zipcodeapi.com/rest/\(apiKey)/info.json/\(self.zipcodeTextField.text!)/degrees"
        
        let session = NSURLSession.sharedSession()
        let zipcodeApiUrl = NSURL(string: jsonUrl)
        
        let task : NSURLSessionDataTask = session.dataTaskWithURL(zipcodeApiUrl!, completionHandler: {
            (data, response, error) in
            do {
                let httpResp: NSHTTPURLResponse = response as! NSHTTPURLResponse
                if(httpResp.statusCode == 200) {
                    let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                    print(String(jsonData["state"]!))
                    print(String(jsonData["city"]!))
                    completionHandler(jsonData)
                } else {
                    completionHandler(nil)
                }

            } catch _ {
                // Error
            }
            
        });
        task.resume()
        return task
    }
}

