//
//  HomeScreenViewModel.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 11/1/24.
//

import Foundation
import Swinject

class HomeScreenViewModel: ObservableObject {
    
//    var coordinator: Coordinator
    
    let mapScreenViewModel: MapScreenViewModel?
    
    init(dependencies: Resolver) {
//        self.coordinator = coordinator
        
        self.mapScreenViewModel = MapScreenViewModel(dependencies: dependencies)
    }
}
