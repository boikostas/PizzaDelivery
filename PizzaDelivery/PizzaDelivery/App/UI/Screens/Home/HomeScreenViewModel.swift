//
//  HomeScreenViewModel.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 11/1/24.
//

import Foundation
import Swinject

class HomeScreenViewModel: ObservableObject {
    
    let mapScreenViewModel: MapScreenViewModel?
    
    init(dependencies: Resolver) {
        
        self.mapScreenViewModel = MapScreenViewModel(dependencies: dependencies)
    }
}
