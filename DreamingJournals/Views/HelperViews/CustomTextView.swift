//
//  CustomTextView.swift
//  DreamBook
//
//  Created by moesmoesie on 11/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct CustomTextView : View {
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
    var autoCorrect : Bool = true
    var autoFocus : Bool = false
    var autoFocusDelay : Double = 0
    var returnKeyType : UIReturnKeyType = .default
    var bottomExtraClickableAreaHeight : CGFloat = 0
    var onReturn : (UITextView) -> Bool = {_ in true}
    var onChange : (UITextView) -> () = {_ in}
    
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
            
            UICustomTextView(
                make: { coordinator in
                    let textView = UITextView(frame: .zero)
                    textView.delegate = coordinator
                    textView.backgroundColor = self.backgroundColor
                    textView.tintColor = self.tintColor
                    textView.textColor = self.textColor
                    textView.font = self.font
                    textView.textContainerInset = .zero
                    textView.textContainer.lineFragmentPadding = 0
                    textView.returnKeyType = self.returnKeyType
                    textView.autocorrectionType = self.autoCorrect ? .default : .no
                    coordinator.text = self.$text
                    coordinator.maxCharacters = self.maxCharacters
                    coordinator.onReturn = self.onReturn
                    coordinator.onChange = self.onChange
                    return textView
            },
                update: { uiView, coordinator in
                    uiView.text = self.text
                    let newHeight = uiView.sizeThatFits(CGSize(width: width, height: .infinity)).height + self.bottomExtraClickableAreaHeight
                    
                    if self.height != newHeight{
                        DispatchQueue.main.async {
                            self.height = newHeight
                        }
                    }
                    
                    if self.autoFocus && !coordinator.didBecomeFirstResponder{
                        coordinator.didBecomeFirstResponder = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + self.autoFocusDelay) {
                            uiView.becomeFirstResponder()
                        }
                    }
                })
            }
        }
}


private struct UICustomTextView : UIViewRepresentable{
    let make: (Coordinator) -> UIViewType
    let update: (UITextView, Coordinator) -> ()
    
    func makeUIView(context: Context) -> UITextView {
        make(context.coordinator)
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        update(uiView, context.coordinator)
    }
    
    func makeCoordinator() -> UICustomTextView.Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject, UITextViewDelegate{
        var text : Binding<String>? = nil
        var maxCharacters : Int = .max
        var onReturn : (UITextView) -> Bool = {_ in true}
        var onChange : (UITextView) -> () = {_ in}
        var didBecomeFirstResponder = false
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            let currentString: NSString = textView.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: text) as NSString
            return newString.length <= self.maxCharacters
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.text?.wrappedValue = textView.text
            onChange(textView)
        }
    }
}
