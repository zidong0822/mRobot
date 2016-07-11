//
//  ControlViewController.swift
//  YHAPP
//
//  Created by HeHongwe on 16/1/19.
//  Copyright © 2016年 harvey. All rights reserved.
//

import UIKit
import CoreBluetooth

class  ControlViewController:UIViewController{
    
    var pickerView:CZPickerView!
    var tableView : UITableView?
    var bleMingle: BLEMingle!
    var peripheral:CBPeripheral!
    var peripheralString:String!
    var deviceList:NSMutableArray = NSMutableArray()
    var changeDict:NSMutableDictionary = NSMutableDictionary()
    var segmentedIndex = 0
    override func viewDidLoad() {
        
       
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(keyboardHide));
        tapGestureRecognizer.cancelsTouchesInView = false;
        self.view.addGestureRecognizer(tapGestureRecognizer)
        bleMingle = BLEMingle()
        bleMingle.delegate = self
    
       if getPeripheralUUID().characters.count>0{
            
            peripheralString = getPeripheralUUID()
            
        }
        
        self.tableView = UITableView(frame:CGRectMake((UIScreen.screenWidth()-300)/2,0,300,UIScreen.screenHeight()), style:UITableViewStyle.Grouped)
        self.tableView?.alpha = 1.0
        self.tableView?.backgroundColor = UIColor(rgba:"#E6E6E6")
        self.tableView?.dataSource = self
        self.tableView!.delegate = self
        self.tableView?.tableFooterView = UIView();
        self.tableView?.tag = 100
        self.view!.addSubview(self.tableView!)
        
