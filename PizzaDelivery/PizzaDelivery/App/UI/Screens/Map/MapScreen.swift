//
//  MapScreen.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 10.10.2024.
//

import SwiftUI
import MapKit
import SwiftFlags

struct MapScreen: View {
    
    @ObservedObject var viewModel: MapScreenViewModel
    
    @EnvironmentObject private var coordinator: Coordinator
    
    @FocusState private var focusedField: Field?
    
    @State private var keyboardHeight: CGFloat = 0
    @State private var addressSectionHeight: CGFloat = 0
    
    @State private var animatePointer: Bool = false
    @State private var animatePointerCircle: Bool = false
    
    @State private var isAlertShown: Bool = false
    
    @State private var isUserLocationEqualsMapCameraCenter: Bool = false
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack {
                    ZStack(alignment: .bottomTrailing) {
                        ZStack {
                            Map(position: $viewModel.mapCameraPosition) {
                                UserAnnotation()
                            }
                            .offset(y: 30)
                            pointer
                        }
                        showCurrentLocationButton
                            .padding()
                        
                        deliveryLogo
                    }
                    .disabled(keyboardHeight != 0)
                    
                    Rectangle().fill(.clear)
                        .frame(height: addressSectionHeight)
                }
                
                
                Rectangle().fill(Asset.Colors.white)
                    .opacity(keyboardHeight == 0 ? 0 : 0.5)
                
