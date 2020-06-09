//
//  CustomTextView.swift
//  DreamBook
//
//  Created by moesmoesie on 11/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct CustomTextField : View {
    @State private var height : CGFloat = 0
    @Binding var text : String
    var font : UIFont = UIFont.primaryRegular
    var textColor : UIColor = .main1
    var tintColor : UIColor = .accent1
    var backgroundColor : UIColor = .clear
    var placeholder : String = "placeholder"
    var placeholderColor : Color = .main2
    var placeholderFont : Font = .primaryRegular
    var maxCharacters : Int = .max
    var autocorrect : Bool = true
    var autoFocus : Bool = false
    var autoFocusDelay : Double = 0
    var returnKeyType : UIReturnKeyType = .done
    var onReturn : (UITextField) -> Bool = {_ in true}
    var onChange : (UITextField) -> () = {_ in}
    
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
                make: { coordinator in
                    let textField = UITextField(frame: .zero)
                    textField.delegate = coordinator
                    textField.backgroundColor = self.backgroundColor
                    textField.tintColor = self.tintColor
                    textField.textColor = self.textColor
                    textField.font = self.font
                    textField.autocorrectionType = self.autocorrect ? .default : .no
                    textField.returnKeyType = self.returnKeyType
                    coordinator.maxCharacters = self.maxCharacters
                    coordinator.text = self.$text
                    coordinator.onReturn = self.onReturn
                    coordinator.onChange = self.onChange
                    
                    textField.addTarget(coordinator,
                                        action: #selector(coordinator.textFieldDidChange),
                                        for: .editingChanged)
                    
                    return textField
                },
     
                update: { (uiView, coordinator)  in
                    uiView.text = self.text
                    let newHeight = uiView.sizeThatFits(CGSize(width: width, height: .infinity)).height
                    if self.height != newHeight{
                        DispatchQueue.main.async {
                            self.height = newHeight
                        }
                    }
                    
                    if self.autoFocus == false{
                        coordinator.didBecomeFirstResponder = false
                    }
                    
                    if self.autoFocus && !coordinator.didBecomeFirstResponder{
                        if self.autoFocusDelay > 0{
                            DispatchQueue.main.asyncAfter(deadline: .now() + self.autoFocusDelay) {
                                uiView.becomeFirstResponder()
                                coordinator.didBecomeFirstResponder = true
                            }
                        }else{
                            uiView.becomeFirstResponder()
                            coordinator.didBecomeFirstResponder = true
                        }
                    }
            })
        }
    }
}

private struct UICustomTextField : UIViewRepresentable{
    let make: (Coordinator) -> UIViewType
    let update: (UITextField, Coordinator) -> ()

    func makeUIView(context: Context) -> UITextField {
        make(context.coordinator)
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        update(uiView,context.coordinator)
    }
    
    func makeCoordinator() -> UICustomTextField.Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject, UITextFieldDelegate{
        var text : Binding<String>? = nil
        var maxCharacters : Int = .max
        var onReturn : (UITextField) -> Bool = {_ in true}
        var onChange : (UITextField) -> () = {_ in}
        var didBecomeFirstResponder = false
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= self.maxCharacters
        }
        
        @objc func textFieldDidChange(_ textField: UITextField) {
            self.text?.wrappedValue = textField.text ?? ""
            onChange(textField)
         }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            onReturn(textField)
        }
    }
}
