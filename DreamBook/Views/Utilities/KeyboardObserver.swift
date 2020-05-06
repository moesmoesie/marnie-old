//
//  KeyBoardObserver.swift
//  DreamBook
//
//  Created by moesmoesie on 06/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI
import Combine

class KeyboardObserver : ObservableObject{
    
    @Published var height : CGFloat = 0
    private var cancellableSet: Set<AnyCancellable> = []
    
    var isKeyboardShowing : Bool{
        height > 0
    }
    
    var heightWithoutSaveArea : CGFloat{
        height - (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0)
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    init() {
        
        let keyboardShow = NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)
            .compactMap{
                $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        }.map{
            $0.cgRectValue.height
        }
        
        let keyboardHide = NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)
            .map{ _ in CGFloat.zero}
        
        
        Publishers.Merge(keyboardHide, keyboardShow)
            .sink{self.height = $0}
            .store(in: &cancellableSet)
    }
}
