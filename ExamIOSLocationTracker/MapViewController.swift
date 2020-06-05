//
//  ViewController.swift
//  ExamIOSLocationTracker
//
//  Created by a18277818 on 05.06.2020.
//  Copyright © 2020 Aleksandr Korotaevskiy. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    var isTracking = false
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var trackLabel: UILabel!
    
    @IBAction func toggleSwitch(_ sender: UISwitch) {
        if sender.isOn {
            isTracking = true
            let currentLoc = self.locationManager.location!.coordinate
            let currLat = String(format: "%.4f", currentLoc.latitude)
            let currLon = String(format: "%.4f", currentLoc.longitude)
            self.locationLabel.text = "Current location: lat: \(currLat), lon: \(currLon)"
        } else {
            isTracking = false
            locationLabel.text = "Current location: not tracking"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        
        locationManager.requestWhenInUseAuthorization()
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
        
        mapView.delegate = self
        // Do any additional setup after loading the view.
        
        if #available(iOS 9.0, *) {
            mapView.showsCompass = true
            mapView.showsScale = true
            mapView.showsTraffic = true
        }
        
        currentLocation()
        
        locationLabel.text = "Current location: not tracking"
        
    }
    
    func setUpMapView() {
       mapView.showsUserLocation = true
       mapView.showsCompass = true
       mapView.showsScale = true
       currentLocation()
    }
    func currentLocation() {
       locationManager.delegate = self
       locationManager.desiredAccuracy = kCLLocationAccuracyBest
       if #available(iOS 11.0, *) {
          locationManager.showsBackgroundLocationIndicator = true
       } else {
          // Fallback on earlier versions
       }
       locationManager.startUpdatingLocation()
    }

}


extension MapViewController: CLLocationManagerDelegate {
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let currentLocation = location.coordinate
        if self.isTracking {
            let currLat = String(format: "%.4f", currentLocation.latitude)
            let currLon = String(format: "%.4f", currentLocation.longitude)
            self.locationLabel.text = "Current location: lat: \(currLat), lon: \(currLon)"
        }
        let coordinateRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 800, longitudinalMeters: 800)
        mapView.setRegion(coordinateRegion, animated: true)
     }
     
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
     }
}
