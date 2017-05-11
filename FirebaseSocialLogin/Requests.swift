//
//  Requests.swift
//  FirebaseSocialLogin
//
//  Created by Syed Askari on 26/04/2017.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults
import KVLoading

class Requests: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var json: JSON!
    var row = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        loadRequest()
        KVLoading.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.row
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        if self.json["data"][indexPath.row]["has_expired"].bool == false {
            cell.textLabel?.textColor = UIColor.blue
        } else {
            cell.textLabel?.textColor = UIColor.black
        }
        
        if String(describing: Defaults.value(forKey: "UserType")!) == "Hospital" {
            
            cell.imageView?.image = UIImage(named: "nurseAccept")
            cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.size.width)!/2
            cell.imageView?.clipsToBounds = true
            
            cell.textLabel?.text = String(describing: self.json["data"][indexPath.row]["nurse"]["user"]["name"])
            cell.detailTextLabel?.text = String(describing: self.json["data"][indexPath.row]["shift_date"])
        } else {
            
            cell.imageView?.image = UIImage(named: "hospitalImage")
            cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.size.width)!/2
            cell.imageView?.clipsToBounds = true
            
            cell.textLabel?.text = String(describing: self.json["data"][indexPath.row]["hospital"]["user"]["name"])
            cell.detailTextLabel?.text = String(describing: self.json["data"][indexPath.row]["shift_date"])
        }
        return cell
    }
    
    
    func loadRequest() {
        let url = "http://thenerdcamp.com/calllight/public/api/v1/hospital/request?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
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
                    KVLoading.hide()
                    self.tableView.reloadData()
                }
                break
            case .failure(let error):
                KVLoading.hide()
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
