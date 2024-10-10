//
//  AppViewModel.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 09.10.2024.
//

import Foundation
import Combine
import Swinject
import FirebaseAuth

class AppViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isLoggedIn: Bool = false
    @Published var uid: String = "no id"
    
    
    
    private weak var appDelegate: AppDelegate?
    let dependencies: Resolver
    
     let authRepo: AuthRepository
    private let firebaseRepo: FirebaseRepository
    
    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
        dependencies = appDelegate.dependencyContainer
        authRepo = dependencies.resolve(AuthRepository.self)!
        firebaseRepo = dependencies.resolve(FirebaseRepository.self)!
        
        listenForAuth()
    }
    
    private func listenForAuth() {
        authRepo.isAuthenticated
            .sink { [weak self] isAuthenticated in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoggedIn = !isAuthenticated
                    self.uid = Auth.auth().currentUser?.uid ?? ""
                }
                
                if !isAuthenticated {
                    guard let user = firebaseRepo.signInAnonymously() else { return }
                }
            }
            .store(in: &cancellables)
    }
    
    private func saveUserToDB(user: User) async {
        do {
            try await firebaseRepo.saveUserToDB(user: user)
        } catch {
            
        }
    }
}