//
//  Logout.swift
//  FirebaseSocialLogin
//
//  Created by Syed Askari on 10/04/2017.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

class Logout {
    class func logOut() -> Bool {
        if String(describing: Defaults.value(forKey: "apiToken")) != "" && String(describing: Defaults.value(forKey: "UserType")) != "" {
            Defaults.set("", forKey: "UserType")
            Defaults.set("", forKey: "apiToken")
            Defaults.set(false, forKey: "ProfileComplete")
            return true
        } else {
            return false
        }
    }
}
