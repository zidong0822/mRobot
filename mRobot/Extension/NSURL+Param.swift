//
//  NSURL+ZXTool.swift
//  YHAPP
//
//  Created by HeHongwe on 15/12/25.
//  Copyright © 2015年 harvey. All rights reserved.
//

import Foundation

// MARK: - NSURL参数操作
public extension NSURL {

    /**
    获取URL中的参数字典
    
    - returns: 参数字典
    */
    public func paramDictionary() -> [String : String]? {
        guard let paramString: String? = self.query else {
            return nil
        }
        
        var dic = [String:String]()
        let paramArr:[String] = paramString!.componentsSeparatedByString("&")
        for param: String in paramArr {
            let entity:[String] = param.componentsSeparatedByString("=")
            dic[entity[0]] = entity[1]
        }
        
        return dic
    }
    
    /**
     获取指定Key的Value
     
     - parameter key: key字符串
     
     - returns: key对应的值
     */
    public func paramValue(key:String) -> String? {
        guard let dic = self.paramDictionary() else {
            return nil
        }
        
        let value = dic[key]
        return value
    }
    
    /**
    判断参数是否存在
    
    - parameter key: 参数的key
    
    - returns: 是否存在
    */
    public func isParamExist(key:String) -> Bool {
        guard let dic = self.paramDictionary() else {
            return false
        }
        
        if dic[key] == nil {
            return false
        }else {
            return true
        }
        
    }
    
    /**
     生成一个添加了指定参数的新的NSURL
     
     - parameter params: 参数键值对数组
     
     - returns: 新的NSURL
     */
    public func newURLByAppendingParams(params:[String : String]) -> NSURL {
        var urlString = self.absoluteString
        var isFirst = true
        
        for (key,value) in params {
            if isFirst {
                if self.query == nil {
                    //之前没有参数
                    urlString = urlString + "?" + key + "=" + value
                }else {
                    //之前有参数
                    urlString = urlString + "&" + key + "=" + value
                }
                isFirst = false
            }else {
                urlString = urlString + "&" + key + "=" + value
            }
            
        }
        
        return NSURL(string: urlString)!
    }
    
}