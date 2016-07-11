//
//  UIImage+Circle.swift
//  YHAPP
//
//  Created by HeHongwe on 15/12/25.
//  Copyright © 2015年 harvey. All rights reserved.
//

import Foundation
import UIKit

// MARK: - circle image
public extension UIImage {
    
    public func circleImage() -> UIImage{
        UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()
        //圆的边框宽度为2，颜色为红色
        
        CGContextSetLineWidth(context,0);
        
        CGContextSetStrokeColorWithColor(context, UIColor.clearColor().CGColor);
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height)
        
        CGContextAddEllipseInRect(context, rect);
        
        CGContextClip(context);
        
        //在圆区域内画出image原图
        self.drawInRect(rect)
        
        CGContextAddEllipseInRect(context, rect);
        
        CGContextStrokePath(context);
        
        //生成新的image
        
        let newimg = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return newimg;
        
    }
}