//
//  SceneDelegate.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/3/28.
//

import UIKit
import SwiftUI
import IQKeyboardManagerSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        IQKeyboardManager.shared.enable = true
        
        RealmHelper.configRealm("user")
        RealmHelper.configRealm("news")
        RealmHelper.configRealm("competition")
        // Create the SwiftUI view that provides the window contents.
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            if  let token = UserDefaults.standard.value(forKey: "token") {
                let array:[UserModel] = RealmHelper.queryObject(objectClass: UserModel(), filter: nil, "user")
                if array.count > 0 {
                    let users = array.filter { user in
                        return  user.id == token as! String
                    }
                    if users.count > 0 {
                        Singleton.shared.userModel = users.first!
                        window.rootViewController = Tabbar()
                    }else{
                        window.rootViewController = UINavigationController(rootViewController: LoginViewController())
                    }
                }
            }else{
                window.rootViewController = UINavigationController(rootViewController: LoginViewController())
            }
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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

