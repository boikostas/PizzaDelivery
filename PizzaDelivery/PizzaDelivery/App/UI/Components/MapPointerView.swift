//
//  MapPointerView.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 11/5/24.
//

import SwiftUI

struct MapPointerView: View {
    
    @State private var animate: Bool = false
    @State private var animateCircle: Bool = false
    
    var body: some View {
        ZStack {
            Circle().fill(.clear)
                .stroke(Asset.Colors.orange, lineWidth: animateCircle ? 1 : 5)
                .offset(y: 30)
                .frame(width: animateCircle ? 40 : 10, height: animateCircle ? 40 : 10)
                .opacity(animateCircle ? 1 : 0)
            ZStack {
                RoundedRectangle(cornerRadius: .infinity).fill(Asset.Colors.black)
                    .frame(width: 4, height: 25)
                    .offset(y: 20)
                Circle().fill(Asset.Colors.orange)
                    .frame(width: 30, height: 30)
            }
            .offset(y: animate ? -20 : 0)
        }
        .onTapGesture {
            startAnimation()
        }
    }
    
    func startAnimation() {
        withAnimation(.easeInOut) {
            animate.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut) {
                animate.toggle()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            withAnimation(.easeInOut(duration: 0.3)) {
                animateCircle.toggle()
            } completion: {
                animateCircle = false
            }
        }
    }
}

#Preview {
    MapPointerView()
}
