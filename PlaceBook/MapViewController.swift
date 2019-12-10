//
//  MapViewController.swift
//  PlaceBook
//
//  Created by MacBook on 11/30/19.
//  Copyright © 2019 Anton. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate {
    func getAddress(address: String?)
}

class MapViewController: UIViewController {
    
    var mapManager = MapManager()
    var place = Place()
    var mapViewControllerDelegate: MapViewControllerDelegate?
    
    var incomeSegueIdentifier = ""
    private var IncomeSegueForShowPlaceIdentifier = "showPlaceGeolocation"
    private var IncomeSegueForChoosePlaceIdentifier = "choosePlaceGeolocation"
    private let annotationIdentifier = "annotationIdentifier"
    
    private var previousLocation: CLLocation? {
        didSet {
            mapManager.startTrackingUserLocation(for: mapView, and: previousLocation) {
                (currentLocation) in
                self.previousLocation = currentLocation
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.mapManager.showUserLocation(mapView: self.mapView)
                }
            }
        }
    }
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var centerPin: UIImageView!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var pathBuildButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        mapView.delegate = self
    }
    
    @IBAction func CenterViewInUserLocation() {
        mapManager.showUserLocation(mapView: mapView)
    }
    @IBAction func doneButtonPressed() {
        mapViewControllerDelegate?.getAddress(address: locationLabel.text)
        dismiss(animated: true)
    }
    
    @IBAction func pathBuildButtonPressed() {
        mapManager.getDirections(for: mapView) {
            (location) in
            self.previousLocation = location
        }
    }
    
    @IBAction func closeVC() {
        dismiss(animated: true)
    }
    
    private func setupMapView() {
        mapManager.checkLocationServices(mapView: mapView, segueIdentifier: incomeSegueIdentifier) {
            mapManager.locationManager.delegate = self
        }
        
        if incomeSegueIdentifier == IncomeSegueForShowPlaceIdentifier {
            mapManager.setupPlaceLocation(place: place, mapView: mapView)
            locationLabel.isHidden = true
            centerPin.isHidden = true
            doneButton.isHidden = true
        } else if incomeSegueIdentifier == IncomeSegueForChoosePlaceIdentifier {
            pathBuildButton.isHidden = true
            locationLabel.text = ""
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        
        if let imageData = place.imageData {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 20
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            annotationView?.leftCalloutAccessoryView = imageView
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapManager.getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        
        if incomeSegueIdentifier == IncomeSegueForShowPlaceIdentifier && previousLocation != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.mapManager.showUserLocation(mapView: mapView)
            }
        }
        
        geocoder.cancelGeocode()
        
        geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            let street = placemark?.thoroughfare
            let buildingNumber = placemark?.subThoroughfare
            
            DispatchQueue.main.async {
                if street != nil && buildingNumber != nil {
                    self.locationLabel.text = "\(street!), \(buildingNumber!)"
                } else if street != nil {
                    self.locationLabel.text = "\(street!)"
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .green
        
        return renderer
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapManager.checkLocationAuthorization(mapView: mapView, segueIdentifier: incomeSegueIdentifier)
    }
}
