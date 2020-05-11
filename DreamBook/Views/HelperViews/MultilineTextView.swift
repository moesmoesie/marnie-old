//
//  MultilineTextView.swift
//  DreamBook
//
//  Created by moesmoesie on 04/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct MultilineTextField: View {
    
    struct _State {
        var height: CGFloat?
    }
    
    @State var state = _State()
    @EnvironmentObject var theme : Theme

    let placeholder: String
    @Binding var text: String
    
    let placeholderColor: UIColor = .gray
    let font: UIFont = UIFont.preferredFont(forTextStyle: .body)
   
    
    var body: some View {
        GeometryReader { (geo: GeometryProxy) in
            self.content(with: geo)
        }
        .frame(height: state.height)
    }
    
    func content(with geo: GeometryProxy) -> some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.init(placeholderColor))
                    .font(.init(font))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            textView(with: geo)
        }
    }
    
    func textView(with geo: GeometryProxy) -> some View {
        TextView(
            make: { coordinator in
                let textView = UITextView()
                textView.backgroundColor = UIColor.clear
                textView.delegate = coordinator
                textView.isScrollEnabled = false
                textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                textView.textContainerInset = .zero
                textView.textContainer.lineFragmentPadding = 0
                textView.textColor = self.theme.textBodyUIColor
                textView.tintColor = self.theme.primaryUIColor
                textView.font = self.font
                
                coordinator.text = self.$text
                coordinator.height = self.$state.height
                
                return textView
            },
            update: { uiView, coordinator  in
                if self.$text.wrappedValue != uiView.text {
                    uiView.text = self.$text.wrappedValue
                }
                coordinator.width = geo.size.width
                coordinator.adjustHeight(view: uiView)
        })
        .frame(height: state.height)
    }
    
}

struct TextView: UIViewRepresentable {
    
    typealias UIViewType = UITextView
    
    let make: (Coordinator) -> UIViewType
    let update: (UIViewType, Coordinator) -> Void
    
    func makeCoordinator() -> TextView.Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: UIViewRepresentableContext<TextView>) -> UIViewType {
        return make(context.coordinator)
    }
    
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<TextView>) {
        update(uiView, context.coordinator)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {

        var text: Binding<String> = .constant("")
        var width: CGFloat = 0
        var height: Binding<CGFloat?> = .constant(nil)
        var cursor: Binding<CGFloat?> = .constant(nil)
        
        func textViewDidChange(_ textView: UITextView) {
            if text.wrappedValue != textView.text {
                text.wrappedValue = textView.text
            }
            adjustHeight(view: textView)
        }

        func textViewDidChangeSelection(_ textView: UITextView) {
            OperationQueue.main.addOperation { [weak self] in
                self?.cursor.wrappedValue = self?.absoleteCursor(view: textView)
            }
        }
        
        func adjustHeight(view: UITextView) {
            let bounds = CGSize(width: width, height: .infinity)
            let height = view.sizeThatFits(bounds).height
            OperationQueue.main.addOperation { [weak self] in
                self?.height.wrappedValue = height
            }
        }
        
        func absoleteCursor(view: UITextView) -> CGFloat? {
            guard let range = view.selectedTextRange else {
                return nil
            }
            let caretRect = view.caretRect(for: range.end)
            let windowRect = view.convert(caretRect, to: nil)
            return windowRect.origin.y + windowRect.height
        }
        
    }
}
