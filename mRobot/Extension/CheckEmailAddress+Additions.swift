//
//  CheckEmailAddress+Additions.swift
//  YHAPP
//
//  Created by HeHongwe on 15/12/25.
//  Copyright © 2015年 harvey. All rights reserved.
//

import Foundation


extension NSString {
    func isValidEmail() -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }
    
    func isValidPassword() -> Bool {
        let passwdRegex = "^([a-zA-Z0-9]|[*_ !^?#@%$&=+-]){4,16}$"
        let passwdTest = NSPredicate(format: "SELF MATCHES %@", passwdRegex)
        return passwdTest.evaluateWithObject(self)
    }
    
    
}