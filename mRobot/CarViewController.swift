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

@objc(CarViewController)
final class CarViewController:UIViewController{

   // MARK: －UI控件初始化
    var videoView:UIWebView!
    var writeDataTimer:NSTimer!
    var rocker1:ZMRocker!
    var rocker2:ZMRocker!
    var rockerImage1:UIImageView!
    var rockerImage2:UIImageView!
    var button2:UIButton!
    var button3:UIButton!
    var shotScreenButton:UIButton!
    
    
    // MARK: －wifi bluetooth 初始化
    var camClient:TCPClient!
    var bleMingle: BLEMingle!
    var peripheral:CBPeripheral!
    var _nBytes:Int = 0
    var writeCount:Int = 18
    var resultImage : UIImage!;
    var wifiUrl = "192.168.1.1"
    var delegate: ControlBleDelegate?
    var writeData:NSMutableData = NSMutableData()
   
     // MARK: - 滑杆值初始化
    var speed:UInt16 = 0
    var accelerator:UInt16 = 0
    var holderspeed:UInt16 = 0
    var holderaccelerator:UInt16 = 0
    var transition:CustomModelTranstion?
    var pushPopInteractionController: RZTransitionInteractionController?
    // MARK: - viewDidLoad
    override func viewDidLoad() {

        //背景图片
        let backGroundImage = UIImageView(frame:self.view.bounds)
        backGroundImage.image = UIImage(named:"mtank_bg")
        self.view.addSubview(backGroundImage)
        
        //显示视频
        self.videoView = UIWebView(frame:self.view.bounds)
        self.videoView.backgroundColor = UIColor(patternImage:UIImage(named:"mtank_bg")!)
        self.videoView.scalesPageToFit = true
        self.videoView.scrollView.bounces = false
        self.videoView.scrollView.scrollEnabled = false
        self.videoView.hidden = true
        self.view.addSubview(videoView)
        
        //截屏按钮
        shotScreenButton = UIButton(frame:CGRectMake(SCREEN_WIDTH-60,20,40,40))
        shotScreenButton.backgroundColor = UIColor.blackColor()
        shotScreenButton.layer.cornerRadius = 20
        shotScreenButton.hidden = true
        shotScreenButton.addTarget(self, action:#selector(screenShotAction), forControlEvents: UIControlEvents.TouchUpInside)
        shotScreenButton.setImage(UIImage(named:"icon_photo"), forState:UIControlState.Normal)
        self.view.addSubview(shotScreenButton)
        
        //创建滑杆
        createRockView()
        
        //底部滑动按钮
        createBottomButton()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissSelfOnTap))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    override func viewWillAppear(animated: Bool) {
       
        self.navigationController?.navigationBarHidden = true
        
        //连接wrt
        connectWrt()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(initbleMingle), name: "bleMingle", object: nil)

    }
 
     // MARK: - 连接Wrt小车
    func connectWrt(){
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let group = dispatch_group_create()
        
        dispatch_group_async(group, queue, {
            
            //创建socket
            self.camClient = TCPClient(addr:self.wifiUrl, port:8080)
            let (success,_)=self.camClient.connect(timeout: 1)
       
            if(success){
                self.videoView.hidden = false
                self.shotScreenButton.hidden = false
                self.videoView.loadRequest(NSURLRequest(URL: NSURL(string:"http://192.168.1.1:8080/?action=stream")!))
            }else{
                self.videoView.hidden = true
                self.shotScreenButton.hidden = true
            }

            
        })
        dispatch_group_async(group, queue, {
          
           
          //  self.autoScan()
        })
        dispatch_group_notify(group, queue, {
            
        })
        
        

    }
     // MARK: - 滑杆
    func createRockView(){
        
        
        rockerImage1 = UIImageView(frame:CGRectMake(10,SCREEN_HEIGHT-220,20,20))
        rockerImage1.image = UIImage(named:"icon_move")
        self.view.addSubview(rockerImage1)
        
        
        rocker1 = ZMRocker(frame:CGRectMake(20,SCREEN_HEIGHT-200,180,180));
        rocker1.delegate = self;
        rocker1.tag = 1
        self.view.addSubview(rocker1);
        
        
        rockerImage2 = UIImageView(frame:CGRectMake(SCREEN_WIDTH-30,SCREEN_HEIGHT-220,20,20))
        rockerImage2.image = UIImage(named:"icon_rotate")
        self.view.addSubview(rockerImage2)
        
        rocker2 = ZMRocker(frame:CGRectMake(SCREEN_WIDTH-200,SCREEN_HEIGHT-200,180,180));
        rocker2.delegate = self;
        rocker2.tag = 2
        self.view.addSubview(rocker2);
    
    }
    
     // MARK: - 底部功能按钮
    func createBottomButton(){

        button2 = UIButton(frame:CGRectMake(SCREEN_WIDTH/2.80,SCREEN_HEIGHT-60,40,40))
        button2.backgroundColor = UIColor.blackColor()
        button2.layer.cornerRadius = 20
        button2.hidden = true
        button2.setImage(UIImage(named:"icon_fire"), forState:UIControlState.Normal)
        self.view.addSubview(button2)
        
        button3 = UIButton(frame:CGRectMake(SCREEN_WIDTH/1.70,SCREEN_HEIGHT-60,40,40))
        button3.backgroundColor = UIColor.blackColor()
        button3.layer.cornerRadius = 20
        button3.hidden = true
        button3.setImage(UIImage(named:"icon_fire"), forState:UIControlState.Normal)
        self.view.addSubview(button3)
        
        
        let controlButton = UIButton(frame:CGRectMake(SCREEN_WIDTH/2-20,SCREEN_HEIGHT-60,40,40))
        controlButton.backgroundColor = UIColor.blackColor()
        controlButton.layer.cornerRadius = 20
        controlButton.setImage(UIImage(named:"icon_menu"), forState:UIControlState.Normal)
        controlButton.addTarget(self, action:#selector(controlAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(controlButton)
        }
    
 
    
}

