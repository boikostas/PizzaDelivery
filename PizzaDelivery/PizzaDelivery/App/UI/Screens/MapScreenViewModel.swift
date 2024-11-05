//
//  MapScreenViewModel.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 11/1/24.
//

import Foundation
import Swinject

class MapScreenViewModel: ObservableObject {
    
    @Published var addreessText: String = ""
    @Published var locationNameText: String = ""
    @Published var floorText: String = ""
    @Published var apartmentText: String = ""
    @Published var commentText: String = ""
    
    init(dependencies: Resolver) {
    }
}
