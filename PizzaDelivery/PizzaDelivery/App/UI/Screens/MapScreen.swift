//
//  MapScreen.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 10.10.2024.
//

import SwiftUI
import MapKit

struct MapScreen: View {
    
    @ObservedObject var viewModel: MapScreenViewModel
    
    @EnvironmentObject private var coordinator: Coordinator
    
    @FocusState var focusedField: Field?
    
    @State private var keyboardHeight: CGFloat = 0
    @State private var addressSectionHeight: CGFloat = 0
    
    enum Field: Hashable {
        case address
        case locationName
        case floor
        case apartment
        case comment
    }
    
    @State var addreessText: String = ""
    @State var locationNameText: String = ""
    @State var floorText: String = ""
    @State var apartmentText: String = ""
    @State var commentText: String = ""
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack {
                    ZStack(alignment: .bottomTrailing) {
                        Map()
                            .offset(y: 30)
                        showCurrentLocationButton
                            .padding()
                    }
                    Rectangle().fill(.clear)
                        .frame(height: addressSectionHeight)
                }
                
                deliveryLogo
                
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
            focusedField = .address
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
            Image(systemName: "location.fill")
                .foregroundStyle(Asset.Colors.foregroundPrimary)
                .font(.system(size: 18))
        }
    }
    
    private var addressSection: some View {
            
            VStack(alignment: .leading, spacing: 15) {
                ResizebleRectangleView {
                    Text("🇺🇦 Ukraine")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                
                VStack(spacing: 10) {
                    TextFieldView(text: $addreessText, placeholder: "Address")
                        .focused($focusedField, equals: .address)
                    
                    TextFieldView(text: $locationNameText, placeholder: "Location name")
                        .focused($focusedField, equals: .locationName)
                    
                    HStack(spacing: 10) {
                        TextFieldView(text: $floorText, placeholder: "Floor")
                            .focused($focusedField, equals: .floor)
                        
                        TextFieldView(text: $apartmentText, placeholder: "Apartment")
                            .focused($focusedField, equals: .apartment)
                    }
                    
                    TextFieldView(text: $commentText, placeholder: "Comment")
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
}

struct KeyboardProvider: ViewModifier {
    
    var keyboardHeight: Binding<CGFloat>
    
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification),
                       perform: { notification in
                guard let userInfo = notification.userInfo,
                      let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                                                            
                self.keyboardHeight.wrappedValue = keyboardRect.height
                
            }).onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification),
                         perform: { _ in
                self.keyboardHeight.wrappedValue = 0
            })
    }
}


public extension View {
    func keyboardHeight(_ state: Binding<CGFloat>) -> some View {
        self.modifier(KeyboardProvider(keyboardHeight: state))
    }
}

//#Preview {
//    MapScreen()
//}
