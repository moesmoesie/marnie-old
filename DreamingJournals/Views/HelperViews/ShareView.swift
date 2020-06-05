//
//  ShareView.swift
//  DreamingJournals
//
//  Created by moesmoesie on 05/06/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

import UIKit
import SwiftUI

struct ShareView: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareView>) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        controller.excludedActivityTypes = [.print]
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareView>) {}
}
