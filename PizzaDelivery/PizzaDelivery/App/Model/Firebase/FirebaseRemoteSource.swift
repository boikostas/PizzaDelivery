//
//  FirebaseRemoteSource.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 09.10.2024.
//

import FirebaseAuth

protocol FirebaseRemoteSource {
    func signInAnonymously() -> User?
    func saveUserToDB(user: User?) async throws
}

class FirebaseRemoteSourceImpl: FirebaseRemoteSource {
    
    private var firebaseManager: FirebaseManager {
        FirebaseManager()
    }
    
    func signInAnonymously() -> User? {
        firebaseManager.signInAnonymously()
    }
    
    func saveUserToDB(user: User?) async throws {
        try await firebaseManager.saveUserToDB(user: user)
    }
}
