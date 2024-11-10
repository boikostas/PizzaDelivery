//
//  View+Extension.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 11/6/24.
//

import SwiftUI

public extension View {
    func keyboardHeight(_ state: Binding<CGFloat>) -> some View {
        self.modifier(KeyboardProvider(keyboardHeight: state))
    }
}
