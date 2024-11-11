//
//  LocationManager.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 11/5/24.
//

import Foundation
import CoreLocation
import MapKit

struct LocationString {
    let country: String
    let city: String
    let address: String
}

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    var manager = CLLocationManager()
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    
    func checkLocationAuthorization() -> CLAuthorizationStatus {
        manager.delegate = self
        manager.startUpdatingLocation()
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            return .notDetermined
        case .restricted:
            print("Location access restricted")
            return .restricted
        case .denied:
            print("Location access denied")
            return .denied
        case .authorizedAlways:
            print("Location access granted")
            return .authorizedAlways
        case .authorizedWhenInUse:
            lastKnownLocation = manager.location?.coordinate
            return .authorizedWhenInUse
        @unknown default:
            print("Location services disabled")
            return .notDetermined
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        _ = checkLocationAuthorization()
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
                     completion: @escaping(CLLocationCoordinate2D?) -> Void) {
        
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
            
            completion(location.coordinate)
        }
    }
}

extension LocationManager: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
    }
}

struct AddressSearchViewData: Identifiable {
    var id = UUID()
    var address: String
    var city: String?
    
//    init(mapItem: MKMapItem) {
//        self.address = (mapItem.placemark.thoroughfare ?? "") + " " + (mapItem.placemark.subThoroughfare ?? "")
//        self.city = mapItem.placemark.locality ?? ""
//    }
}
