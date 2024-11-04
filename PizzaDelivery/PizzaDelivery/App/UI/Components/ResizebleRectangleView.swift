//
//  ResizebleRectangleView.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 10.10.2024.
//

import SwiftUI

struct ResizebleRectangleView<Content: View>: View {
    
    @ViewBuilder let content: Content
    var color: Color = Asset.Colors.backgroundSecondary
    var hPadding: CGFloat = 10
    var vPadding: CGFloat = 10
    
    var body: some View {
        content
            .padding(.horizontal, hPadding)
            .padding(.vertical, vPadding)
            .background(
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: .infinity).fill(color)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                }
                
            )
    }
}
