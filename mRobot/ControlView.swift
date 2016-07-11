//
//  ControlView.swift
//  YHAPP
//
//  Created by HeHongwe on 16/1/19.
//  Copyright © 2016年 harvey. All rights reserved.
//

import UIKit
import CoreBluetooth

class  ControlView:UIScrollView,UITextFieldDelegate{

    var pickerView:CZPickerView!
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        
        self.backgroundColor = UIColor.whiteColor()
        self.contentSize = CGSizeMake(270,SCREEN_HEIGHT+100)
    
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(keyboardHide));
        tapGestureRecognizer.cancelsTouchesInView = false;
        self.addGestureRecognizer(tapGestureRecognizer)
        
        createControlView()
        createBleTitleLabel()
        createWebCamera()
    }

    
    func createControlView(){
        
        let titleLabel = UILabel(frame:CGRectMake(0,0,270,44))
        titleLabel.text = "Control"
        titleLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(titleLabel)
        
        
        //选项除了文字还可以是图片---
        let items=["US(Left)","Japan(Right)"] as [AnyObject]
        let segmented=UISegmentedControl(items:items)
        segmented.frame = CGRectMake(0,50,270,30)
        segmented.selectedSegmentIndex=1 //默认选中第二项
        segmented.addTarget(self, action: #selector(segmentDidchange),
            forControlEvents: UIControlEvents.ValueChanged)  //添加值改变监听
        self.addSubview(segmented)
        
        let sendBytesCountField = UITextField(frame:CGRectMake(0,100,270,30))
        sendBytesCountField.backgroundColor = UIColor.redColor()
        sendBytesCountField.text = "20"
        self.addSubview(sendBytesCountField)
        
    }
    
    
    
    func createBleTitleLabel(){
        
        let titleLabel1 = UILabel(frame:CGRectMake(0,140,270,44))
        titleLabel1.text = "Bluetooth"
        titleLabel1.textAlignment = NSTextAlignment.Center
        self.addSubview(titleLabel1)
        
        let bleMacAddress = UILabel(frame:CGRectMake(0,180,270,30))
        bleMacAddress.textAlignment = NSTextAlignment.Center
        bleMacAddress.text = "122222222222222"
        self.addSubview(bleMacAddress)
        
        let scanButton = UIButton(frame:CGRectMake(0,220,270,30))
        scanButton.setTitle("扫描BLE", forState: UIControlState.Normal)
        scanButton.titleLabel?.textAlignment = NSTextAlignment.Center
        scanButton.backgroundColor = UIColor.redColor()
        self.addSubview(scanButton)
        
        
    }
    
    func createWebCamera(){
        
        
        let webTitle = UILabel(frame:CGRectMake(0, 260, 270, 44))
        webTitle.text = "Web Camera"
        webTitle.textAlignment = NSTextAlignment.Center
        self.addSubview(webTitle)
        
        
        let webAddress = UITextField(frame:CGRectMake(0,310,270,30))
        webAddress.text = "192.168.1.1:8080"
        webAddress.delegate = self
        self.addSubview(webAddress)
        
        let saveButton = UIButton(frame:CGRectMake(0,340,270,30))
        saveButton.backgroundColor = UIColor.redColor()
        self.addSubview(saveButton)
        
        
        
        
    }

    func segmentDidchange(segmented:UISegmentedControl){
        //获得选项的索引
        print(segmented.selectedSegmentIndex)
        //获得选择的文字
        print(segmented.titleForSegmentAtIndex(segmented.selectedSegmentIndex))
    }
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    func keyboardHide(tap:UITapGestureRecognizer){
        
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
