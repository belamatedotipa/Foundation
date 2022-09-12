import Foundation
import UIKit
import Combine

enum LoginInput {
    case tap
}

final class LoginViewModel: ViewModel {

    @Published internal var state: LoginState
    private let coordinator: AppCoordinator
    private let spotifyController: SpotifyController
    private var callbackCancellable: AnyCancellable?

    init(coordinator: AppCoordinator,
         spotifyController: SpotifyController) {
        self.coordinator = coordinator
        self.spotifyController = spotifyController
        state = .initial
        callbackCancellable = NotificationCenter.default.publisher(for: Notification.Name("spotifyCallback") )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                self?.handleSpotifyCallback(notification: notification)
            }
    }

    func trigger(_ input: LoginInput) {
        switch input {
        case .tap:
            state = .loading

            // Authenticate if Spotify is installed
            if isSpotifyInstalled() {
                // Start animation before app switch to establish continuity before seeing animation on return
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                    self?.spotifyController.initiateSession()
                }
                // Open AppStore if Spotify is not installed
            } else if let url = URL(string: "itms-apps://apple.com/app/id324684580") {
                UIApplication.shared.open(url)
            } else {
                state = .error
            }
        }
    }

    func isSpotifyInstalled() -> Bool {
        return UIApplication.shared.canOpenURL(NSURL(string: "spotify:")! as URL)
    }

    func handleSpotifyCallback(notification: Notification) {
        guard let url: URL = notification.userInfo?["url"] as? URL
        else {
            state = .error
            return
        }
        Task {
            let result = await spotifyController.getAccessToken(from: url)
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.coordinator.dismiss()
                }
            case .failure:
                state = .error
            }
        }
    }
}
