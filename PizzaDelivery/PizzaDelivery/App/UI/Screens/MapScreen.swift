//
//  MapScreen.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 10.10.2024.
//

import SwiftUI
import MapKit

struct MapScreen: View {
    
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
                
                deliveryLogo(geometry: geometry)
                
                Rectangle().fill(Asset.Colors.white)
                    .opacity(keyboardHeight == 0 ? 0 : 0.5)
                
                VStack {
                    Spacer()
                    addressSection
                        .keyboardHeight($keyboardHeight)
                        .animation(.easeInOut(duration: 0.22), value: keyboardHeight)
                        .offset(y: keyboardHeight == 0 ? 0 : -keyboardHeight + 40)
                }
            }
        }
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Text("Done")
                        .fontWeight(.semibold)
                        .foregroundStyle(Asset.Colors.orange)
                        .onTapGesture {
                            focusedField = nil
                        }
                }
            }
        }
    }
    
    private var closeButton: some View {
        ZStack {
            Circle().fill(Asset.Colors.backgroundPrimary)
                .frame(width: 45, height: 45)
            Image(systemName: "xmark")
                .foregroundStyle(Asset.Colors.foregroundPrimary)
                .font(.title3)
        }
    }
    
    private func deliveryLogo(geometry: GeometryProxy) -> some View {
        VStack {
            ZStack {
                
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: .infinity)
                            .foregroundStyle(Asset.Colors.backgroundPrimary)
                            .frame(width: geometry.size.width / 2.5, height: 45)
                        RoundedRectangle(cornerRadius: .infinity)
                            .foregroundStyle(Asset.Colors.orange)
                            .frame(width: geometry.size.width / 2.5 - 5, height: 45 - 5)
                        HStack {
                            Image(systemName: "figure.hiking")
                            Text("Delivery")
                        }
                        .fontWeight(.medium)
                        .foregroundStyle(Asset.Colors.white)
                    }
                }
                
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
                .frame(width: 50, height: 50)
            Image(systemName: "location.fill")
                .foregroundStyle(Asset.Colors.foregroundPrimary)
                .font(.title3)
        }
    }
    
    private var addressSection: some View {
            
            VStack(alignment: .leading, spacing: 15) {
                ResizebleRectangleView(text: "🇺🇦 Ukraine")
                
                VStack(spacing: 10) {
                    TextFieldView(text: $addreessText, placeholder: "Address")
                        .focused($focusedField, equals: .address)
                        .onSubmit {
                            focusedField = .locationName
                            
                        }
                    TextFieldView(text: $locationNameText, placeholder: "Location name")
                        .focused($focusedField, equals: .locationName)
                        .onSubmit {
                            focusedField = .floor
                        }
                    
                    HStack(spacing: 10) {
                        TextFieldView(text: $floorText, placeholder: "Floor")
                            .focused($focusedField, equals: .floor)
                            .onSubmit {
                                focusedField = .apartment
                            }
                        TextFieldView(text: $apartmentText, placeholder: "Apartment")
                            .focused($focusedField, equals: .apartment)
                            .onSubmit {
                                focusedField = .comment
                            }
                    }
                    
                    TextFieldView(text: $commentText, placeholder: "Comment")
                        .focused($focusedField, equals: .comment)
                        .onSubmit {
                            focusedField = nil
                        }
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: .infinity)
                        .fill(Asset.Colors.orange)
                        .frame(height: 55)
                    Text("Save")
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

#Preview {
    MapScreen()
}
