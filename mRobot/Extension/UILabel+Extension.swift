//
//  UILabel+Additions.swift
//  YHAPP
//
//  Created by HeHongwe on 15/12/25.
//  Copyright © 2015年 harvey. All rights reserved.
//
import Foundation
import UIKit
extension UILabel {
    
    /**
    Methods to allow using HTML code with CoreText
    
    */
    func ausAttributedText(data: String) {
        do {
            let formatedData = data.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let text = try NSAttributedString(data: formatedData.dataUsingEncoding(NSUnicodeStringEncoding,allowLossyConversion: false)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            self.attributedText = text
        }catch{
            print("something error with NSAttributedString")
        }
    }
    
    /**
    calculate size of UILabel
    
    :returns: CGSize
    */
    func ausReturnFrameSizeAfterResizingLabel() -> CGSize{
        let fixedWidth = self.frame.size.width
        self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = self.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        self.frame = newFrame
        return self.frame.size
    }

}