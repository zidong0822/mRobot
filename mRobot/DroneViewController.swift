//
//  CarViewController.swift
//  YHAPP
//
//  Created by HeHongwe on 16/1/5.
//  Copyright © 2016年 harvey. All rights reserved.
//

import UIKit
import CoreBluetooth
import RZTransitions
import JGProgressHUD
import SMSegmentView
@objc(DroneViewController)
final class DroneViewController:UIViewController{
    
    // MARK: －UI控件初始化
    var writeDataTimer:NSTimer!
    var unLockTimer:NSTimer!
    var button3:UIButton!
    

    var bleMingle: BLEMingle!
    var peripheral:CBPeripheral!
    var _nBytes:Int = 0
    var writeCount:Int = 18
    var lockBytes:Int = 0
    var lockwriteCount:Int = 18
    var rockRange:Float = 450
    var resultImage : UIImage!
    var delegate: DroneControlBleDelegate?
    var writeData:NSMutableData = NSMutableData()
    
    // MARK: - 滑杆值初始化
    var speed:UInt16 = 0
    var accelerator:UInt16 = 0
    var holderspeed:UInt16 = 0
    var holderaccelerator:UInt16 = 0
    var lock:NSLock?
    var transition:CustomModelTranstion?
    var pushPopInteractionController: RZTransitionInteractionController?
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        
        //背景图片
        view.addSubview(backGroundImage)
        //显示视频
        view.addSubview(videoView)
        //截屏按钮
        view.addSubview(shotScreenButton)
        //创建滑杆
        createRockView()
        //底部滑动按钮
        createBottomButton()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissSelfOnTap))
        tapGestureRecognizer.numberOfTapsRequired = 2
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(initbleMingle), name: "bleMingle", object: nil)
        
    }
    
  

    // MARK: - 滑杆
    func createRockView(){
        
        self.view.addSubview(rockerImage1)
        self.view.addSubview(rocker1);
        self.view.addSubview(rockerImage2)
        self.view.addSubview(rocker2);
        
    }
    
    // MARK: - 底部功能按钮
    func createBottomButton(){
        
       // self.view.addSubview(LockButton)
        self.view.addSubview(controlButton)
        self.view.addSubview(lockButton)
        self.view.addSubview(rangeButton)
       
    }
    
    
    private lazy var backGroundImage:UIImageView = {
        
        let backGroundImage = UIImageView(frame:self.view.bounds)
        backGroundImage.image = UIImage(named:"mtank_bg")
        return backGroundImage
        
    }()
    
    private lazy var videoView:UIWebView = {
        let videoView = UIWebView(frame:self.view.bounds)
        videoView.backgroundColor = UIColor(patternImage:UIImage(named:"mtank_bg")!)
        videoView.scalesPageToFit = true
        videoView.scrollView.bounces = false
        videoView.scrollView.scrollEnabled = false
        videoView.hidden = true
        return videoView
    }()
    
    private lazy var shotScreenButton:UIButton = {
        let shotScreenButton = UIButton(frame:CGRectMake(SCREEN_WIDTH-60,20,40,40))
        shotScreenButton.backgroundColor = UIColor.blackColor()
        shotScreenButton.layer.cornerRadius = 20
        shotScreenButton.hidden = true
        shotScreenButton.addTarget(self, action:#selector(screenShotAction), forControlEvents: UIControlEvents.TouchUpInside)
        shotScreenButton.setImage(UIImage(named:"icon_photo"), forState:UIControlState.Normal)
        return shotScreenButton
    }()
    
    private lazy var rockerImage1:UIImageView = {
        
        let rockerImage1 = UIImageView(frame:CGRectMake(10,SCREEN_HEIGHT-220,20,20))
        rockerImage1.image = UIImage(named:"icon_move")
        return rockerImage1
    }()
    
    private lazy var rocker1:ZMRocker = {
        
        let rocker1 = ZMRocker(frame:CGRectMake(20,SCREEN_HEIGHT-200,180,180));
        rocker1.delegate = self;
        rocker1.tag = 1
        return rocker1
    }()
    
    private lazy var rockerImage2:UIImageView = {
        
        let rockerImage2 = UIImageView(frame:CGRectMake(SCREEN_WIDTH-30,SCREEN_HEIGHT-220,20,20))
        rockerImage2.image = UIImage(named:"icon_rotate")
        return rockerImage2
    }()
    
    private lazy var rocker2:ZMRocker = {
        
        let rocker2 = ZMRocker(frame:CGRectMake(SCREEN_WIDTH-200,SCREEN_HEIGHT-200,180,180));
        rocker2.delegate = self;
        rocker2.tag = 2
        return rocker2
    }()
   
    
    private lazy var controlButton:UIButton = {
        
        let controlButton = UIButton(frame:CGRectMake(SCREEN_WIDTH/2-20,SCREEN_HEIGHT-60,40,40))
        controlButton.backgroundColor = UIColor.blackColor()
        controlButton.layer.cornerRadius = 20
        controlButton.setImage(UIImage(named:"icon_menu"), forState:UIControlState.Normal)
        controlButton.addTarget(self, action:#selector(controlAction), forControlEvents: UIControlEvents.TouchUpInside)
        return controlButton
    }()

    
    private lazy var lockButton:UIButton = {
    
        let lockButton = UIButton(frame:CGRectMake(20,20,70,40))
        lockButton.backgroundColor = UIColor(rgba:"#D9D9D9")
        lockButton.setTitle("unLock", forState: UIControlState.Normal)
        lockButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        lockButton.titleLabel?.font = UI_FONT_16
        lockButton.tag = 1001
        lockButton.hidden = true
        lockButton.addTarget(self, action:#selector(lockAction), forControlEvents: UIControlEvents.TouchUpInside)
        return lockButton
    
    }()
    
    private lazy var rangeButton:UIButton = {
    
        let rangeButton = UIButton(frame:CGRectMake(120,20,70,40))
        rangeButton.backgroundColor = UIColor(rgba:"#D9D9D9")
        rangeButton.setTitle("Normal", forState: UIControlState.Normal)
        rangeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        rangeButton.titleLabel?.font = UI_FONT_16
        rangeButton.tag = 1001
        rangeButton.hidden = true
        rangeButton.addTarget(self, action:#selector(rangeAction), forControlEvents: UIControlEvents.TouchUpInside)
        return rangeButton
        
    }()

    
}

extension DroneViewController{
 
    
    func lockAction(sender:UIButton){
    
        if(sender.tag == 1001){
             unLockTimer = NSTimer.scheduledTimerWithTimeInterval(0.035, target: self, selector: #selector(unLockMethod), userInfo:0, repeats:true);
            sender.setTitle("Lock", forState: UIControlState.Normal)
            lockButton.tag = 1002
        }else{
        
            unLockTimer = NSTimer.scheduledTimerWithTimeInterval(0.035, target: self, selector: #selector(unLockMethod), userInfo:1, repeats:true);
            sender.setTitle("unLock", forState: UIControlState.Normal)
            lockButton.tag = 1001
            
        }
        unLockTimer.fire()
        let time: NSTimeInterval = 2.0
        let delay = dispatch_time(DISPATCH_TIME_NOW,
                                  Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            
            self.unLockTimer.invalidate()
        }}

    
    func rangeAction(sender:UIButton){
    
        if(sender.tag == 1001){
        
            sender.setTitle("Micro", forState: UIControlState.Normal)
            rangeButton.tag = 1002
            rockRange = 200
        }else{
        
            sender.setTitle("Normal", forState: UIControlState.Normal)
            rangeButton.tag = 1001
            rockRange = 450
            
        }
        
        
        
    
    }
    
// MARK:  初始化蓝牙
    func initbleMingle(title:NSNotification){
        
        lockButton.hidden = false
        rangeButton.hidden = false
        
        let hud = JGProgressHUD(style:.Dark)
        hud.indicatorView = nil
        hud.showInView(self.view)
        hud.textLabel.text = "ready"
        hud.dismissAfterDelay(1.0)
      
        if((bleMingle) == nil){
            bleMingle = title.object?.objectForKey("bleMingle") as! BLEMingle
            peripheral = title.object?.objectForKey("peripheral") as! CBPeripheral
        }
        if(title.object?.objectForKey("segmentedIndex") as! Int==0){
       
            rocker1.tag = 1
            rocker2.tag = 2
        }else{
       
            rocker1.tag = 2
            rocker2.tag = 1
        }
        
    }
    
    func unLockMethod(timer:NSTimer){
        
       let tag = timer.userInfo as! Int
        
  
        if((bleMingle) != nil){
            
            var head: UInt32 = UInt32(0x103c4d24)
            var code:UInt8 = UInt8(0xc8)
            var sum:UInt8 = 0
            let lockData = NSMutableData()
            lockData.appendBytes(&head, length:sizeof(UInt32))
            lockData.appendBytes(&code, length:sizeof(UInt8))
            if(tag == 0){
            sum =  getChecksum(16, cmd:200, mydata:UNLOCK_CMD)
                lockData.appendBytes(UNLOCK_CMD, length:sizeof(UInt16)*8)
                lockData.appendBytes(&sum, length:sizeof(UInt8))
            }else{
            sum =  getChecksum(16, cmd:200, mydata:LOCK_CMD)
                lockData.appendBytes(LOCK_CMD, length:sizeof(UInt16)*8)
                lockData.appendBytes(&sum, length:sizeof(UInt8))
            }
            if (lockBytes+lockwriteCount<=lockData.length) {
                if((bleMingle) != nil){
                    bleMingle.writeValue(lockData.subdataWithRange(NSMakeRange(lockBytes,lockwriteCount)))
                }
                lockBytes=lockBytes+lockwriteCount
            }else{
                if((bleMingle) != nil){
                    bleMingle.writeValue(lockData.subdataWithRange(NSMakeRange(lockBytes,4)))
                }
                lockBytes = 0
            }
            
        }
    }
    // MARK: - 写入数据
    func doTimer(){
        
        if((self.writeDataTimer) == nil){
        
        self.writeDataTimer = NSTimer.scheduledTimerWithTimeInterval(0.0175, target: self, selector: #selector(self.timerFireMethod), userInfo: nil, repeats:true)
        self.writeDataTimer.fire()
        }
    }
  
    func timerFireMethod() {

        if((self.bleMingle) != nil){
    
                if (self._nBytes+self.writeCount<=self.writeData.length) {
  
                    self.bleMingle.writeValue(self.writeData.subdataWithRange(NSMakeRange(self._nBytes,self.writeCount)))
             
                    self._nBytes=self._nBytes+self.writeCount
                }else{
   
                    self.bleMingle.writeValue(self.writeData.subdataWithRange(NSMakeRange(self._nBytes,4)))
                    self._nBytes = 0
                }
        }

    
    
    }
    // MARK: - 返回校验值
    func getChecksum(length:UInt16, cmd:UInt8, mydata:[UInt16]) ->UInt8{
        
        let writeData:NSMutableData = NSMutableData()
        writeData.appendBytes(mydata, length:sizeof(UInt16)*8)
        let count = writeData.length/sizeof(UInt8)
        var array = [UInt8](count:count,repeatedValue: 0)
        writeData.getBytes(&array, length:count * sizeof(UInt8))
        
        var checksum:UInt8 = 0
        checksum ^= (UInt8(length) & 0xFF)
        checksum ^= (cmd & 0xFF)
        for i in 0 ..< Int(length) {
            
            checksum ^= (array[i] & 0xFF);
            
        }
        return UInt8(checksum);
    }
}
extension DroneViewController:ZMRockerDelegate{
    
    
    func rockerStateDidChange(touchTag: String!) {
        
        let stateDict = NSMutableDictionary()
      
        stateDict.setValue(touchTag, forKey:"touchTag")
        
        NSNotificationCenter.defaultCenter().postNotificationName("touchState", object:stateDict);
        
    }
    
    // MARK: -  滑杆值计算公式
    func rockerDidChangeDirection(rocker: ZMRocker!) {
        
        speed = speed == 0 ? 1500 : 1500
        accelerator = accelerator == 0 ? 1500 :1500
        holderspeed = holderspeed == 0 ? 1500 : 1500   //摇杆
        holderaccelerator = holderaccelerator == 0 ? 1500 : 1500
    
        if(rocker.tag == 1){
        
        if((1500 + (rocker.y/70)*rockRange) > 1500+rockRange){
        
            speed =  1500 + UInt16(rockRange)
        
        }else if((1500 + (rocker.y/70)*rockRange) < 1500){
        
            speed = 1000
            
        }else{
        
            speed = UInt16(1500 + (rocker.y/70)*rockRange)
            accelerator = UInt16(1500 + (rocker.x/70)*rockRange) > 1500 + UInt16(rockRange) ? 1500 + UInt16(rockRange) : UInt16(1500 + (rocker.x/70)*rockRange)
        }
        }else{
        
            if(abs(rocker.x)<10){
            
                holderspeed = 1500
                holderaccelerator = UInt16(1500 + (rocker.y/70)*rockRange)>1500 + UInt16(rockRange) ? 1500 + UInt16(rockRange) : UInt16(1500 + (rocker.y/70)*rockRange)
     
            }else{
            
                holderaccelerator = 1500
                holderspeed =  UInt16(1500 + (rocker.x/70)*rockRange)>1500 + UInt16(rockRange) ? 1500 + UInt16(rockRange) : UInt16(1500 + (rocker.x/70)*rockRange)
            }
        }
      
        self.writeDataFormat(self.accelerator, speed: self.speed, holderaccelerator:self.holderspeed, holderspeed:self.holderaccelerator )
        self.doTimer()
    }
    

    // MARK: -  格式化输入数据
    func writeDataFormat(accelerator:UInt16,speed:UInt16,holderaccelerator:UInt16,holderspeed:UInt16){
        
        var head: UInt32 = UInt32(0x103c4d24)
        var code:UInt8 = UInt8(0xc8)
        var data:[UInt16] = [holderaccelerator,holderspeed,accelerator,speed,1500,1500,1500,1500]
        var sum =  getChecksum(16, cmd:200, mydata:data)
        self.writeData = NSMutableData()
        self.writeData.appendBytes(&head, length:sizeof(UInt32))
            self.writeData.appendBytes(&code, length:sizeof(UInt8))
            self.writeData.appendBytes(&data, length:sizeof(UInt16)*8)
            self.writeData.appendBytes(&sum, length:sizeof(UInt8))
        
        
        
     
    }
    
    
}
extension DroneViewController{
    
    // MARK: -  截屏操作
    func screenShotAction(sender: AnyObject) {
        
        UIImageView.getScreenShotImage(self.videoView)
        
    }
    // MARK: -  跳转控制页面
    func controlAction(sender:UIButton){
        
        let modelVC = ControlViewController()
        self.transition = CustomModelTranstion(ModelViewController:modelVC)
        self.transition!.setDrageqble(true)
        self.transition?.isInteractive = false
        modelVC.transitioningDelegate = self.transition
        modelVC.modalPresentationStyle = UIModalPresentationStyle.Custom
        self.presentViewController(modelVC, animated:true, completion:nil)
            
        }

    
    @objc(dismissSelfOnTap:)
    func dismissSelfOnTap(tapGestureRecognizer: UITapGestureRecognizer) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
protocol DroneControlBleDelegate {
    
    func getPeripheralList(array:NSArray)
    
    
}

