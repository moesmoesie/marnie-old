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
    let textColor : UIColor
    let backgroundColor : UIColor
    let placeholder : String
    let placeholderColor : Color
    let tintColor : UIColor
    let font : UIFont
    let maxCharacters : Int
    var autoFocus : Bool
    let onReturn : (UITextField) -> Bool
    let onChange : (UITextField) -> ()
    let placeholderFont : Font
    
    init(text : Binding<String>,
         placeholder : String,
         placeholderFont : Font = Font.primaryRegular,
         textColor : UIColor = .white,
         placeholderColor : Color = .white,
         backgroundColor : UIColor = .clear,
         tintColor : UIColor = .systemBlue,
         autoFocus : Bool = false,
         maxCharacters : Int = .max,
         font : UIFont = UIFont.preferredFont(forTextStyle: .body),
         onChange: @escaping (UITextField) -> () = {_ in },
         onReturn : @escaping (UITextField) -> Bool = {_ in true}) {
        self._text = text
        self.placeholder = placeholder
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.font = font
        self.onReturn = onReturn
        self.placeholderColor = placeholderColor
        self.maxCharacters = maxCharacters
        self.autoFocus = autoFocus
        self.placeholderFont = placeholderFont
        self.onChange = onChange
    }
    
    var body: some View{
        GeometryReader{ geo in
            self.content(width: geo.size.width)
        }.frame(height : self.height)
    }
    
    private func content(width : CGFloat) -> some View{
        ZStack(alignment: .topLeading){
            if text.isEmpty{
                Text(placeholder)
                    .font(placeholderFont)
                    .foregroundColor(placeholderColor)
            }
            UICustomTextField(
                text: self.$text,
                height: self.$height,
                autoFocus: self.autoFocus,
                width: width, onReturn:
                onReturn,
                onChange: self.onChange,
                make: self.make
            )
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
        coordinator.maxCharacters = self.maxCharacters
        textField.addTarget(coordinator,
            action: #selector(coordinator.textFieldDidChange),
            for: .editingChanged)
        
        return textField
    }
}

private struct UICustomTextField : UIViewRepresentable{
    @Binding var text : String
    @Binding var height : CGFloat
    let autoFocus : Bool

    let width : CGFloat
    let onReturn : (UITextField) -> Bool
    let onChange : (UITextField) -> ()

    let make: (Coordinator) -> UIViewType
    func makeUIView(context: Context) -> UITextField {
        make(context.coordinator)
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = self.text
        DispatchQueue.main.async {
            self.height = uiView.sizeThatFits(CGSize(width: self.width, height: .infinity)).height
            if self.autoFocus && !context.coordinator.didBecomeFirstResponder{
                uiView.becomeFirstResponder()
                context.coordinator.didBecomeFirstResponder = true
            }
        }
    }
    
    func makeCoordinator() -> UICustomTextField.Coordinator {
        return Coordinator($text,onChange: onChange, onReturn: onReturn)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate{
        @Binding var text : String
        var maxCharacters : Int = .max
        let onReturn : (UITextField) -> Bool
        let onChange : (UITextField) -> ()
        var didBecomeFirstResponder = false


        init(_ text : Binding<String>, onChange : @escaping (UITextField) -> () ,onReturn : @escaping (UITextField) -> Bool) {
            self._text = text
            self.onReturn = onReturn
            self.onChange = onChange
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= self.maxCharacters
        }
        
        @objc func textFieldDidChange(_ textField: UITextField) {
            text = textField.text ?? ""
            onChange(textField)
         }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            onReturn(textField)
        }
    }
}
