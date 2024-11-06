//
//  LocationRepository.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 11/5/24.
//

import Foundation
import CoreLocation
import Swinject

protocol LocationRepository {
    func getUserLocation() -> CLLocationCoordinate2D?
    func requestAccessToLocation()
    func getUserLocationPlaceString(location: CLLocation, completion: @escaping ((LocationString) -> Void))
    func getLocation(forPlaceCalled name: String, completion: @escaping(CLLocation?) -> Void)
}

class LocationRepositoryImpl: LocationRepository {
    
    private var remoteSource: LocationRemoteSource
    
    init(dependencies: Resolver) {
        self.remoteSource = dependencies.resolve(LocationRemoteSource.self)!
    }
    
    func getUserLocation() -> CLLocationCoordinate2D? {
        remoteSource.getUserLoation()
    }
    
    func requestAccessToLocation() {
        remoteSource.requestAccessToLocation()
    }
    
    func getUserLocationPlaceString(location: CLLocation, completion: @escaping ((LocationString) -> Void)) {
        remoteSource.getUserLocationPlaceString(location: location, completion: completion)
    }
    
    func getLocation(forPlaceCalled name: String, completion: @escaping (CLLocation?) -> Void) {
        remoteSource.getLocation(forPlaceCalled: name, completion: completion)
    }
}
