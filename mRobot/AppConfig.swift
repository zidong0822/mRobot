//
//  AppConfig.swift
//  Elara
//
//  Created by HeHongwe on 15/12/18.
//  Copyright © 2015年 harvey. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift

let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height

let UI_FONT_20 = UIFont.systemFontOfSize(20)
let UI_FONT_16 = UIFont.systemFontOfSize(16)
let UI_FONT_14 = UIFont.systemFontOfSize(14)
let UI_FONT_10 = UIFont.systemFontOfSize(10)

let UNLOCK_CMD :[UInt16] = [1500, 1500, 2000, 1000, 1500, 1500, 1500, 1500]
let NORMAL_CMD :[UInt16] = [1500, 1500, 1500, 1150, 1000, 1000, 1000, 1000]
let DOWN_CMD:[UInt16] = [1500, 1500, 1500, 1200, 1000, 1000, 1000, 1000]
let LOCK_CMD:[UInt16] = [1500, 1500, 1000, 1000, 1500, 1500, 1500, 1500]



public func setPeripheralUUID(uuid:String){
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setValue(uuid, forKey:"UUIDString")
    userDefaults.synchronize()
    
}
public func getPeripheralUUID()->String{
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    if  userDefaults.objectForKey("UUIDString") != nil {
        
        return userDefaults.objectForKey("UUIDString") as! String
        
    }else{
        
        return ""
        
    }
    
}

public func setSegment(index:Int){

    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setValue(index, forKey:"segmentIndex")
    userDefaults.synchronize()


}
public func getSegment()->Int{

    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    if  userDefaults.objectForKey("segmentIndex") != nil {
        
        return userDefaults.objectForKey("segmentIndex") as! Int
        
    }else{
        
        return 10
        
    }

}
