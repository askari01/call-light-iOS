//
//  TimerPickerView.swift
//  FirebaseSocialLogin
//
//  Created by Syed Askari on 11/04/2017.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit

class TimerPickerView: UIView {
    
    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet weak var endTime: UIDatePicker!
    
    @IBAction func HoursSwitch(_ sender: UISwitch) {
        if sender.isOn {
            endTime.isEnabled = false
        } else {
            endTime.isEnabled = true
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