                VStack {
                    Spacer()
                    addressSection
                        .keyboardHeight($keyboardHeight)
                        .animation(.easeOut(duration: 0.27), value: keyboardHeight)
                        .padding(.bottom, keyboardHeight == 0 ? 0 : keyboardHeight - 40)
                }
            }
        }
        .ignoresSafeArea()
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                HStack {
                    Button {
                        focusedField = nil
                    } label: {
                        Text("Done")
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 10) {
                        Button {
                            goToPreviousTextField()
                        } label: {
                            Image(systemName: "chevron.up")
                        }
                        .disabled(focusedField == .address)
                        
                        Button {
                            goToNextTextField()
                        } label: {
                            Image(systemName: "chevron.down")
                        }
                        .disabled(focusedField == .comment)
                    }
                }
                .fontWeight(.semibold)
                .tint(Asset.Colors.orange)
            }
        }
        .onAppear {
            viewModel.getUserLoction()
        }
        .onMapCameraChange { mapCameraUpdateContext in
            pointer.startAnimation()
            viewModel.getAddressString(mapCameraUpdateContext.camera.centerCoordinate)
            if let userCoordinates = viewModel.getUserCoordinates() {
                isUserLocationEqualsMapCameraCenter = areCoordinatesEqual(coord1: userCoordinates, coord2: mapCameraUpdateContext.camera.centerCoordinate)
            }
        }
        .alert("Can't find you on map", isPresented: $isAlertShown) {
            Button("Go to Settings", role: .cancel) {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            Button("Close") {
                isAlertShown = false
            }
        } message: {
            Text("Allow PizzaDelivery to access your location in Settings")
        }
        
    }
    
    private func areCoordinatesEqual(coord1: CLLocationCoordinate2D, coord2: CLLocationCoordinate2D, threshold: Double = 0.0001) -> Bool {
            let latDiff = abs(coord1.latitude - coord2.latitude)
            let lonDiff = abs(coord1.longitude - coord2.longitude)
            return latDiff < threshold && lonDiff < threshold
        }
    
    private var pointer: MapPointerView {
        MapPointerView(animate: $animatePointer, animateCircle: $animatePointerCircle)
    }
    
    private func goToNextTextField() {
        switch focusedField {
        case .address:
            focusedField = .locationName
        case .locationName:
            focusedField = .floor
        case .floor:
            focusedField = .apartment
        case .apartment:
            focusedField = .comment
        case .comment:
            break
        case .none:
            break
        }
    }
    
    private func goToPreviousTextField() {
        switch focusedField {
        case .address:
            break
        case .locationName:
            presentFindAddressScreen()
        case .floor:
            focusedField = .locationName
        case .apartment:
            focusedField = .floor
        case .comment:
            focusedField = .apartment
        case .none:
            break
        }
    }
    
    private var closeButton: some View {
        ZStack {
            Circle().fill(Asset.Colors.backgroundPrimary)
                .frame(width: 45, height: 45)
            Image(systemName: "xmark")
                .foregroundStyle(Asset.Colors.foregroundPrimary)
                .font(.system(size: 18))
        }
        .onTapGesture {
            coordinator.pop()
        }
    }
    
    private var deliveryLogo: some View {
        VStack {
            ZStack {
                
                ResizebleRectangleView(content: {
                    ResizebleRectangleView(content: {
                        HStack {
                            Image(systemName: "figure.hiking")
                            Text("Delivery")
                        }
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundStyle(Asset.Colors.white)
                    }, color: Asset.Colors.orange, hPadding: 20, vPadding: 8)
                }, color: Asset.Colors.backgroundPrimary, hPadding: 2.5, vPadding: 2.5)
                
                HStack {
                    closeButton
                    Spacer()
                }
            }
            Spacer()
        }
        .padding(.vertical, 70)
        .padding(.horizontal)
    }
    
    private var showCurrentLocationButton: some View {
        ZStack {
            Circle().fill(Asset.Colors.backgroundPrimary)
                .frame(width: 45, height: 45)
            Image(systemName: isUserLocationEqualsMapCameraCenter ? "location.fill" : "location")
                .foregroundStyle(Asset.Colors.orange)
                .font(.system(size: 18))
        }
        .onTapGesture {
            withAnimation {
                if viewModel.isAuthorizationDenied() {
                    isAlertShown = true
                } else {
                    isAlertShown = false
                    viewModel.getUserLoction()
                }
            }
        }
    }
    
    private var addressSection: some View {
            
            VStack(alignment: .leading, spacing: 15) {
                if let country = viewModel.address.country {
                    ResizebleRectangleView {
                        Text("\(SwiftFlags.flag(for: country) ?? "") \(country)")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                }
                
                VStack(spacing: 10) {
                    TextFieldView(text: $viewModel.address.address, placeholder: "Address")
                        .disabled(true)
                        .onTapGesture {
                            presentFindAddressScreen()
                        }
                    
                    TextFieldView(text: $viewModel.locationNameText, placeholder: "Location name")
                        .focused($focusedField, equals: .locationName)
                    
                    HStack(spacing: 10) {
                        TextFieldView(text: $viewModel.floorText, placeholder: "Floor")
                            .focused($focusedField, equals: .floor)
                        
                        TextFieldView(text: $viewModel.apartmentText, placeholder: "Apartment")
                            .focused($focusedField, equals: .apartment)
                    }
                    
                    TextFieldView(text: $viewModel.commentText, placeholder: "Comment")
                        .focused($focusedField, equals: .comment)
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: .infinity)
                        .fill(Asset.Colors.orange)
                        .frame(height: 55)
                    Text("Order here")
                        .foregroundStyle(Asset.Colors.white)
                        .fontWeight(.semibold)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 50)
            .padding(.top, 15)
            .background(
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Asset.Colors.backgroundPrimary)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .onAppear {
                            addressSectionHeight = geometry.size.height
                        }
                }
            )
    }
    
    private func presentFindAddressScreen() {
        if let findAddressScreenViewModel = viewModel.findAddressScreenViewModel {
            focusedField = nil
            findAddressScreenViewModel.address = viewModel.address.address
            coordinator.present(sheet: .findAddressScreen(findAddressScreenViewModel) { address in
                withAnimation {
                    self.viewModel.getLocationFromString(address.address + ", \(address.city ?? "")")
                }
            })
        }
    }
}
