//
//  MapManager.swift
//  PlaceBook
//
//  Created by MacBook on 12/6/19.
//  Copyright © 2019 Anton. All rights reserved.
//

import UIKit
import  MapKit

class MapManager {
    
    let locationManager = CLLocationManager()
    private var placeCoordinate: CLLocationCoordinate2D?
    private let regionInMeters = 500.00
    private var directionsArray: [MKDirections] = []
    private var IncomeSegueForShowPlaceIdentifier = "showPlaceGeolocation"
    private var IncomeSegueForChoosePlaceIdentifier = "choosePlaceGeolocation"
    
    // Place Marker
    func setupPlaceLocation(place: Place, mapView: MKMapView) {
        guard let location = place.location else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = place.name
            annotation.subtitle = place.type
            
            guard let placemarkLocation = placemark?.location else { return }
            
            annotation.coordinate = placemarkLocation.coordinate
            self.placeCoordinate = placemarkLocation.coordinate
            
            mapView.showAnnotations([annotation], animated: true)
            mapView.selectAnnotation(annotation, animated: true)
            
        }
    }
    
    // Checking for enabling servises of geologation
    func checkLocationServices(mapView: MKMapView, segueIdentifier: String, closure: () -> ()) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            closure()
            checkLocationAuthorization(mapView: mapView, segueIdentifier: segueIdentifier)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.showAlert(title: "Location Services is disabled",
                               message: "To enable it go: Settings > Privacy > Location Services")
            }
        }
    }
    
    // Checking for programm authorization for using geolocation servises
    func checkLocationAuthorization(mapView: MKMapView, segueIdentifier: String) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            mapView.showsUserLocation = true
            if segueIdentifier == IncomeSegueForChoosePlaceIdentifier{ showUserLocation(mapView: mapView) }
            break
        case .denied, .restricted:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.showAlert(title: "Location Services is disabled",
                               message: "To enable it go: Settings > PlaceBook > Location")
            }
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        @unknown default:
            print("New authorization status is available (checkLocationAuthorization)")
        }
    }
    
    // Focus map on user geolocation
    func showUserLocation(mapView: MKMapView) {
        if let location = locationManager.location?.coordinate {
                   let region = MKCoordinateRegion(center: location,
                                                   latitudinalMeters: regionInMeters,
                                                   longitudinalMeters: regionInMeters)
                   mapView.setRegion(region, animated: true)
               }
    }
    
    // Build map path from user location to place location
    func getDirections(for mapView: MKMapView, previousLocation: (CLLocation) -> ()) {
        guard let location = locationManager.location?.coordinate else {
            showAlert(title: "Error", message: "Current location not found")
            return
        }
        
        locationManager.startUpdatingLocation()
        previousLocation(CLLocation(latitude: location.latitude, longitude: location.longitude))
        
        guard let request = createDirectionsRequest(from: location) else {
            showAlert(title: "Error", message: "Destination point not found")
            return
        }
        
        let directions = MKDirections(request: request)
        resetMapView(mapView: mapView, withNew: directions)
        
        directions.calculate { (response, error) in
            if let error = error {
                print(error)
            }
            guard let response = response else {
                self.showAlert(title: "Error", message: "Direction is not available")
                return
            }
            
            for route in response.routes {
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                let distance = String(route.distance/1000)
                let timeInterval = String(route.expectedTravelTime)
                print(distance)
                print(timeInterval)
            }
        }
    }
    
    // Setup request for building path on map
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        guard let destinationCoordinate = placeCoordinate else { return nil }
        
        let startPoint = MKPlacemark(coordinate: coordinate)
        let destinationPoint = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startPoint)
        request.destination = MKMapItem(placemark: destinationPoint)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    // Focus on user location
    func startTrackingUserLocation(for mapView: MKMapView,
                                   and location: CLLocation?,
                                   closure: ( _ currentLocation: CLLocation) -> () ) {
        guard let previousLocation = location else { return }
        let center = getCenterLocation(for: mapView)
        guard center.distance(from: previousLocation) > 50 else { return }
        closure(center)
    }
    
    // Remove old directions before building new
    func resetMapView(mapView:MKMapView, withNew directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
        directionsArray.removeAll()
    }
    
    // Get center location of visible region
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        return CLLocation(latitude: mapView.centerCoordinate.latitude,
                          longitude: mapView.centerCoordinate.longitude)
    }
    
    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        ac.addAction(ok)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(ac, animated: true)
    }
}










