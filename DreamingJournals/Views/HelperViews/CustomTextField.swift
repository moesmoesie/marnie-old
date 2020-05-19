//
//  CustomTextView.swift
//  DreamBook
//
//  Created by moesmoesie on 11/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct CustomTextField : View {
    @State var height : CGFloat = 0
    @Binding var text : String
    var focus : Bool
    let textColor : UIColor
    let backgroundColor : UIColor
    let placeholder : String
    let placeholderColor : Color

    let tintColor : UIColor
    let font : UIFont
    let onReturn : (UITextField) -> Bool
    
    init(text : Binding<String>, placeholder : String, focus : Bool = false, textColor : UIColor = .white,
         placeholderColor : Color = .white,
         backgroundColor : UIColor = .clear, tintColor : UIColor = .systemBlue, font : UIFont = UIFont.preferredFont(forTextStyle: .body), onReturn : @escaping (UITextField) -> Bool = {_ in true}) {
        self._text = text
        self.focus = focus
        self.placeholder = placeholder
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.font = font
        self.onReturn = onReturn
        self.placeholderColor = placeholderColor
    }
    
    var body: some View{
        GeometryReader{ geo in
            self.content(width: geo.size.width)
        }.frame(height : self.height)
    }
    
    private func content(width : CGFloat) -> some View{
        ZStack(alignment: .topLeading){
            if text.isEmpty{
                Text(placeholder).font(.body).foregroundColor(placeholderColor).opacity(0.3)
            }
            UICustomTextField(text: self.$text, width: width, height: self.$height, focus: focus, onReturn: onReturn, make: self.make)
        }
    }
    
    
    private func make(coordinator: UICustomTextField.Coordinator) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = coordinator
        textField.backgroundColor = self.backgroundColor
        textField.tintColor = self.tintColor
        textField.textColor = self.textColor
        textField.font = self.font
        textField.returnKeyType = .done
        textField.addTarget(coordinator,
            action: #selector(coordinator.textFieldDidChange),
            for: .editingChanged)
        
        return textField
    }
}


private struct UICustomTextField : UIViewRepresentable{
    @Binding var text : String
    let width : CGFloat
    @Binding var height : CGFloat
    var focus : Bool
    let onReturn : (UITextField) -> Bool
    @State var initialFocus : Bool = false

    
    let make: (Coordinator) -> UIViewType
    
    func makeUIView(context: Context) -> UITextField {
        make(context.coordinator)
    }

    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = self.text
        DispatchQueue.main.async {
            self.height = uiView.sizeThatFits(CGSize(width: self.width, height: .infinity)).height
        }
        
        if focus && !initialFocus{
            uiView.becomeFirstResponder()
            DispatchQueue.main.async {
                self.initialFocus = false
            }
        }
    }
    
    func makeCoordinator() -> UICustomTextField.Coordinator {
        return Coordinator($text,onReturn: onReturn)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate{
        @Binding var text : String
        let onReturn : (UITextField) -> Bool

        init(_ text : Binding<String>, onReturn : @escaping (UITextField) -> Bool) {
            self._text = text
            self.onReturn = onReturn
        }
        
        @objc func textFieldDidChange(_ textField: UITextField) {
            text = textField.text ?? ""
         }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            onReturn(textField)
        }
    }
}
