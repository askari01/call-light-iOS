//
//  Logout.swift
//  FirebaseSocialLogin
//
//  Created by Syed Askari on 10/04/2017.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import UserNotifications

class Logout {
    class func logOut() -> Bool {
        if String(describing: Defaults.value(forKey: "apiToken")) != "" && String(describing: Defaults.value(forKey: "UserType")) != "" {
            Defaults.set("", forKey: "UserType")
            Defaults.set("", forKey: "apiToken")
            Defaults.set("", forKey: "ProfileComplete")
            Defaults.set("", forKey: "profileVerified")
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            return true
        } else {
            return false
        }
    }
}
