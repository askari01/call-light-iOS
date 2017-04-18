//
//  HospitalProfile.swift
//  FirebaseSocialLogin
//
//  Created by Syed Askari on 12/04/2017.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit

class HospitalProfile: UIViewController {
    
    @IBAction func logOut(_ sender: Any) {
        var a = Logout.logOut()
        if a {
            performSegue(withIdentifier: "logOut", sender: self)
        } else {
            print ("logout issue")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
