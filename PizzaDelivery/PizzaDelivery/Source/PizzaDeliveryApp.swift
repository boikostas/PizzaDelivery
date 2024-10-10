//
//  PizzaDeliveryApp.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 09.10.2024.
//

import SwiftUI

@main
struct PizzaDeliveryApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
//            AppMain(viewModel: AppViewModel(appDelegate: appDelegate))
            MapScreen()
        }
    }
}
