//
//  User.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 09.10.2024.
//

import Foundation

struct User: Codable {
    let id: String
    let deliveryAddress: UserLocation?
    let cart: [String]
}

struct UserLocation: Codable {
    let latitude: Double
    let longitude: Double
}
