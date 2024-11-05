//
//  HomeScreen.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 11/1/24.
//

import SwiftUI

struct HomeScreen: View {
    
    @ObservedObject var viewModel: HomeScreenViewModel
    
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        ZStack {
            Text("open map")
                .onTapGesture {
                    if let mapScreenViewModel = viewModel.mapScreenViewModel {
                        coordinator.push(.mapScreen(mapScreenViewModel))
                    }
                }
        }
        
    }
}

#Preview {
//    HomeScreen()
}
