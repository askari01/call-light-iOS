//
//  NurseAvailability.swift
//  FirebaseSocialLogin
//
//  Created by Syed Askari on 29/03/2017.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KVLoading
import SwiftyUserDefaults

class NurseAvailability: UIViewController, UIGestureRecognizerDelegate, UITabBarDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    let available = DefaultsKey<Int>("availability")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //testing UITabBar
//        print ("items in tabBar are: ",tabBar.items?.count)
//        var tabIndex = tabBar.items?.index(of: tabBar.selectedItem!)
//        print (tabIndex)
        //end test
        
        // Do any additional setup after loading the view.
        if Defaults[self.available] == nil {
            KVLoading.show()
            availability()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(availability))
        tap.numberOfTapsRequired = 1
        label.addGestureRecognizer(tap)
        image.addGestureRecognizer(tap)
        
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Hellooooo")
        print(tabBar.items?.index(of: item))
        print (item.badgeValue)
        var tabIndex = tabBar.items?.index(of: tabBar.selectedItem!)
        print (tabIndex)
    }
    

    func availabilityCheck() {
        var json: JSON = []
        let url = "http://staging.techeasesol.com/calllight/public/api/v1/profile/nurses?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
        let completeUrl = URL(string:url)!
        
        let headers: HTTPHeaders = [
            "api_token": UserDefaults.standard.string(forKey: "apiToken")!
        ]
        
        Alamofire.request(completeUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers ).responseJSON{ response in
            print(response.request as Any)  // original URL request
            print(response.response as Any) // URL response
            print(response.result.value as Any)   // result of response serialization
            switch response.result {
            case .success:
                print(response)
                if let value = response.result.value {
                    json = JSON(value)
                    print(json)
                    print(json["data"]["available"])
                    if (json["data"]["available"] == 1) {
                        Defaults[self.available] = 1
                        self.availabilitySet()
                        
                    } else {
                        Defaults[self.available] = 0
                        self.availabilitySet()
                    }
                }
                
                break
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    func availabilitySet() {
        if (Defaults[available] == 1) {
            label.text = "Available"
            image.image = UIImage(named: "nurseAccept.png")
        } else {
            label.text = "Not Available"
            image.image = UIImage(named: "nurseDecline.png")
        }
        KVLoading.hide()
    }
    
    func availability() {
        print("hello")
        
        KVLoading.show()
        
        var json: JSON = []
        
        var setAvail = 0
        print (Defaults[self.available])
        if Defaults[self.available] == 0 {
            setAvail = 1
        } else {
            setAvail = 0
        }
        
        let parameters: Parameters = [
            "available": setAvail
        ]
        
        let headers: HTTPHeaders = [
            "api_token": "aySlC26ZTHtlnS0lhUpdghxkd9gKJBLXLYFUO2Jidmiisoka9iFIicwRIZFx"
        ]
        
        let url = "http://staging.techeasesol.com/calllight/public/api/v1/nurse/available?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
        let completeUrl = URL(string:url)!
        
        Alamofire.request(completeUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers ).responseJSON{ response in
            print(response.request as Any)  // original URL request
            print(response.response as Any) // URL response
            print(response.result.value as Any)   // result of response serialization
            switch response.result {
            case .success:
                print(response)
                if let value = response.result.value {
                    json = JSON(value)
                    print(json)
                    print(json["data"]["available"])
                    if (json["data"]["available"] == 1) {
                        Defaults[self.available] = 1
                        print (Defaults[self.available])
                        self.availabilitySet()
                    } else {
                        Defaults[self.available] = 0
                        print (Defaults[self.available])
                        self.availabilitySet()
                    }
                }
                
                break
            case .failure(let error):
                print(error)
            }
            
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
