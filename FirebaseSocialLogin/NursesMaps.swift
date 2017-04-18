//
//  NursesMaps.swift
//  FirebaseSocialLogin
//
//  Created by Syed Askari on 06/04/2017.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults
import KVLoading
import MapKit

class NursesMaps: UIViewController, UIGestureRecognizerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var row = 0
    var json: JSON = []
    var selected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        KVLoading.show()
//        addAnnotations()
        getAllNurse()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addAnnotations() {
        print ("helloWorld !")
        
        
        for index in 0...self.row {
            let annotation = MKPointAnnotation()
            let annotaoinView = MKAnnotationView()
//            annotation.title = self.json["data"][index]["name"].string!
//            print (self.json["data"][index]["latitude"])
//            print ( self.json["data"][index]["latitude"])
//            print (self.json["data"][index]["longitude"].doubleValue)
            var lat = self.json["data"][index]["latitude"].doubleValue
            var lng = self.json["data"][index]["longitude"].doubleValue
//            print (lat)
//            print (lng)
//            print("wow")
//            print(lat)
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            mapView.addAnnotation(annotation)
        }
        KVLoading.hide()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNurseSegue" {
            if let nurseProfileView = segue.destination as? NurseProfile {
                var str = String(describing:self.json["data"][selected]["id"])
                var ID: Int = Int(str)!
                var iddAlternative = self.json["data"][selected]["id"].int
                nurseProfileView.id = ID
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print ("tapped on annotation")
        let a = view.annotation
        print(a?.title)
        performSegue(withIdentifier: "showNurseSegue", sender: self)
        
    }

    func getAllNurse() {
        
        let url = "http://staging.techeasesol.com/calllight/public/api/v1/nurse/all?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
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
                if let value = response.result.value {
                    self.json = JSON(value)
                    print(self.json)
                    self.row = self.json["data"].count
                    print(self.row)
                    //print(self.json[0]["facilityPictures"])
                    self.addAnnotations()
                }
                break
            case .failure(let error):
                print(error)
            }
            
        }
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