extension CarViewController{

     // MARK: - 初始化蓝牙
    func initbleMingle(title:NSNotification){
        
     bleMingle = title.object?.objectForKey("bleMingle") as! BLEMingle
    
     peripheral = title.object?.objectForKey("peripheral") as! CBPeripheral
   
        if(title.object?.objectForKey("segmentedIndex") as! Int==1){
        
            rocker1.tag = 2
            rocker2.tag = 1
            rockerImage1.image = UIImage(named:"icon_move")
            rockerImage2.image = UIImage(named:"icon_rotate")
            button2.hidden = false
            button3.hidden = true
            
        }else{
            rocker1.tag = 1
            rocker2.tag = 2
            rockerImage1.image = UIImage(named:"icon_rotate")
            rockerImage2.image = UIImage(named:"icon_move")
            button2.hidden = true
            button3.hidden = false
        
        }
    
    }

    // MARK: - 写入数据
    func doTimer(){
        
        writeDataTimer = NSTimer.scheduledTimerWithTimeInterval(0.020, target: self, selector: #selector(timerFireMethod), userInfo: nil, repeats:true);
        writeDataTimer.fire()
        
    }
    
    func timerFireMethod() {
//      
//       if(rocker1.y != 0||rocker2.y != 0){
//            if (_nBytes+writeCount<=writeData.length) {
//                if((bleMingle) != nil){
//                    bleMingle.writeValue(writeData.subdataWithRange(NSMakeRange(_nBytes,writeCount)))
//                }
//                _nBytes=_nBytes+writeCount
//            }else{
//                if((bleMingle) != nil){
//                    bleMingle.writeValue(writeData.subdataWithRange(NSMakeRange(_nBytes,2)))
//                }
//                _nBytes = 0
//            }
//        
//       }
        
        
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
    }}

extension CarViewController:ZMRockerDelegate{

    
    func rockerStateDidChange(touchTag: String!) {
        
           let stateDict = NSMutableDictionary()
           stateDict.setValue(touchTag, forKey:"touchTag")
        
        NSNotificationCenter.defaultCenter().postNotificationName("touchState", object:stateDict);
       
    }
    
