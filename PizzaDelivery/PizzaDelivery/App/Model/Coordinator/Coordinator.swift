//
//  Coordinator.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 11/1/24.
//

import SwiftUI

enum Screen: Hashable, Identifiable {
    
    case homeScreen(HomeScreenViewModel), mapScreen(MapScreenViewModel)
    
    static func == (lhs: Screen, rhs: Screen) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String {
        UUID().uuidString
    }
        
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
    }
}

enum Sheet: Hashable, Identifiable {
    case findAddressScreen(FindAddressScreenViewModel, ((AddressSearchViewData) -> Void)?)
    
    static func == (lhs: Sheet, rhs: Sheet) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String {
        UUID().uuidString
    }
        
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
    }
}

enum FullScreenCover: Hashable, Identifiable {
    case mapScreen(MapScreenViewModel)
    
    static func == (lhs: FullScreenCover, rhs: FullScreenCover) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String {
        UUID().uuidString
    }
        
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
    }
}


class Coordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func present(sheet: Sheet) {
        self.sheet = sheet
    }
    
    func present(fullScreenCover: FullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    func dismissFullScreenCover() {
        self.fullScreenCover = nil
    }
    
    @ViewBuilder
    func build(screen: Screen) -> some View {
        switch screen {
        case .homeScreen(let homeScreenViewModel):
            HomeScreen(viewModel: homeScreenViewModel)
        case .mapScreen(let mapScreenViewModel):
            MapScreen(viewModel: mapScreenViewModel)
                .toolbarVisibility(.hidden, for: .navigationBar)
        }
    }
    
    @ViewBuilder
    func build(sheet: Sheet) -> some View {
        switch sheet {
        case .findAddressScreen(let findAdressScreenViewModel, let addressSelectedAction):
            NavigationStack {
                FindAddressScreen(viewModel: findAdressScreenViewModel, addressSelectedAction: addressSelectedAction)
            }
        }
    }
    
    @ViewBuilder
    func build(fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .mapScreen(let mapScreenViewModel):
            NavigationStack {
                MapScreen(viewModel: mapScreenViewModel)
                    .toolbarVisibility(.hidden, for: .navigationBar)
            }
            
        }
    }
}
