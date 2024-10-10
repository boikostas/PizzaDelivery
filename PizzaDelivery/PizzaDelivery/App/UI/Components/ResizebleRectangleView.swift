//
//  ResizebleRectangleView.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 10.10.2024.
//

import SwiftUI

struct ResizebleRectangleView: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .font(.footnote)
            .padding(10)
            .background(
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: .infinity).fill(Asset.Colors.backgroundSecondary)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                }
                
            )
    }
}
