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

class Nurses: UITableViewController {

    @IBOutlet var nurseTable: UITableView!
    var row = 0
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
                    self.performSegue(withIdentifier: "logOut", sender: self)
                } else {
                    print ("logout issue")
                }
            }))
            
            // show the alert
//            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func valueChange(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 1 {
            print(self.json["data"])
        } else if sender.selectedSegmentIndex == 2 {
            print(self.json)
        } else {
        
        }
    }
    
    @IBAction func specalityChange(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 1 {
            print(self.json["data"])
        } else if sender.selectedSegmentIndex == 2 {
            print(self.json)
        } else {
            
        }
    }
    
    @IBAction func timeChange(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 1 {
            print(self.json["data"])
        } else if sender.selectedSegmentIndex == 2 {
            print(self.json)
        } else {
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        getAllNurse()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllNurse()
    }
    
    func getAllNurse() {
//        print ("Token: ",UserDefaults.standard.string(forKey: "apiToken")!)
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
        return self.row
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NurseCell", for: indexPath)
//        print(self.json["data"][indexPath.row]["id"])
        cell.textLabel?.text = String(describing: self.json["data"][indexPath.row]["name"])
        // Configure the cell...

        return cell
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
