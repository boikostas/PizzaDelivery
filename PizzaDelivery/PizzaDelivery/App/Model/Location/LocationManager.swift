//
//  LocationManager.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 11/5/24.
//

import Foundation
import CoreLocation

struct LocationString {
    let country: String
    let city: String
    let address: String
}

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    var manager = CLLocationManager()
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    
    func checkLocationAuthorization() {
        manager.delegate = self
        manager.startUpdatingLocation()
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location access restricted")
        case .denied:
            print("Location access denied")
        case .authorizedAlways:
            print("Location access granted")
        case .authorizedWhenInUse:
            lastKnownLocation = manager.location?.coordinate
        @unknown default:
            print("Location services disabled")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
    
    private func getPlace(for location: CLLocation,
                  completion: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
    
    func getUserLocationPlaceString(location: CLLocation, completion: @escaping ((LocationString) -> Void)) {
        var country = ""
        var city = ""
        var address = ""
        
        getPlace(for: location) { placemark in
            guard let placemark = placemark else { return }
            
            if let street = placemark.thoroughfare {
                address += street
            }
            
            if let streetNumber = placemark.subThoroughfare {
                address = address + " \(streetNumber)"
            }
            
            if let cityName = placemark.locality {
                city = cityName
            }
            
            if let countryName = placemark.country {
                country = countryName
            }
            
            let locationString = LocationString(country: country, city: city, address: address)
            
            completion(locationString)
        }
    }
    
    func getLocation(forPlaceCalled name: String,
                     completion: @escaping(CLLocation?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(name) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            guard let location = placemark.location else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(location)
        }
    }
    
}
