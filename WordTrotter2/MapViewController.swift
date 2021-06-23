//
//  MapViewController.swift
//  WordTrotter2
//
//  Created by Dylan Welch on 5/12/20.
//  Copyright © 2020 Dylan Welch. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    @IBOutlet var currentLocation: UIButton!
    let locationManager = CLLocationManager()
    private var userLocationButtonClicked: Bool = false
    
    override func loadView() {
        // Create a map view & web view
        mapView = MKMapView()
        
        // Set it as *the* view of this view controller
        view = mapView
        
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        
        let segmentedControl = UISegmentedControl(items: [standardString, satelliteString, hybridString])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
    }
    
    override func viewDidLoad() {
        mapView.showsUserLocation = true
        locationManager.delegate = self
        
        currentLocation = UIButton(frame: CGRect(x: 8, y: 8, width: 100, height: 20))
        currentLocation.setTitle("My Location", for: UIControl.State.normal)
        currentLocation.backgroundColor = UIColor.blue
        currentLocation.addTarget(self, action: #selector(showUserLocation(_:)), for: UIControl.Event.touchUpInside)
        view.addSubview(currentLocation)
        super.viewDidLoad()
        
         
         print("MapViewController loaded its view.")
         
     }
    
    @objc func showUserLocation(_ sender: UIButton) {
        print("\nStart of showUserLocation()")
        print("\nUser's location: lat=\(mapView.userLocation.coordinate), title=\(mapView.userLocation.title!)")
        
        userLocationButtonClicked = true
        
        switch CLLocationManager.authorizationStatus() {
            case CLAuthorizationStatus.notDetermined, .restricted, .denied:
            locationManager.requestWhenInUseAuthorization()
            case CLAuthorizationStatus.authorizedWhenInUse, .authorizedAlways:
            requestLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("\nStart of locationManager(didChangeAuthorization)")
        
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == CLAuthorizationStatus.authorizedWhenInUse || authStatus == CLAuthorizationStatus.authorizedAlways {
            requestLocation()
        }
        print("\nEnd of locationManager(didChangeAuthorization)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\nStart of locationanager(didUpdateLocations)")
        
        if userLocationButtonClicked {
            userLocationButtonClicked = false
            zoomInLocation(locations.last!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let err = error as? CLError, err.code == .denied {
            manager.stopUpdatingLocation()
            return
        }
        print("\nlocationManager(): \(error.localizedDescription)")
    }
    
    private func requestLocation() {
        print("\requestLocation() called")
        
        // Check if the location service is available on that device
        if !CLLocationManager.locationServicesEnabled() {
            return
        }
        
        locationManager.requestLocation()
    }
    
    private func zoomInLocation(_ location: CLLocation) {
        print("\nzoomInUserLocation(): mapView[latitude]=\(location.coordinate.latitude), locationManager[latititude]=\(String(describing: location.coordinate.latitude))")
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, span: coordinateSpan)
        mapView.centerCoordinate = location.coordinate
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
           switch segControl.selectedSegmentIndex {
           case 0:
               mapView.mapType = .standard
           case 1:
               mapView.mapType = .hybrid
           case 2:
               mapView.mapType = .satellite
           default:
               break
           }
    }
    
 
    
}
