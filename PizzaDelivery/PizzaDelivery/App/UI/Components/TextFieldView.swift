//
//  TextFieldView.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 10.10.2024.
//

import SwiftUI

struct TextFieldView: View {
    
    @Binding var text: String
    @FocusState private var isTextFieldFocused: Bool
    var placeholder: String
    
    init(text: Binding<String>, placeholder: String) {
        _text = text
        self.placeholder = placeholder
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 0.5)
                .fill(Asset.Colors.textSecondary)
                .frame(height: 55)
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(placeholder)
                        .foregroundStyle(Asset.Colors.textSecondary)
                        .font(.system(size: isTextFieldFocused || !text.isEmpty ? 14 : 16))
                        .offset(y: isTextFieldFocused || !text.isEmpty ? 0 : 10)
                    TextField("", text: $text)
                        .focused($isTextFieldFocused)
                        .tint(Asset.Colors.orange)
                }
                
                ZStack {
                    Circle().fill(Asset.Colors.grey)
                        .frame(width: 15, height: 15)
                    Image(systemName: "xmark")
                        .fontWeight(.semibold)
                        .font(.system(size: 8))
                        .foregroundStyle(Asset.Colors.foregroundSecondary)
                }
                .onTapGesture {
                    text = ""
                }
                .opacity(isTextFieldFocused ? 1 : 0)
            }
            .padding(.horizontal)
        }
        .animation(.none, value: isTextFieldFocused)
        .onTapGesture {
            isTextFieldFocused = true
        }
    }
}

struct TextFieldViewPreview: View {
    
    @State var text = ""
    @State var text1 = ""
    
    var body: some View {
        VStack {
            TextFieldView(text: $text, placeholder: "Address")
            TextFieldView(text: $text1, placeholder: "Comment")
        }
        .padding()
    }
}

#Preview {
    TextFieldViewPreview()
}
