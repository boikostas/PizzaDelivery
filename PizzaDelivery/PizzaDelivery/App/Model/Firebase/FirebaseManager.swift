//
//  FirebaseManager.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 09.10.2024.
//

import FirebaseAuth
import FirebaseFirestore

final class FirebaseManager {
    
    let auth: Auth
    let firestore: Firestore
    
    init() {
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
    }
    
    func signInAnonymously() -> User? {
        
        var user: User?
        
        auth.signInAnonymously { authResult, error in
            if let error {
                print("Can't login anonymously: \(error.localizedDescription)")
            }
            
            if let authResult {
                print("Anonymous user logged in: \(authResult.user.uid)")
            }
            
            guard let authUser = authResult?.user else { return }
            
            user = User(id: authUser.uid, deliveryAddress: UserLocation(latitude: 12.444, longitude: 3.555), cart: ["pizza", "pasta"])
            
        }
        
        return user
    }
    
    func saveUserToDB(user: User?) async throws {
        guard let user = user else { return }
        try firestore.collection("users").document(user.id).setData(from: user)
    }
}
