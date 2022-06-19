//
//  ViewController.swift
//  Detect-a-Beacon
//
//  Created by 陳怡安 on 2022/5/28.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var uuidInfo: UILabel!
    var locationManager: CLLocationManager?
    var beaconAlertHasShown = false
    var circleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
//        view.backgroundColor = .gray
        
        circleView = UIView()
        view.addSubview(circleView)
        
        circleView.frame.size.height = 256
        circleView.frame.size.width = 256
        circleView.center = view.center
        circleView.layer.borderWidth = 1
        circleView.layer.cornerRadius = 128
        circleView.layer.borderColor = UIColor.gray.cgColor
        circleView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B8E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity, uuid: UUID?) {
        
        UIView.animate(withDuration: 1) {
            
            switch distance {
            case .far:
//                self.view.backgroundColor = .blue
                self.circleView.layer.borderColor = UIColor.blue.cgColor
                self.distanceReading.text = "FAR"
                self.uuidInfo.text = uuid?.uuidString
                self.circleView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                
            case .near:
//                self.view.backgroundColor = .orange
                self.circleView.layer.borderColor = UIColor.orange.cgColor
                self.distanceReading.text = "NEAR"
                self.uuidInfo.text = uuid?.uuidString
                self.circleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                
            case .immediate:
//                self.view.backgroundColor = .red
                self.circleView.layer.borderColor = UIColor.red.cgColor
                self.distanceReading.text = "RIGHT HERE"
                self.uuidInfo.text = uuid?.uuidString
                self.circleView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
            default:
//                self.view.backgroundColor = .gray
                self.circleView.layer.borderColor = UIColor.green.cgColor
                self.distanceReading.text = "UNKOWN"
                self.uuidInfo.text = "No UUID Info"
                self.circleView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity, uuid: beacon.uuid)
            
            if beaconAlertHasShown == false {
                let message = beacon.uuid.uuidString
                let ac = UIAlertController(title: "iBeacon detected", message: message, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                    self?.beaconAlertHasShown = true
                })
                present(ac, animated: true)
            }
            
        } else {
            update(distance: .unknown, uuid: nil)
        }
    }
}

