//
//  UIScreen+Additions.swift
//  YHAPP
//
//  Created by HeHongwe on 15/12/25.
//  Copyright © 2015年 harvey. All rights reserved.
//
import Foundation
import UIKit
extension UIScreen {
    class func screenWidth() -> CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    
    class func screenHeight() -> CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
    
}