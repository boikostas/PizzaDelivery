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
    
    @Published var addreessText: String = ""
    @Published var locationNameText: String = ""
    @Published var floorText: String = ""
    @Published var apartmentText: String = ""
    @Published var commentText: String = ""
    
    private let locationRepo: LocationRepository
    
    init(dependencies: Resolver) {
        locationRepo = dependencies.resolve(LocationRepository.self)!
    }
    
    func requestAccessToLocation() {
        locationRepo.requestAccessToLocation()
    }
    
    func getUserLoction() {
        if let location = locationRepo.getUserLocation() {
            mapCameraPosition = .region(.init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000))
            getAddressString(location)
        }
    }
    
    func getAddressString(_ location: CLLocationCoordinate2D?) {
        if let location = location {
            locationRepo.getUserLocationPlaceString(location: .init(latitude: location.latitude, longitude: location.longitude)) { address in
                self.addreessText = address.address
            }
        }
    }
    
    
}
