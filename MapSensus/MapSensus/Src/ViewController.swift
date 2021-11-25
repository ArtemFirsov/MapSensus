//
//  ViewController.swift
//  MapSensus
//
//  Created by Artem Firsov on 11/24/21.
//

import UIKit
import CoreLocation
import GoogleMaps

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var mapBottomLabel: UILabel!
    
    let manager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()

      
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            
            manager.requestLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location  = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15)
            let mark = GMSMarker()
            mark.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            //        mark.title = "world"
            //        mark.snippet = "center"
                    mark.map = mapView
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
//            guard let response = response else { return }
            
            guard let address = response?.firstResult(), let lines = address.lines else { return }
            
            self.mapBottomLabel.text = lines.joined(separator: "\n")
            
            let labelHeight = self.mapBottomLabel.intrinsicContentSize.height
            let topInset = self.view.safeAreaInsets.top
            
            self.mapView.padding = UIEdgeInsets(top: topInset, left: 0, bottom: labelHeight, right: 0)
            
                UIView.animate(withDuration: 0.5) {
                    
                    self.view.layoutIfNeeded()
                }
            
        }
    }
    
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else { return }
//
//        let coordinate = location.coordinate
//        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15)
//        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
//        self.view.addSubview(mapView)
//        mapView.isMyLocationEnabled = true
//        mapView.settings.myLocationButton = true
//
//
//
//        let mark = GMSMarker()
//        mark.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
////        mark.title = "world"
////        mark.snippet = "center"
//        mark.map = mapView
//    }
}

extension ViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocode(coordinate: position.target)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
}

