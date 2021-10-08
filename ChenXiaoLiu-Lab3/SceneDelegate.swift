//
//  SceneDelegate.swift
//  ChenXiaoLiu-Lab3
//
//  Created by lcx on 2021/10/3.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var shortcutItem: UIApplicationShortcutItem!


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        shortcutItem = connectionOptions.shortcutItem
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
        handleShortcutItem(shortcutItem)
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

    // Learned from https://www.youtube.com/watch?v=cuJ8zE-48Dw
    // and https://developer.apple.com/documentation/uikit/menus_and_shortcuts/add_home_screen_quick_actions
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        self.shortcutItem = shortcutItem
    }
    
    private func handleShortcutItem(_ item: UIApplicationShortcutItem?) {
        guard item != nil,
              let navController = window?.rootViewController as? UINavigationController,
              let viewController = navController.children.first as? ViewController
        else {
            return
        }

        switch item!.type {
        case "drawSolidSquare":
            updateViewController(viewController, 0)
        case "drawOutlineSquare":
            updateViewController(viewController, 1)
        case "shareThisApp":
            viewController.share(items: [URL(string: "https://wustl.edu")!])
        default:
            return
        }
        shortcutItem = nil
    }
    
    private func updateViewController(_ viewController: ViewController, _ segmentIndex: Int) {
        viewController.shapeTypes.selectedSegmentIndex = segmentIndex
        viewController.shapeType = ShapeType(rawValue: segmentIndex)
        viewController.addItemToCanvasWith(origin: viewController.canvas.center)
    }
}
