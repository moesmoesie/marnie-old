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

        if UserDefaults.standard.string(forKey: "isFirstBoot") == nil{
            UserDefaults.standard.set("false", forKey: "isFirstBoot")
            
            for dream in sampleData{
                print(dream.title)
                try? Dream.saveDream(dream, context: context)
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
    for index in 1...5{
        let dream = DreamViewModel(id: UUID(),
        title: "Sample Dream \(index)",
        text: sampleTexts.randomElement()!,
        tags: Array(sampleTags.shuffled().prefix(Int.random(in: 0..<6))),
        date: Calendar.current.date(byAdding: .day, value: -index,to: Date()) ?? Date(),
        isBookmarked: Bool.random(),
        isNewDream: false,
        isNightmare: Bool.random(),
        isLucid:  Bool.random())
        temp.append(dream)
    }
    return temp
}

var sampleTexts : [String] = [
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean ultrices, augue ut sodales dignissim, lorem purus vulputate risus, ut vestibulum odio sapien vel neque. Donec eros nibh, volutpat eget urna id, lacinia hendrerit lorem. Morbi id tristique massa. Cras iaculis facilisis velit, eget volutpat sem feugiat at. Nunc mollis nunc eget aliquam eleifend. Nullam placerat enim sed nunc varius bibendum. Morbi accumsan ornare metus eu luctus.",
    
    "Nullam molestie vulputate volutpat. Donec tristique maximus leo et vehicula. Praesent placerat nibh et ullamcorper semper. Phasellus et consequat ante, vitae rhoncus tellus. Curabitur odio erat, cursus sed mauris non, commodo lacinia purus. Aenean tincidunt tellus eu dui dictum maximus. Nam id tellus a ex fermentum congue at eu dolor. Nulla sit amet justo luctus, accumsan dui eu, laoreet diam.",
    
    "Sed consequat viverra metus in tincidunt. Curabitur scelerisque tellus quis semper lacinia. Nulla facilisi. Aenean congue nisi eu urna venenatis, eget molestie justo facilisis. Vestibulum molestie at enim ac maximus. Vivamus at neque felis. Sed tempus, tellus laoreet consectetur sagittis, libero justo accumsan ipsum, eu euismod ipsum urna quis lacus. Fusce et dui iaculis, feugiat tellus sit amet, dictum leo. Duis et feugiat ipsum. Ut aliquet iaculis condimentum. In at felis justo. Aenean ut tristique turpis. Curabitur elementum accumsan nunc sed commodo. Maecenas lorem velit, ullamcorper quis ex id, bibendum bibendum ex. Etiam mollis cursus est. Nullam venenatis dolor in mollis semper.",
    
    "Proin bibendum semper neque et placerat. Aenean eget erat sed est malesuada gravida ac consequat nulla. Nunc vestibulum rutrum leo. Phasellus sodales turpis velit, non sagittis justo vehicula tempus. Morbi condimentum venenatis nibh in commodo. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Duis nibh mauris, faucibus eget libero a, bibendum tincidunt quam. Phasellus ornare pulvinar massa. Cras odio ante, fringilla vel tristique eget, eleifend vel tellus. Donec semper nisl non massa vehicula, sed vehicula est consectetur. Curabitur fringilla felis ex, eget luctus erat ultricies id. Integer justo magna, rhoncus ut fringilla id, tempor sit amet massa. Curabitur laoreet quam sed massa cursus blandit eget eget felis.",
    
    
    "Integer consectetur quam in diam aliquam, condimentum euismod libero suscipit. Aliquam erat volutpat. Suspendisse porta nunc nulla, a tincidunt justo convallis eu. Nunc sollicitudin risus lacus, et pellentesque enim finibus at. Integer congue cursus tellus in tempus. Aliquam dignissim viverra dolor at gravida. Cras sollicitudin condimentum eros, ut sollicitudin orci congue et. Integer mattis feugiat tortor, in sodales arcu rhoncus non. Ut sem est, venenatis quis euismod a, commodo vestibulum libero. Phasellus condimentum enim sed diam maximus commodo. Duis sit amet mauris est. Proin id dui et nisi gravida aliquet id gravida sem. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.",
    
    
    "Etiam ac tortor sed mauris convallis ullamcorper scelerisque et tortor. Quisque bibendum tempus tellus ut scelerisque. Maecenas eu cursus erat. Integer bibendum mauris quam, vel pretium magna volutpat sit amet. Phasellus eget odio a ante mattis bibendum. Donec nec accumsan nulla. Nulla ut eleifend orci. Aenean sit amet ultricies lorem, non iaculis odio."
]


var sampleTags : [TagViewModel] = [
    TagViewModel(text: "Happiness"),
    TagViewModel(text: "Grief"),
    TagViewModel(text: "Hammer"),
    TagViewModel(text: "Zombies"),
    TagViewModel(text: "Joy"),
    TagViewModel(text: "Fist Fight"),
    TagViewModel(text: "War"),
    TagViewModel(text: "Cheese"),
    TagViewModel(text: "Hamburgers"),
    TagViewModel(text: "Plants"),
    TagViewModel(text: "Zelda"),
    TagViewModel(text: "Link"),
    TagViewModel(text: "Mario"),
    TagViewModel(text: "Kees"),
    TagViewModel(text: "Giant Bee"),
    TagViewModel(text: "Peaches"),
    TagViewModel(text: "Banana"),
    TagViewModel(text: "Bike"),
    TagViewModel(text: "Money"),
    TagViewModel(text: "Thristy"),
    TagViewModel(text: "Love"),
]
