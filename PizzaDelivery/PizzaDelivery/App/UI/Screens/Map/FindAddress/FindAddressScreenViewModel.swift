//
//  FindAddressScreenViewModel.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 11/10/24.
//

import SwiftUI
import Swinject
import MapKit

class FindAddressScreenViewModel: NSObject, ObservableObject {
    
    @Published var address: String = ""  {
        didSet {
            handleSearchFragment(address)
        }
    }
    @Published var locations: [Address] = []
    @Published var status: SearchStatus = .idle
    var completer: MKLocalSearchCompleter
    
    private let locationRepo: LocationRepository
    
    init(dependencies: Resolver) {
        locationRepo = dependencies.resolve(LocationRepository.self)!
        
        completer = MKLocalSearchCompleter()
        
        super.init()
        
        completer.delegate = self
        completer.pointOfInterestFilter = .includingAll
        completer.region = MKCoordinateRegion(.world)
        completer.resultTypes = [.address, .query, .pointOfInterest]
    }
    
    private func handleSearchFragment(_ fragment: String) {
        self.status = .searching
        
        if !fragment.isEmpty {
            self.completer.queryFragment = fragment
        } else {
            self.status = .idle
            self.locations = []
        }
    }
        
}

extension FindAddressScreenViewModel: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.locations = completer.results.map({ result in
            Address(city: result.subtitle, address: result.title)
        })
        
        self.status = .result
    }
}

enum SearchStatus: Equatable {
    case idle
    case searching
    case error (String)
    case result
}
