//
//  LottieView.swift
//  DreamingJournals
//
//  Created by moesmoesie on 26/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable{
    let animationView = AnimationView()
    var fileName : String
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        let animation = Animation.named(fileName)
        animationView.animation = animation
        animationView.play()
        animationView.loopMode = .autoReverse
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
    
}
