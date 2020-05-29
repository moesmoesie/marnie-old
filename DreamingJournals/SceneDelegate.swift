//
//  SceneDelegate.swift
//  dream-book
//
//  Created by moesmoesie on 24/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // Get the managed object context from the coreDataStack.
        let context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.managedObjectContext
        
        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        let keyboardObserver = KeyboardObserver()
        let filterObserver = FilterObserver()
        let contentView = MainNavigationView()
            .environment(\.managedObjectContext, context)
            .environmentObject(keyboardObserver)
            .environmentObject(filterObserver)

        
        let dreamService = DreamService(managedObjectContext: context)
        
        if UserDefaults.standard.string(forKey: "isFirstBoot") == nil{
            UserDefaults.standard.set("false", forKey: "isFirstBoot")
            
            for dream in sampleData{
                print(dream.title)
                try? dreamService.saveDream(dreamViewModel: dream)
            }
        }
        
        
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = CustomHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

class CustomHostingController<Content>: UIHostingController<Content> where Content: View {
    @objc override var preferredStatusBarStyle: UIStatusBarStyle{
        .lightContent
    }
}

var sampleData : [DreamViewModel]{
    var temp : [DreamViewModel] = []
    for index in 1...100000{
        let dream = DreamViewModel(id: UUID(),
        title: "Sample Dream \(index)",
        text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras vitae pharetra diam. Aliquam et ultrices ipsum. In faucibus, velit at tincidunt gravida, tortor diam tincidunt sem, vitae suscipit dolor ex eu felis. Ut consequat pulvinar nibh, ornare euismod libero tempor vitae. Nullam dapibus metus ac neque porttitor aliquam. Mauris rhoncus lacinia sem vel pellentesque. Suspendisse elementum, dolor quis tincidunt blandit, mi turpis euismod nulla, nec consequat metus enim a ipsum. Donec posuere metus vel faucibus mattis. Cras neque arcu, accumsan vulputate dolor quis, cursus vestibulum metus. ",
        tags: [TagViewModel(text: "Joy"),TagViewModel(text: "Zombies"), TagViewModel(text: "Happiness"),TagViewModel(text: "Anger")],
        date: Date(),
        isBookmarked: Bool.random(),
        isNewDream: false,
        isNightmare: Bool.random(),
        isLucid:  Bool.random())
        temp.append(dream)
    }
    return temp
}
