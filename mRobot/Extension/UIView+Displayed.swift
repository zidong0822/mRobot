//
//  UIView+ZXHelper.swift
//  YHAPP
//
//  Created by HeHongwe on 15/12/25.
//  Copyright © 2015年 harvey. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
 
    public func isDisplayedInScreen() -> Bool {
        //不在window中
        if self.window == nil {
            return false
        }
        
        //隐藏
        if self.hidden == true {
            return false
        }
        
        //width 或 height 为0 或者为null
        if CGRectIsEmpty(self.bounds) {
            return false
        }
        
        let windowBounds:CGRect = self.window!.bounds
        let rectToWindow = self.convertRect(self.frame, toView: self.window)
        let intersectionRect = CGRectIntersection(rectToWindow, windowBounds);
        // 如果在屏幕外
        if (CGRectIsEmpty(intersectionRect)) {
            return false;
        }
        return true;
    }
}