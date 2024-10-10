//
//  FirebaseRepository.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 09.10.2024.
//

import Swinject
import FirebaseAuth

protocol FirebaseRepository {
    func signInAnonymously() -> User?
    func saveUserToDB(user: User?) async throws
}

class FirebaseRepositoryImpl: FirebaseRepository {
    
    private var remoteSource: FirebaseRemoteSource
    
    init(dependencies: Resolver) {
        remoteSource = dependencies.resolve(FirebaseRemoteSource.self)!
    }
    
    func signInAnonymously() -> User? {
        remoteSource.signInAnonymously()
    }
    
    func saveUserToDB(user: User?) async throws {
        try await remoteSource.saveUserToDB(user: user)
    }
}
