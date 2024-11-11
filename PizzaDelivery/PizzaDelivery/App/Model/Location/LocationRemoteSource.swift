//
//  LocationRemoteSource.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 11/5/24.
//

import Foundation
import CoreLocation
import Swinject
import MapKit

protocol LocationRemoteSource {
    func getUserLoation() -> CLLocationCoordinate2D?
    func checkLocationAuthorization() -> CLAuthorizationStatus
    func getUserLocationPlaceString(location: CLLocation, completion: @escaping ((LocationString) -> Void))
    func getLocation(forPlaceCalled name: String, completion: @escaping(CLLocationCoordinate2D?) -> Void)
}

class LocationRemoteSourceImpl: LocationRemoteSource {
    
    private var locationManager: LocationManager
    
    var authorizationStatus: CLAuthorizationStatus?
    
    init() {
        self.locationManager = LocationManager()
    }
    
    func getUserLoation() -> CLLocationCoordinate2D? {
        locationManager.lastKnownLocation
    }
    
    func checkLocationAuthorization() -> CLAuthorizationStatus {
        locationManager.checkLocationAuthorization()
    }
    
    func getUserLocationPlaceString(location: CLLocation, completion: @escaping ((LocationString) -> Void)) {
        locationManager.getUserLocationPlaceString(location: location, completion: completion)
    }
    
    func getLocation(forPlaceCalled name: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        locationManager.getLocation(forPlaceCalled: name, completion: completion)
    }
}
