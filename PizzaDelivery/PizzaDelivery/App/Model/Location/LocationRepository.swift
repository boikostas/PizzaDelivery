//
//  LocationRepository.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 11/5/24.
//

import Foundation
import CoreLocation
import Swinject
import MapKit

protocol LocationRepository {
    func getUserLocation() -> CLLocationCoordinate2D?
    func checkLocationAuthorization() -> CLAuthorizationStatus
    func getUserLocationPlaceString(location: CLLocation, completion: @escaping ((Address) -> Void))
    func getLocation(forPlaceCalled name: String, completion: @escaping(CLLocationCoordinate2D?) -> Void)
}

class LocationRepositoryImpl: LocationRepository {
    
    private var remoteSource: LocationRemoteSource
    
    init(dependencies: Resolver) {
        self.remoteSource = dependencies.resolve(LocationRemoteSource.self)!
    }
    
    func getUserLocation() -> CLLocationCoordinate2D? {
        remoteSource.getUserLoation()
    }
    
    func checkLocationAuthorization() -> CLAuthorizationStatus {
        remoteSource.checkLocationAuthorization()
    }
    
    func getUserLocationPlaceString(location: CLLocation, completion: @escaping ((Address) -> Void)) {
        remoteSource.getUserLocationPlaceString(location: location, completion: completion)
    }
    
    func getLocation(forPlaceCalled name: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        remoteSource.getLocation(forPlaceCalled: name, completion: completion)
    }
}
