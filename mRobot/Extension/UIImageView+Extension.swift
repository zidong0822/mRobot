//
//  UIImageView+Extension.swift
//  YHAPP
//
//  Created by harvey on 16/3/16.
//  Copyright © 2016年 harvey. All rights reserved.
//
import Foundation
import UIKit

public extension UIImageView{
    
    
    public class func getScreenShotImage(view:UIWebView){
    
        
        let viewHeight = Int(view.bounds.size.height);
        let pageHeight = Int(view.bounds.size.height);
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            var current = 0
            let totalCount = Int(pageHeight / viewHeight) + 1
            var screenShotImage : UIImage!
            
            for(current = 0 ; current < totalCount ; current++ ){
                
                
                NSThread.sleepForTimeInterval(0.3)
                
                let image = screenShot(view)
                
                if current == 0 {
                    screenShotImage = UIImage(CGImage:image.CGImage!)
                    continue
                }else{
                    screenShotImage = addImage(screenShotImage, image2: image)
                }
                
            }
            
            let resultImage = getSubImage(screenShotImage.CGImage!, rect: CGRectMake(0,0,view.frame.size.width,CGFloat(pageHeight)))//screenShotImage;
            UIImageWriteToSavedPhotosAlbum(resultImage, nil, nil, nil);//保存图片到照片库
            let imageViewData = UIImagePNGRepresentation(resultImage);
            let pictureName = "screenShow.png";
            let savedImagePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                .UserDomainMask,
                true).first!+pictureName
            imageViewData?.writeToFile(savedImagePath, atomically:true)
            
            
    }
   
}
    
    public class func screenShot(view:UIWebView) -> UIImage{
        
        UIGraphicsBeginImageContext(view.bounds.size);
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let resultingImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return resultingImage
    }

    public class func addImage(image1:UIImage!,image2:UIImage!) -> UIImage{
        
        let size = CGSizeMake(image2.size.width , image1.size.height + image2.size.height)
        
        UIGraphicsBeginImageContext(size)
        
        UIGraphicsGetCurrentContext()
        
        // Draw iamge1
        image1.drawInRect(CGRectMake(0, 0, image1.size.width, image1.size.height))
        
        // Draw image2
        image2.drawInRect(CGRectMake(0, image1.size.height, image2.size.width, image2.size.height))
        
        let resultingImage : UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resultingImage
    }
    
    public class func getSubImage(image:CGImageRef,rect:CGRect) -> UIImage{
        let subImageRef = CGImageCreateWithImageInRect(image, rect)
        let smallBounds = CGRectMake(0, 0, CGFloat(CGImageGetWidth(subImageRef)), CGFloat(CGImageGetHeight(subImageRef)))
        
        UIGraphicsBeginImageContext(smallBounds.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawImage(context, smallBounds,subImageRef)
        let smallImage = UIImage(CGImage: subImageRef!)
        UIGraphicsEndImageContext()
        
        return smallImage;
    }
    
}