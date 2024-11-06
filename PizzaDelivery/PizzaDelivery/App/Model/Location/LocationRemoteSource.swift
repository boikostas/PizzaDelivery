//
//  LocationRemoteSource.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 11/5/24.
//

import Foundation
import CoreLocation
import Swinject

protocol LocationRemoteSource {
    func getUserLoation() -> CLLocationCoordinate2D?
    func requestAccessToLocation()
    func getUserLocationPlaceString(location: CLLocation, completion: @escaping ((LocationString) -> Void))
    func getLocation(forPlaceCalled name: String, completion: @escaping(CLLocation?) -> Void)
}

class LocationRemoteSourceImpl: LocationRemoteSource {
    
    private var locationManager: LocationManager
    
    init() {
        self.locationManager = LocationManager()
    }
    
    func getUserLoation() -> CLLocationCoordinate2D? {
        locationManager.lastKnownLocation
    }
    
    func requestAccessToLocation() {
        locationManager.checkLocationAuthorization()
    }
    
    func getUserLocationPlaceString(location: CLLocation, completion: @escaping ((LocationString) -> Void)) {
        locationManager.getUserLocationPlaceString(location: location, completion: completion)
    }
    
    func getLocation(forPlaceCalled name: String, completion: @escaping (CLLocation?) -> Void) {
        locationManager.getLocation(forPlaceCalled: name, completion: completion)
    }
}
