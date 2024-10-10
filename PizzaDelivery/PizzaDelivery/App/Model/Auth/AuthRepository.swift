//
//  AuthRepository.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 09.10.2024.
//

import FirebaseAuth
import Combine
import Swinject

protocol AuthRepository {
    var isAuthenticated: AnyPublisher<Bool, Never> { get }
    func success()
    func logout()
}

class AuthRepositoryImpl: AuthRepository {
    
    var isAuthenticated: AnyPublisher<Bool, Never> {
        $authenticatedPubliser.eraseToAnyPublisher()
    }
    
    @Published private var authenticatedPubliser = Auth.auth().currentUser != nil
    
    init(dependencies: Resolver) {}
    
    func success() {
        authenticatedPubliser = true
    }
    
    func logout() {
        authenticatedPubliser = false
    }
}