        createPickerView()
        
       }
    
    override func viewWillAppear(animated: Bool) {
        
//        
//        if((peripheral) != nil){
//            
//            bleMingle.cancalPeripheral(peripheral)
//        
//        }
//        bleMingle = BLEMingle()
//        bleMingle.delegate = self
    }
    
     //创建弹出框
    func createPickerView(){
        
        pickerView = CZPickerView(headerTitle:"搜索到的设备",cancelButtonTitle:"取消",confirmButtonTitle:"确定")
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.needFooterView = false;
    }
    func segmentDidchange(segmented:UISegmentedControl){
        
        
        segmentedIndex = segmented.selectedSegmentIndex
        //获得选项的索引
        print(segmented.selectedSegmentIndex)
        //获得选择的文字
        print(segmented.titleForSegmentAtIndex(segmented.selectedSegmentIndex))
    }
    
    
    func textEdit(textField: UITextField) {
        
        self.view.frame = CGRectMake(0, 80,SCREEN_WIDTH,SCREEN_HEIGHT)
        
    }
    
    func scanBlueTooth(sender:UIButton){
    
          bleMingle.startScan();
    }
  
    
    func saveAction(sender:UIButton){
    
        if((peripheral) == nil && (bleMingle != nil) && peripheralString.characters.count>0){
        
            bleMingle.retrievePeripheralsWithIdentifiers([NSUUID(UUIDString:peripheralString)!])
        }

        
        
    changeDict.setValue(bleMingle, forKey:"bleMingle")
    changeDict.setValue(peripheral, forKey:"peripheral")
    setSegment(segmentedIndex)
    changeDict.setValue(segmentedIndex, forKey:"segmentedIndex")
    NSNotificationCenter.defaultCenter().postNotificationName("bleMingle", object:changeDict);
    self.dismissViewControllerAnimated(true) { () -> Void in
        
    }
    }
    
  func keyboardHide(tap:UITapGestureRecognizer){
        
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
    
        
    }
    
}
extension ControlViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 20
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
        switch(section){
        
        case 0:return "控制"
        case 1:return "蓝牙"
        case 2:return "WI-FI 摄像头"
        default:return ""
        }
      
    }
    
  
    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
     
            return 2
    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let tableCell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier:"cell")
        tableCell.selectionStyle = UITableViewCellSelectionStyle.None
        if(indexPath.section==0){
            if(indexPath.row == 0){
            
                //选项除了文字还可以是图片---
                let items=["美国手","日本手"] as [AnyObject]
                let segmented=UISegmentedControl(items:items)
                segmented.frame = CGRectMake(10,5,280,30)
                if(getSegment() != 10){
                  segmented.selectedSegmentIndex = getSegment()//默认选中第二项
                }
                
                segmented.addTarget(self, action: #selector(segmentDidchange),
                    forControlEvents: UIControlEvents.ValueChanged)  //添加值改变监听
                tableCell.addSubview(segmented)
            
            }else{
            
                let sendBytesCountField = UITextField(frame:CGRectMake(10,5,280,30))
                sendBytesCountField.backgroundColor = UIColor(rgba:"#F6F6F6")
                sendBytesCountField.placeholder = "20"
                sendBytesCountField.delegate = self
                sendBytesCountField.keyboardType = UIKeyboardType.DecimalPad
                tableCell.addSubview(sendBytesCountField)
            }
        
        }else if(indexPath.section == 1){
            if(indexPath.row == 0){
                let bleMacAddress = UILabel(frame:CGRectMake(0,5,280,30))
                bleMacAddress.textAlignment = NSTextAlignment.Center
                if((peripheral) != nil){
                    
                    bleMacAddress.text = peripheral.identifier.UUIDString
                }else if((peripheralString) != nil){
                
                    bleMacAddress.text = peripheralString
                
                }
                tableCell.addSubview(bleMacAddress)
            
            }else{
                
                let scanButton = UIButton(frame:CGRectMake(10,5,280,30))
                scanButton.setTitle("扫描BLE", forState: UIControlState.Normal)
                scanButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                scanButton.addTarget(self, action:#selector(scanBlueTooth), forControlEvents: UIControlEvents.TouchUpInside)
                scanButton.titleLabel?.textAlignment = NSTextAlignment.Center
                scanButton.backgroundColor = UIColor(rgba:"#F6F6F6")
                tableCell.addSubview(scanButton)
            
            }
        }else{
            if(indexPath.row == 0){
                let webAddress = UITextField(frame:CGRectMake(10,5,280,30))
                webAddress.text = "192.168.1.1:8080"
                webAddress.delegate = self
                webAddress.keyboardType = UIKeyboardType.DecimalPad
                tableCell.addSubview(webAddress)
                
            }else{
                
                let scanButton = UIButton(frame:CGRectMake(10,5,280,30))
                scanButton.setTitle("save", forState: UIControlState.Normal)
                scanButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                scanButton.titleLabel?.textAlignment = NSTextAlignment.Center
                scanButton.addTarget(self, action:#selector(saveAction), forControlEvents: UIControlEvents.TouchUpInside)
                scanButton.backgroundColor = UIColor(rgba:"#F6F6F6")
                tableCell.addSubview(scanButton)
                
            }
        }
        return tableCell;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 40;
    }
    
}
extension ControlViewController:BLECentralDelegate{
    
    
    // MARK: - 蓝牙代理方法
    func didDiscoverPeripheral(peripheral: CBPeripheral!){
        
        if(!self.deviceList.containsObject(peripheral)){
            self.deviceList.addObject(peripheral)
            if(!pickerView.hidden){
                pickerView.show();
            }
        }
        setPeripheralUUID(peripheral.identifier.UUIDString)
        print("搜索到的蓝牙\(peripheral)");
        
    }
    
    func getMessageFromPeripheral(characteristic: CBCharacteristic!) {
        
    }
    
    func getNativePeripheral(peripheral: CBPeripheral) {
     
        self.peripheral = peripheral
        bleMingle.connectPeripheral(peripheral)
        
    }
} 

extension ControlViewController:UITextFieldDelegate{


    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
      
        print(textField.text)
    }
    


}

extension ControlViewController:CZPickerViewDelegate,CZPickerViewDataSource{
    
    // MARK: - 弹出框
    func czpickerView(pickerView: CZPickerView!, attributedTitleForRow row: Int) -> NSAttributedString! {
        
        let TitleAttribute : NSDictionary =   NSDictionary(object:UIFont(name:"Avenir-Light", size:14)!, forKey:NSFontAttributeName)
        let cpl = self.deviceList[row] as!CBPeripheral
        let att =  NSAttributedString(string:cpl.identifier.UUIDString, attributes:TitleAttribute as? [String : AnyObject])
        return att
    }
    func czpickerView(pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        
        peripheral  = self.deviceList[row] as!CBPeripheral
        bleMingle.connectPeripheral(peripheral)
        self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow:0, inSection:1)], withRowAnimation: UITableViewRowAnimation.Automatic)
       
        
    }
    func numberOfRowsInPickerView(pickerView: CZPickerView!) -> Int {
        
        return self.deviceList.count
    }
    func czpickerView(pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        
        return self.deviceList[row] as! String
    }
    
}

