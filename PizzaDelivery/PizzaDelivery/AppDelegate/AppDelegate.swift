//
//  AppDelegate.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 09.10.2024.
//

import SwiftUI
import FirebaseCore
import Swinject

class AppDelegate: NSObject, UIApplicationDelegate {
    public var dependencyContainer: Container!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        dependencyContainer = createDependencies()
        return true
    }
}
