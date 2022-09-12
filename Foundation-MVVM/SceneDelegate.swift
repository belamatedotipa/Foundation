import UIKit
import SwiftUI
import Alamofire
import SpotifyiOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UISceneDelegate {

    var spotifyController: SpotifyController { dependencyContainer.spotifyController }
    // MARK: - Basic properties
    var window: UIWindow?
    private lazy var navigationController = UINavigationController()
    private lazy var dependencyContainer = DependencyContainer()
    private lazy var coordinator = AppCoordinator(
        dependencyContainer: dependencyContainer,
        navigationController: navigationController
    )

    // MARK: - Methods
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        // swiftlint:disable line_length
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        // swiftlint:enable line_length
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = navigationController
        coordinator.start()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // swiftlint:disable line_length
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
        // swiftlint:enable line_length
    }

    func sceneDidBecomeActive(_ scene: UIScene) {

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

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }

        NotificationCenter.default.post(name: Notification.Name("spotifyCallback"),
                                        object: nil,
                                        userInfo: ["url": url])
    }
}
