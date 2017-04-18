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
    
    var nurseShiftSelect = 0
    var nurseTypeSelect = 0
    var nurseSexSelect = 0
    var NurseSpecilitySelect = ""
    
    var pickerData = ["ER", "ICU", "Labor &amp; Delivery", "Med/Surgical", "Cath. Lab"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Connect data:
        self.nurseSpeciality.delegate = self
        self.nurseSpeciality.dataSource = self
        
        
        print (self.pickerData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "profileComplete") == "1" {
            self.logOut.isEnabled = true
            self.logOut.isHidden = false
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
        } else {
            self.nurseShiftSelect = 1
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
        print(pickerData[row])
    }
    
    @IBAction func SaveData(_ sender: Any) {
        if self.NurseSpecilitySelect != "" {
            
            KVLoading.show()
            
            // saving data
            var json: JSON = []
            var parameters: Parameters = [:]
            
            parameters = [
                "gender" : self.nurseSexSelect,
                "shift" : self.nurseShiftSelect,
                "type" : self.nurseTypeSelect,
                "speciality" : self.NurseSpecilitySelect
            ]
            
            let url = "http://staging.techeasesol.com/calllight/public/api/v1/profile/nurses?api_token="+UserDefaults.standard.string(forKey: "apiToken")!
            let completeUrl = URL(string:url)!
            
            Alamofire.request(completeUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil ).responseJSON{ response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
                switch response.result {
                case .success:
                    print(response)
                    if let value = response.result.value {
                        json = JSON(value)
                        print(json)
                    }
                    KVLoading.hide()
                    self.performSegue(withIdentifier: "NurseDocsSegue", sender: self)
                    break
                case .failure(let error):
                    print(error)
                    KVLoading.hide()
                    break
                }
                
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