    // MARK: -  滑杆值计算公式
    func rockerDidChangeDirection(rocker: ZMRocker!) {
        
        
        print(rocker.x,rocker.y)
        
        
     if(rocker.tag == 1){
           
            if(rocker.y>20){
                
                holderspeed = holderspeed == 0 ? 1500 : 1500   //摇杆
                
                holderaccelerator = holderaccelerator == 0 ? 1500 : 1500
                
                speed = UInt16(1500+abs(rocker.y/117) * 500)>1800 ? 2000 : UInt16(1500+abs(rocker.y/117) * 500)
             
            }
            else if(abs(rocker.y)<20){
                
                speed = UInt16(1500)
                
            }else{
                speed = UInt16(1500-abs(rocker.y/117) * 500)<1200 ? 1000 : UInt16(1500-abs(rocker.y/117) * 500)
              
            }
            
            
            if(rocker.x>20){
                
                accelerator = UInt16(1500+abs(rocker.x/117) * 500)>1800 ? 2000 : UInt16(1500+abs(rocker.x/117) * 500)
                
            }
            else if(abs(rocker.x)<20){
                
                accelerator = UInt16(1500)
                
            }else{
                accelerator = UInt16(1500-abs(rocker.x/117) * 500)<1200 ?1000:UInt16(1500-abs(rocker.x/117) * 500)
            }

        
        }else{
          
            
            speed = speed == 0 ? 1500 : 1500
           
            accelerator = accelerator == 0 ? 1500 :1500
        
            if(rocker.y == 0.0||abs(rocker.y)<20){
            
                holderspeed = 1500
            
            }
            else if(rocker.y>20){
            
                holderspeed = UInt16(1500+abs(rocker.y/117) * 500)>1800 ? 2000 : UInt16(1500+abs(rocker.y/117) * 500)
            
            }else{
                holderspeed = UInt16(1500-abs(rocker.y/117) * 500)<1200 ? 1000 : UInt16(1500-abs(rocker.y/117) * 500)
                
            }
            
            if(rocker.x == 0.0){
                
                holderaccelerator = 1500
                
            }
            else if(rocker.x>20){
                
                holderaccelerator = UInt16(1500+abs(rocker.x/117) * 500)>1800 ? 2000 : UInt16(1500+abs(rocker.x/117) * 500)
                
            }else if(abs(rocker.x)<20){
                
                holderaccelerator = 1500
                
            }else{
                holderaccelerator = UInt16(1500-abs(rocker.x/117) * 500)<1200 ?1000:UInt16(1500-abs(rocker.x/117) * 500)
            }

            
        }
        
        writeDataFormat(accelerator, speed: speed, holderaccelerator: holderaccelerator, holderspeed: holderspeed)
        
        doTimer()
        
    }
     // MARK: -  格式化输入数据
    func writeDataFormat(accelerator:UInt16,speed:UInt16,holderaccelerator:UInt16,holderspeed:UInt16){
    
        var head: UInt16 = UInt16(0xBBAA)
        var code:UInt8 = UInt8(0xc8)
        var data:[UInt16] = [accelerator,speed,holderaccelerator,holderspeed,1500,1500,1500,1500]
 
        var sum =  getChecksum(16, cmd:200, mydata:data)
        writeData = NSMutableData()
        writeData.appendBytes(&head, length:sizeof(UInt16))
        writeData.appendBytes(&code, length:sizeof(UInt8))
        writeData.appendBytes(&data, length:sizeof(UInt16)*8)
        writeData.appendBytes(&sum, length:sizeof(UInt8))
    
        }


}
extension CarViewController{

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
protocol ControlBleDelegate {
    
    func getPeripheralList(array:NSArray)
    
    
}

