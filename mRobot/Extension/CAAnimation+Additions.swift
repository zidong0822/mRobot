//
//  CAAnimation+Additions.swift
//  YHAPP
//
//  Created by HeHongwe on 15/12/25.
//  Copyright © 2015年 harvey. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    func presentViewControllerLikePushAnimation(destinationVC: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window?.layer.addAnimation(transition, forKey: nil)
        
        self.presentViewController(destinationVC, animated: false, completion: nil)
        
    }
    
    func dismissViewControllerLikePopAnimation() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window?.layer.addAnimation(transition, forKey: nil)
        
        self.dismissViewControllerAnimated(false , completion: nil)
    }
    
    
}