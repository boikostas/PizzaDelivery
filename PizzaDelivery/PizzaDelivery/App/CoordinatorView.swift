//
//  CoordinatorView.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 11/1/24.
//

import SwiftUI

struct CoordinatorView: View {
    
    @ObservedObject var viewModel: AppViewModel
    
    @StateObject private var coordinator = Coordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            if let homeScreenViewModel = viewModel.homeScreenViewModel {
                coordinator.build(screen: .homeScreen(homeScreenViewModel))
                    .navigationDestination(for: Screen.self) { screen in
                        coordinator.build(screen: screen)
                    }
                    .sheet(item: $coordinator.sheet) { sheet in
                        coordinator.build(sheet: sheet)
                    }
                    .fullScreenCover(item: $coordinator.fullScreenCover) { cover in
                        coordinator.build(fullScreenCover: cover)
                    }
            }
        }
        .environmentObject(coordinator)
    }
}
