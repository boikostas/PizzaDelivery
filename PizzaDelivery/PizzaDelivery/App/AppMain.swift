//
//  AppMain.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 09.10.2024.
//

import SwiftUI

struct AppMain: View {
    
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        Text(viewModel.uid)
            .onTapGesture {
                viewModel.authRepo.logout()
            }
            .sheet(isPresented: $viewModel.isLoggedIn) {
                Text("Not login")
                    .onTapGesture {
                        viewModel.authRepo.success()
                    }
            }
    }
        
}
