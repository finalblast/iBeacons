//
//  ViewController.swift
//  iBeacons
//
//  Created by Nam (Nick) N. HUYNH on 3/24/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralManagerDelegate {

    
    var peripheralManager: CBPeripheralManager?
    let uuid = NSUUID()
    let identifier = NSBundle.mainBundle().bundleIdentifier!
    
    let major: CLBeaconMajorValue = 1
    let minor: CLBeaconMinorValue = 0
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        peripheralManager = CBPeripheralManager(delegate: self, queue: queue)
        if let manager = peripheralManager {
            
            manager.delegate = self
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        
        peripheral.stopAdvertising()
        switch peripheral.state {
            
        case CBPeripheralManagerState.PoweredOff:
            println("Powered Off")
        case CBPeripheralManagerState.PoweredOn:
            println("Powered On")
        case CBPeripheralManagerState.Resetting:
            println("Resetting")
        case CBPeripheralManagerState.Unauthorized:
            println("Unauthorized")
        case CBPeripheralManagerState.Unknown:
            println("Unknown")
        case CBPeripheralManagerState.Unsupported:
            println("UnSupported")
            
        }
        
        if peripheral.state != CBPeripheralManagerState.PoweredOn {
            
            let controller = UIAlertController(title: "Bluetooth", message: "Please turn bluetooth on!", preferredStyle: UIAlertControllerStyle.Alert)
            controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(controller, animated: true, completion: nil)
            
        } else {
            
            let region = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: identifier)
            let manufacturerData = identifier.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            let theUUID = CBUUID(NSUUID: uuid)
            let dataToBeAdvertised:[String: AnyObject!] = [
                CBAdvertisementDataLocalNameKey: "Sample",
                CBAdvertisementDataManufacturerDataKey: manufacturerData,
                CBAdvertisementDataOverflowServiceUUIDsKey: [theUUID]
            ]
            
            peripheral.startAdvertising(dataToBeAdvertised)
            
        }
        
    }
    
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager!, error: NSError!) {
        
        if error == nil {
            
            println("Successfully to advertise!")
            
        } else {
            
            println("Failed with error: \(error)")
            
        }
        
    }
    
}

