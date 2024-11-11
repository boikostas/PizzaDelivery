//
//  FindAddressScreen.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 11/10/24.
//

import SwiftUI

struct FindAddressScreen: View {
    
    @ObservedObject var viewModel: FindAddressScreenViewModel
    @EnvironmentObject private var coordinator: Coordinator
    
    @FocusState private var focusedField: Field?
    
    let addressSelectedAction: ((AddressSearchViewData) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            TextFieldView(text: $viewModel.address, placeholder: "Street")
                .focused($focusedField, equals: .address)
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(viewModel.locations) { location in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(location.address)
                                    .foregroundStyle(Asset.Colors.textPrimary)
                                if let city = location.city {
                                    Text(city)
                                        .foregroundStyle(Asset.Colors.textSecondary)
                                }
                            }
                            Spacer()
                        }
                        .onTapGesture {
                            addressSelectedAction?(location)
                            coordinator.dismissSheet()
                        }
                    }
                }
            }
            .padding(.top)
        }
        .padding([.horizontal, .vertical])
        .background(Asset.Colors.backgroundPrimary)
        .navigationBarTitle("Delivery address")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button {
                    coordinator.dismissSheet()
                } label: {
                    Text("Close")
                        .foregroundStyle(Asset.Colors.orange)
                }
            }
        }
        .onAppear {
            focusedField = .address
        }
    }
}
