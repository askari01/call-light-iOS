//
//  NurseShift.swift
//  FirebaseSocialLogin
//
//  Created by Syed Askari on 04/04/2017.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyUserDefaults
import SwiftyJSON
import KVLoading

class NurseShift: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var nurseShift: UISegmentedControl!
    @IBOutlet weak var nurseType: UISegmentedControl!
    @IBOutlet weak var nurseSpeciality: UIPickerView!
    @IBOutlet weak var NurseSex: UISegmentedControl!
    @IBOutlet weak var logOut: UIButton!
    @IBOutlet weak var progressButton: UIButton!
    @IBOutlet weak var changePassword: UIButton!
    
    var nurseShiftSelect = 0
    var nurseTypeSelect = 0
    var nurseSexSelect = 0
    var NurseSpecilitySelect = "ER"
    
    var pickerData = ["ER", "ICU", "Labor & Delivery", "Med/Surgical", "Cath. Lab"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        logOut.layer.cornerRadius = 8
        progressButton.layer.cornerRadius = 8
        changePassword.layer.cornerRadius = 8
        
        // Connect data:
        self.nurseSpeciality.delegate = self
        self.nurseSpeciality.dataSource = self
        
        
        if UserDefaults.standard.bool(forKey: "profileComplete") == true {
            self.logOut.isEnabled = true
            self.logOut.isHidden = false
            self.changePassword.isEnabled = true
            self.changePassword.isHidden = false
            self.progressButton.setTitle("Save", for: [])
        } else {
            self.logOut.isEnabled = false
            self.logOut.isHidden = true
            self.changePassword.isEnabled = false
            self.changePassword.isHidden = true
        }
        
//        print (self.pickerData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "profileComplete") == true {
            self.logOut.isEnabled = true
            self.logOut.isHidden = false
            self.progressButton.setTitle("Save", for: [])
        } else {
            self.logOut.isEnabled = false
            self.logOut.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        var a = Logout.logOut()
        if a {
            performSegue(withIdentifier: "logOut", sender: self)
        } else {
            print ("logout issue")
        }
    }
    
    @IBAction func ShiftChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.nurseShiftSelect = 0
        } else if sender.selectedSegmentIndex == 1 {
            self.nurseShiftSelect = 1
        } else {
            self.nurseShiftSelect = 2
        }
    }

    @IBAction func TypeChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.nurseTypeSelect = 0
        } else {
            self.nurseTypeSelect = 1
        }
    }
    
    @IBAction func SexChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.nurseSexSelect = 0
        } else {
            self.nurseSexSelect = 1
        }
    }
    
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.NurseSpecilitySelect = pickerData[row]
//        print(pickerData[row])
    }
    
    @IBAction func SaveData(_ sender: Any) {
        if self.NurseSpecilitySelect != "" {
            
            KVLoading.show()
            
            // saving data
            var json: JSON = []
            var parameters: Parameters = [:]
            
            parameters = [
                "gender" : "nil",
                "shift" : self.nurseShiftSelect,
                "type" : self.nurseTypeSelect,
                "speciality" : self.NurseSpecilitySelect
            ]
            
//            print ("parameters :", parameters)
            
            let url = "http://thenerdcamp.com/calllight/public/api/v1/profile/nurses?api_token="+UserDefaults.standard.string(forKey: "apiToken")!
            let completeUrl = URL(string:url)!
            
            Alamofire.request(completeUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil ).responseJSON{ response in
//                print(response.request as Any)  // original URL request
//                print(response.response as Any) // URL response
//                print(response.result.value as Any)   // result of response serialization
                switch response.result {
                case .success:
//                    print(response)
                    if let value = response.result.value {
                        json = JSON(value)
//                        print(json)
                    }
                    KVLoading.hide()
                    print (UserDefaults.standard.bool(forKey: "profileComplete"))
                    if UserDefaults.standard.bool(forKey: "profileComplete") != true {
                        self.performSegue(withIdentifier: "NurseDocsSegue", sender: self)
                    } else {
                        self.performSegue(withIdentifier: "addLocation", sender: self)
                    }
                    break
                case .failure(let error):
                    print(error)
                    KVLoading.hide()
                    break
                }
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocation" {
            let nextVC = (segue.destination as! signUpLocation)
            nextVC.speciality = self.NurseSpecilitySelect
            nextVC.type = self.nurseTypeSelect
            nextVC.shift = self.nurseShiftSelect
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
