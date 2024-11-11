//
//  MapScreenViewModel.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 11/1/24.
//

import Foundation
import Swinject
import MapKit
import _MapKit_SwiftUI

class MapScreenViewModel: ObservableObject {
    
    @Published var mapCameraPosition: MapCameraPosition = .automatic
    
    @Published var addressText: String = ""
    @Published var locationNameText: String = ""
    @Published var floorText: String = ""
    @Published var apartmentText: String = ""
    @Published var commentText: String = ""
    
    private let locationRepo: LocationRepository
    
    let findAddressScreenViewModel: FindAddressScreenViewModel?
    
    init(dependencies: Resolver) {
        locationRepo = dependencies.resolve(LocationRepository.self)!
        findAddressScreenViewModel = FindAddressScreenViewModel(dependencies: dependencies)
    }
    
    func isAuthorizationDenied() -> Bool {
        locationRepo.checkLocationAuthorization() == .denied ? true : false
    }
    
    func getUserLoction() {
        if locationRepo.checkLocationAuthorization() == .authorizedAlways || locationRepo.checkLocationAuthorization() == .authorizedWhenInUse {
            if let location = getUserCoordinates() {
                setMapRegion(from: location)
            }
        }
    }
    
    func getUserCoordinates() -> CLLocationCoordinate2D? {
        locationRepo.getUserLocation()
    }
    
    func getAddressString(_ location: CLLocationCoordinate2D?) {
        if let location = location {
            locationRepo.getUserLocationPlaceString(location: .init(latitude: location.latitude, longitude: location.longitude)) { [weak self] address in
                guard let self else { return }
                self.addressText = address.address
            }
        }
    }
    
    func getLocationFromString(_ string: String) {
        locationRepo.getLocation(forPlaceCalled: string) { [weak self] location in
            guard let self, let location else { return }
            self.setMapRegion(from: location)
        }
    }
    
    func setMapRegion(from location: CLLocationCoordinate2D) {
        mapCameraPosition = .region(.init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000))
    }
    
    
}
