//
//  BLEHelper.swift
//  BLEHelper
//
//  Created by Microduino on 11/4/15.
//  Copyright © 2015 Microduino. All rights reserved.
//

import Foundation
import CoreBluetooth
//服务和特征的UUID
let kServiceUUID = [CBUUID(string:"F0C0")]
let kCharacteristicUUID = [CBUUID(string:"FFF6")]
let wCharacteristicUUID = [CBUUID(string:"F0C2")]
var periperel:NSString!

class BLEMingle: NSObject, CBPeripheralManagerDelegate, CBCentralManagerDelegate, CBPeripheralDelegate {


    var peripheralManager: CBPeripheralManager!
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var writeCharacteristic: CBCharacteristic!
    var checkCharacteristic: CBCharacteristic!
    var restartCharacteristic:CBCharacteristic!
    var delegate: BLECentralDelegate?
    var dataToSend: NSData!
    var  count:Int = 1;
    
   
    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        centralManager = CBCentralManager(delegate: self, queue: nil)
        print("initCentral")
    }


    func startScan() {
        centralManager.scanForPeripheralsWithServices(nil, options:[CBCentralManagerScanOptionAllowDuplicatesKey: false])
       print("Scanning started")
    }
    
    func didDiscoverPeripheral(peripheral: CBPeripheral!) -> CBPeripheral! {
      
        return nil
    }
    func stopScan() {
        centralManager.stopScan()
        print("Scanning stopped")
    }
     //2.检查运行这个App的设备是不是支持BLE。代理方法
    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch central.state {
        case CBCentralManagerState.PoweredOn:
            print("Bluetooth is now open, please scan the peripherals")
        case CBCentralManagerState.Unauthorized:
            print("The application can't use bluetooth low power consumption")
        case CBCentralManagerState.PoweredOff:
            print("Bluetooth is now closed")
        default:
            print("The central manager did not change the state")
        }

    }
    //3.查到外设后，停止扫描，连接设备
    //广播、扫描的响应数据保存在advertisementData 中，可以通过CBAdvertisementData 来访问它。
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber){
       
        print("Search to the device：\(peripheral)")
        
        delegate?.didDiscoverPeripheral(peripheral)

    }
     //连接外设失败
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        
    }
      //4.连接外设成功，开始发现服务
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
       
        print("Connected to the equipment: \(peripheral)")
        
        self.performSelector(#selector(sendNotificationCenter), withObject:nil, afterDelay:3.0)

        //停止扫描外设
        self.centralManager.stopScan()
        self.peripheral = peripheral
        self.peripheral.delegate = self
        self.peripheral.discoverServices(nil)
     
    }
    func sendNotificationCenter(){
    
        NSNotificationCenter.defaultCenter().postNotificationName("connectperipheral", object:nil)

    
    }
    //5.请求周边去寻找它的服务所列出的特征
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?){
        if error != nil {
            print("Service characteristics of the error:\(error!.localizedDescription)")
            return
        }
        var i: Int = 0
        for service in peripheral.services! {
            print("Service UUID:\(service.UUID)")
            i += 1
            //发现给定格式的服务的特性
            if (service.UUID == CBUUID(string:"FFF0")) {
             
                peripheral.discoverCharacteristics(kCharacteristicUUID, forService: service as CBService)
               // peripheral.discoverCharacteristics(wCharacteristicUUID, forService: service as CBService)
             
            }
            peripheral.discoverCharacteristics(nil, forService: service as CBService)
        }
    }
    //6.已搜索到Characteristics
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        print("Found the characteristics of the service:\(service.UUID.data)   ==  Service UUID:\(service.UUID)")
        if (error != nil){
            print("Found that the characteristics of the error：\(error!.localizedDescription)")
            return
        }
        
        for  characteristic in service.characteristics!  {
            //罗列出所有特性，看哪些是notify方式的，哪些是read方式的，哪些是可写入的。
            print("Service UUID:\(service.UUID)         characteristic UUID:\(characteristic.UUID)")
            //特征的值被更新，用setNotifyValue:forCharacteristic
            switch characteristic.UUID.description {
            case "FFF6":
                self.peripheral.readValueForCharacteristic(characteristic as CBCharacteristic)
                self.writeCharacteristic = characteristic
                //self.peripheral.setNotifyValue(true, forCharacteristic:characteristic);
            default:
                break
            }
        }

        print("didDiscoverCharacteristicsForService: \(service)")

    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
  
        if(characteristic.value?.length>0){
            
            
         delegate?.getMessageFromPeripheral(characteristic)
        }
              
    }
    //用于检测中心向外设写数据是否成功
       func peripheral(peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
         if(error != nil){
             print("Failure to send data!error message:\(error)")
       }else{
              print("To send data successfully\(characteristic)")
         }
   }

    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {

        if error != nil {
            print("Change notification state error：\(error?.localizedDescription)")
        }
    
         print("The characteristics of the received data：\(characteristic.value)")
       
        //开始通知
        if characteristic.isNotifying {
                  print("Began to notice\(characteristic)")
             peripheral.readValueForCharacteristic(characteristic)
        }else{
          //通知已停止
          //所有外设断开
            print("notice\(characteristic)Have stopped disconnected equipment")
                //  self.centralManager.cancelPeripheralConnection(self.peripheral)
         }
        
        print("==================\(characteristic.value)")
        
    }
    
    
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {

    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        
        
        
    }
    
    func peripheralDidUpdateName(peripheral: CBPeripheral) {
        
    }
    
    func peripheralManagerIsReadyToUpdateSubscribers(peripheral: CBPeripheralManager) {
        
    }
    
    func peripheralDidUpdateRSSI(peripheral: CBPeripheral, error: NSError?) {
        
    }
    
    func peripheral(peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: NSError?) {
        
    }
    
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?) {
        
    }
    
    func peripheral(peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, didReceiveReadRequest request: CBATTRequest) {
        
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, willRestoreState dict: [String : AnyObject]) {
        
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, didReceiveWriteRequests requests: [CBATTRequest]) {
        
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, didAddService service: CBService, error: NSError?) {
        
    }
    
    func peripheral(peripheral: CBPeripheral, didWriteValueForDescriptor descriptor: CBDescriptor, error: NSError?) {
        
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForDescriptor descriptor: CBDescriptor, error: NSError?) {
        
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverIncludedServicesForService service: CBService, error: NSError?) {
        
    }
    
    
    func peripheral(peripheral: CBPeripheral, didDiscoverDescriptorsForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
    }
    
    
    func retrievePeripheralsWithIdentifiers(identifiers: [NSUUID]!){
        
        let data = self.centralManager.retrievePeripheralsWithIdentifiers(identifiers)
        
        print("Data retrieved: \(data)")
        
        for peripheral1 in data as [CBPeripheral] {
            
            print("Peripheral : \(peripheral1)")
            delegate?.getNativePeripheral(peripheral1)
        }
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, central: CBCentral, didSubscribeToCharacteristic characteristic: CBCharacteristic) {
        
        print("Central subscribed to characteristic: \(characteristic)")
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFromCharacteristic characteristic: CBCharacteristic) {
        
        print("Central unsubscribed from characteristic")
    }
    
    class var sharedInstance: BLEMingle {
        struct Static {
            static let instance: BLEMingle = BLEMingle()
        }
        return Static.instance
    }
    
    func checkValue(data: NSData!){
        if((peripheral) != nil){
        
        peripheral.writeValue(data, forCharacteristic: self.checkCharacteristic,type: CBCharacteristicWriteType.WithResponse)
           print("Mobile data sent to the bluetooth is:\(data)")
           
        }
    }
    func writeValue(data: NSData!){
        if((peripheral) != nil){
            peripheral.writeValue(data, forCharacteristic: self.writeCharacteristic,type: CBCharacteristicWriteType.WithoutResponse)
            print("Mobile data sent to the bluetooth is:\(data)")
        }
    }
    func restartValue(data: NSData!){
        if((peripheral) != nil){
            peripheral.writeValue(data, forCharacteristic: self.restartCharacteristic,type: CBCharacteristicWriteType.WithoutResponse)
            print("Mobile data sent to the bluetooth is:\(data)")
            
        }
    }
    
    func connectPeripheral(peripheral: CBPeripheral){
    
        centralManager.connectPeripheral(peripheral, options: nil);
        
    }
    
    func cancalPeripheral(peripheral: CBPeripheral){
        
        centralManager.cancelPeripheralConnection(peripheral)
        
    }
    func connectPeripheralOfUUID(uuidString:String){
        
        
    }
}
protocol BLECentralDelegate {
    
    func didDiscoverPeripheral(peripheral: CBPeripheral!)
    
    func getMessageFromPeripheral(characteristic:CBCharacteristic!)
    
    func getNativePeripheral(peripheral:CBPeripheral)
    
}