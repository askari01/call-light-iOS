//
//  Nurses.swift
//  FirebaseSocialLogin
//
//  Created by Syed Askari on 29/03/2017.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults
import KVLoading

class Nurses: UITableViewController {

    @IBOutlet var nurseTable: UITableView!
    
    var row = 0
    var all = 0
    var time = 0
    var NurseShift = 0
    var NurseType = 0
    var NurseSpeciality = "ALL"
    var speciality = 0
    var json: JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        nurseTable.delegate = self
        nurseTable.dataSource = self
        
        
        if UserDefaults.standard.bool(forKey: "profileVerified") == false {
            let alert = UIAlertController(title: "Profile Status", message: "Your Account Verification Request is pending approval", preferredStyle: UIAlertControllerStyle.alert)
            
            // add the actions (buttons)
            
            alert.addAction(UIAlertAction(title: "Log Out", style: UIAlertActionStyle.default, handler: { action in
                var a = Logout.logOut()
                if a {
//                    self.performSegue(withIdentifier: "logOut", sender: self)
                    let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as? ViewController
                    
                    self.present(loginViewController!, animated: true, completion: nil)
                } else {
                    print ("logout issue")
                }
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // speciality
    @IBAction func valueChange(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        // ["ER", "ICU", "Labor & Delivery", "Med/Surgical", "Cath. Lab"]
        if sender.selectedSegmentIndex == 1 {
            all = 1
//            print(self.json["data"])
//            for result in self.json["data"] {
//                print (result)
//            }
            NurseSpeciality = "ICU"
            tableView.reloadData()
            getFilteredNurse()
        } else if sender.selectedSegmentIndex == 2 {
            all = 2
//            print(self.json)Labor
            NurseSpeciality = "Labor+&+Delivery"
            tableView.reloadData()
            getFilteredNurse()
        } else if sender.selectedSegmentIndex == 3 {
            all = 3
            //            print(self.json)Surgical
            NurseSpeciality = "Med/Surgical"
            tableView.reloadData()
            getFilteredNurse()
        } else if sender.selectedSegmentIndex == 4 {
            all = 4
            //            print(self.json)Cath. Lab
            NurseSpeciality = "ER"
            tableView.reloadData()
            getFilteredNurse()
        } else if sender.selectedSegmentIndex == 5 {
            all = 5
            //            print(self.json)
            NurseSpeciality = "Cath.+Lab"
            tableView.reloadData()
            getFilteredNurse()
        } else {
            all = 0
            NurseSpeciality = "ALL"
            tableView.reloadData()
            getFilteredNurse()
        }
    }
    
    // nurseType
    @IBAction func specalityChange(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 1 {
            speciality = 1
            NurseType = 1
//            print(self.json["data"])
            tableView.reloadData()
            getFilteredNurse()
        } else if sender.selectedSegmentIndex == 2 {
            speciality = 2
            NurseType = 2
//            print(self.json)
            tableView.reloadData()
            getFilteredNurse()
        } else {
            NurseType = 0
            speciality = 0
            tableView.reloadData()
            getFilteredNurse()
        }
    }
    
    // shift
    @IBAction func timeChange(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 1 {
            time = 1
            NurseShift = 1
            getFilteredNurse()
//            print(self.json["data"])
        } else if sender.selectedSegmentIndex == 2 {
            time = 2
            NurseShift = 2
            getFilteredNurse()
            print(self.json)
            tableView.reloadData()
        } else {
            time = 0
            NurseShift = 0
            getFilteredNurse()
            
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        getAllNurse()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllNurse()
    }
    
    func getAllNurse() {
        KVLoading.show()
        print ("Token: ",UserDefaults.standard.string(forKey: "apiToken")!)
        let url = "http://thenerdcamp.com/calllight/public/api/v1/nurse/all?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
        let completeUrl = URL(string:url)!
        
        let headers: HTTPHeaders = [
            "api_token": UserDefaults.standard.string(forKey: "apiToken")!
        ]
        
        Alamofire.request(completeUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers ).responseJSON{ response in
//            print(response.request as Any)  // original URL request
//            print(response.response as Any) // URL response
//            print(response.result.value as Any)   // result of response serialization
            switch response.result {
            case .success:
                if let value = response.result.value {
                    self.json = JSON(value)
//                    print(self.json)
                    self.row = self.json["data"].count
//                    print(self.row)
                    //print(self.json[0]["facilityPictures"])
                    self.nurseTable.reloadData()
                    KVLoading.hide()
                }
                break
            case .failure(let error):
                print(error)
                KVLoading.hide()
            }
            
        }
    }

    func getFilteredNurse() {
        if NurseType == 0 && NurseShift == 0 && NurseSpeciality == "ALL" {
            getAllNurse()
            return
        }
        KVLoading.show()
        print ("Token: ",UserDefaults.standard.string(forKey: "apiToken")!)
        let url = "http://thenerdcamp.com/calllight/public/api/v1/nurse/all?api_token=\(UserDefaults.standard.string(forKey: "apiToken")!)&speciality=\(NurseSpeciality)&type=\(NurseType)&shift=\(NurseShift)"
        print(url)
        let completeUrl = URL(string:url)!
        
        let headers: HTTPHeaders = [
            "api_token": UserDefaults.standard.string(forKey: "apiToken")!
        ]
        
        Alamofire.request(completeUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers ).responseJSON{ response in
            //            print(response.request as Any)  // original URL request
            //            print(response.response as Any) // URL response
            //            print(response.result.value as Any)   // result of response serialization
            switch response.result {
            case .success:
                if let value = response.result.value {
                    self.json = JSON(value)
                    //                    print(self.json)
                    self.row = self.json["data"].count
                    //                    print(self.row)
                    //print(self.json[0]["facilityPictures"])
                    self.nurseTable.reloadData()
                    KVLoading.hide()
                }
                break
            case .failure(let error):
                print(error)
                KVLoading.hide()
            }
            
        }
    }
    
    // view profile
    func profileAction(sender:UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath)
        if cell != nil {
            performSegue(withIdentifier: "NurseProfileSegue", sender: self)
        }
    }
    
    // main request Button
    @IBAction func requestNurseMain(_ sender: UIButton) {
        print("request")
        //        performSegue(withIdentifier: "NurseProfileSegue1", sender: self)
        if self.json["data"] == nil {
            return
        }
        KVLoading.show()
        var result: Int!
        var id = String(describing: self.json["data"][0]["id"])
        var ID = Int(id)!
        
        //new
        var json: JSON = []
        
        let url = "http://thenerdcamp.com/calllight/public/api/v1/profile/nurses/\(ID)?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
        let completeUrl = URL(string:url)!
        //        print(url)
        let headers: HTTPHeaders = [
            "api_token": UserDefaults.standard.string(forKey: "apiToken")!
        ]
        
        Alamofire.request(completeUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers ).responseJSON{ response in
            //            print(response.request as Any)  // original URL request
            //            print(response.response as Any) // URL response
            //            print(response.result.value as Any)   // result of response serialization
            switch response.result {
            case .success:
                if let value = response.result.value {
                    json = JSON(value)
                    print(json)
                    print ("request called")
                    var index = sender.tag
                    print (index)
                    
                    var json12: JSON = []
                    var result1: String!
                    
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    result1 = formatter.string(from: date)
                    
                    var startTime: String!
                    var endTime: String!
                    
                    if json["data"]["shift"].string! == "0" {
                        startTime = "7:00:00"
                        endTime = "19:00:00"
                    } else {
                        startTime = "19:00:00"
                        endTime = "7:00:00"
                    }
                    
                    let parameters1: Parameters = [
                        "hospital_id": ID,
                        "nurse_id" : json["data"]["id"].int! ,
                        "shift_date": result1,
                        "shift_start_time" : startTime ,
                        "shift_end_time": endTime
                    ]
                    
                    print (parameters1)
                    
                    let headers1: HTTPHeaders = [
                        "api_token": UserDefaults.standard.string(forKey: "apiToken")!
                    ]
                    
                    //            print (headers)
                    
                    let url1 = "http://thenerdcamp.com/calllight/public/api/v1/hospital/request?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
                    let completeUrl1 = URL(string:url1)!
                    
                    print (completeUrl1)
                    
                    Alamofire.request(completeUrl1, method: .post, parameters: parameters1, encoding: JSONEncoding.default, headers: headers1 ).responseString{ response in
                        //                        print(response.request as Any)  // original URL request
                        //                        print(response.response as Any) // URL response
                        //                        print(response.result.value as Any)
                        switch response.result {
                        case .success:
                            //                            print(response)
                            if let value = response.result.value {
                                var json123 = JSON(value)
                                print(json123)
                                print(json123[0])
                                KVLoading.hide()
                                // create the alert
                                let alert = UIAlertController(title: "Request Nurse", message: "Request to Nurse Sent", preferredStyle: UIAlertControllerStyle.alert)
                                
                                // add the actions (buttons)
                                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: {action in
                                    sender.isEnabled = false
                                }))
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                            
                            break
                        case .failure(let error):
                            print(error)
                            KVLoading.hide()
                        }
                    }
                }
                break
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    
    // request
    @IBAction func requestNurse(_ sender: UIBarButtonItem) {
        print("request")
//        performSegue(withIdentifier: "NurseProfileSegue1", sender: self)
        if self.json["data"] == nil {
            return
        }
        KVLoading.show()
        var result: Int!
        var id = String(describing: self.json["data"][0]["id"])
        var ID = Int(id)!
        
        //new
        var json: JSON = []
        
        let url = "http://thenerdcamp.com/calllight/public/api/v1/profile/nurses/\(ID)?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
        let completeUrl = URL(string:url)!
        //        print(url)
        let headers: HTTPHeaders = [
            "api_token": UserDefaults.standard.string(forKey: "apiToken")!
        ]
        
        Alamofire.request(completeUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers ).responseJSON{ response in
//            print(response.request as Any)  // original URL request
//            print(response.response as Any) // URL response
//            print(response.result.value as Any)   // result of response serialization
            switch response.result {
            case .success:
                if let value = response.result.value {
                    json = JSON(value)
                    print(json)
                    print ("request called")
                    var index = sender.tag
                    print (index)
                    
                    var json12: JSON = []
                    var result1: String!
                    
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    result1 = formatter.string(from: date)
                    
                    var startTime: String!
                    var endTime: String!
                    
                    if json["data"]["shift"].string! == "0" {
                        startTime = "7:00:00"
                        endTime = "19:00:00"
                    } else {
                        startTime = "19:00:00"
                        endTime = "7:00:00"
                    }
                    
                    let parameters1: Parameters = [
                        "hospital_id": ID,
                        "nurse_id" : json["data"]["id"].int! ,
                        "shift_date": result1,
                        "shift_start_time" : startTime ,
                        "shift_end_time": endTime
                    ]
                    
                    print (parameters1)
                    
                    let headers1: HTTPHeaders = [
                        "api_token": UserDefaults.standard.string(forKey: "apiToken")!
                    ]
                    
                    //            print (headers)
                    
                    let url1 = "http://thenerdcamp.com/calllight/public/api/v1/hospital/request?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
                    let completeUrl1 = URL(string:url1)!
                    
                    print (completeUrl1)
                    
                    Alamofire.request(completeUrl1, method: .post, parameters: parameters1, encoding: JSONEncoding.default, headers: headers1 ).responseString{ response in
//                        print(response.request as Any)  // original URL request
//                        print(response.response as Any) // URL response
//                        print(response.result.value as Any)
                        switch response.result {
                        case .success:
//                            print(response)
                            if let value = response.result.value {
                                var json123 = JSON(value)
                                print(json123)
                                print(json123[0])
                                KVLoading.hide()
                                // create the alert
                                let alert = UIAlertController(title: "Request Nurse", message: "Request to Nurse Sent", preferredStyle: UIAlertControllerStyle.alert)
                                
                                // add the actions (buttons)
                                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: {action in
                                    sender.isEnabled = false
                                }))
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                            
                            break
                        case .failure(let error):
                            print(error)
                            KVLoading.hide()
                        }
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // select row
        let cell = tableView.cellForRow(at: indexPath)
        if cell != nil {
            performSegue(withIdentifier: "NurseProfileSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NurseProfileSegue" {
            if let nurseProfileView = segue.destination as? NurseProfile {
                let path = self.tableView.indexPathForSelectedRow
//                print (Int((path?.row)!))
                var str = String(describing:self.json["data"][(path?.row)!]["id"])
                var ID: Int = Int(str)!
                var iddAlternative = self.json["data"][(path?.row)!]["id"].int
                nurseProfileView.id = ID 
            }else {
                print("else")
            }
        }
        if segue.identifier == "NurseProfileSegue1" {
            if let nurseProfileView = segue.destination as? NurseProfile {
                //                    let path = self.tableView.indexPathForSelectedRow
                //                print (Int((path?.row)!))
                var str = String(describing:self.json["data"][0]["id"])
                var ID: Int = Int(str)!
                var iddAlternative = self.json["data"][0]["id"].int
                nurseProfileView.id = ID
                print (str)
                print (ID)
                print (iddAlternative)
                
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.row == 0{
            var emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = "No Nurse Found"
            emptyLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            return 0
        } else {
            return self.row
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NurseCell", for: indexPath)
//        print(self.json["data"][indexPath.row]["id"])
        // Main selector
            cell.textLabel?.text = String(describing: self.json["data"][indexPath.row]["name"])
        // Configure the cell...
        print (cell.bounds.width)
        
        let label = UILabel(frame: CGRect(x: (cell.bounds.width - 150), y: 8, width: 50, height: 30))
//        label.center = CGPoint(x: 160, y: 285)
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 4
        label.textAlignment = .center
        label.text = "View"
        
        let button = UIButton(type: UIButtonType.system)
        button.frame = CGRect(x: (cell.bounds.width - 90), y: 8, width: 70, height: 30)//CGRectMake(100, 100, 120, 50)
//        button.backgroundColor = UIColor.lightGray
//        button.setTitleColor(UIColor.green, for: .normal)
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 4
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.tag = indexPath.row
        button.setTitle("Request", for: UIControlState.normal)
        button.addTarget(self, action:  #selector(buttonAction), for: UIControlEvents.touchUpInside)
//        button.addTarget(self, action: #selector(profileAction), for: UIControlEvents.touchUpInside)
        
        cell.addSubview(label)
        cell.addSubview(button)
        
        return cell
    }
 
    
    // Request BUtton
    func buttonAction(sender:UIButton) {
        KVLoading.show()
        var result: Int!
        var id = String(describing: self.json["data"][sender.tag]["id"])
        var ID = Int(id)!
        
        //new
        var json: JSON = []
        
        let url = "http://thenerdcamp.com/calllight/public/api/v1/profile/nurses/\(ID)?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
        let completeUrl = URL(string:url)!
        //        print(url)
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
                    json = JSON(value)
                    print(json)
                    print ("request called")
                    var index = sender.tag
                    print (index)
                    
                    var json12: JSON = []
                    var result1: String!
                    
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    result1 = formatter.string(from: date)
                    
                    var startTime: String!
                    var endTime: String!
                    
                    if json["data"]["shift"].string! == "0" {
                        startTime = "7:00:00"
                        endTime = "19:00:00"
                    } else {
                        startTime = "19:00:00"
                        endTime = "7:00:00"
                    }
                    
                    let parameters1: Parameters = [
                        "hospital_id": ID,
                        "nurse_id" : json["data"]["id"].int! ,
                        "shift_date": result1,
                        "shift_start_time" : startTime ,
                        "shift_end_time": endTime
                    ]
                    
                    print (parameters1)
                    
                    let headers1: HTTPHeaders = [
                        "api_token": UserDefaults.standard.string(forKey: "apiToken")!
                    ]
                    
                    //            print (headers)
                    
                    let url1 = "http://thenerdcamp.com/calllight/public/api/v1/hospital/request?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
                    let completeUrl1 = URL(string:url1)!
                    
                    print (completeUrl1)
                    
                    Alamofire.request(completeUrl1, method: .post, parameters: parameters1, encoding: JSONEncoding.default, headers: headers1 ).responseString{ response in
                        print(response.request as Any)  // original URL request
                        print(response.response as Any) // URL response
                        print(response.result.value as Any)
                        switch response.result {
                        case .success:
                            print(response)
                            if let value = response.result.value {
                                json12 = JSON(value)
                                print(json12)
                                print(json12[0])
                                KVLoading.hide()
                                // create the alert
                                let alert = UIAlertController(title: "Request Nurse", message: "Request to Nurse Sent", preferredStyle: UIAlertControllerStyle.alert)
                                
                                // add the actions (buttons)
                                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: {action in
                                    sender.isEnabled = false
                                }))
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                            
                            break
                        case .failure(let error):
                            print(error)
                            KVLoading.hide()
                        }
                    }
                }
                break
            case .failure(let error):
                print(error)
            }
            
        }
        // end nen
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
