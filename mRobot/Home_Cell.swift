//
//  File.swift
//  mRobot
//
//  Created by harvey on 16/5/17.
//  Copyright © 2016年 harvey. All rights reserved.
//

class Home_Cell: UICollectionViewCell {
    
 
    var imgView : UIImageView?
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        //初始化各种控件
        imgView = UIImageView(frame: CGRectMake(5,5,SCREEN_WIDTH-10,SCREEN_HEIGHT-10))
        imgView?.image = UIImage(named:"mTank")
        self.addSubview(imgView!)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
