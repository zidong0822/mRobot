//
//  UIImage+Drawing.swift
//  YHAPP
//
//  Created by HeHongwe on 15/12/25.
//  Copyright © 2015年 harvey. All rights reserved.
//

import Foundation
import UIKit

// MARK: - draw image
public extension UIImage {
    
    /**
     用CGContextRef代码生成一个UIImage图片对象
     
     - parameter size:         图片大小
     - parameter drawingBlock: 绘画block
     
     - returns: 生成的图片
     */
    public class func image(size: CGSize, drawingBlock:(CGContextRef,CGRect) -> Void) -> UIImage? {
        guard CGSizeEqualToSize(size, CGSizeZero) == false else {
            return nil
        }
        
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextClearRect(context, rect)
        
        drawingBlock(context,rect)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
    
    /**
     生成一个单一颜色的UIImage图片对象
     
     - parameter color:  颜色
     - parameter size:  大小
     
     - returns: 生成的图片对象
     */
    public class func image(color:UIColor, size:CGSize) ->UIImage? {
        
        guard CGSizeEqualToSize(size, CGSizeZero) == false else {
            return nil
        }
        
        let target = UIImage.image(size, drawingBlock: { (context, rect) -> Void in
            CGContextSetFillColorWithColor(context, color.CGColor);
            CGContextFillRect(context, rect);
        })
        return target
    }
    
    
    class func imageWithColor(color: UIColor, size: CGSize, alpha: CGFloat) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        
        UIGraphicsBeginImageContext(rect.size)
        let ref = UIGraphicsGetCurrentContext()
        CGContextSetAlpha(ref, alpha)
        CGContextSetFillColorWithColor(ref, color.CGColor)
        CGContextFillRect(ref, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func createImageFromView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContext(view.bounds.size);
        
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return image
    }
    
    func imageClipOvalImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        let rect = CGRectMake(0, 0, self.size.width, self.size.height)
        CGContextAddEllipseInRect(ctx, rect)
        
        CGContextClip(ctx)
        self.drawInRect(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
}