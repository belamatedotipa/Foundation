import Foundation
import SwiftUI
import SpotifyiOS
import Combine

enum SpotifyError: Error {
    case token
}

class SpotifyController: NSObject, ObservableObject {

    private let spotifyRepository: SpotifyRepository
    private let redirectURI = URL(string: "spotify-callback://")!
    private var authorizationCode: String?

    private var clientID: String {
        if let id = Bundle.main.infoDictionary?["SPOTIFY_CLIENT_ID"] as? String {
            return id
        } else {
            fatalError("Client ID not found")
        }
    }

    private var clientSecret: String {
        if let id = Bundle.main.infoDictionary?["SPOTIFY_CLIENT_SECRET"] as? String {
            return id
        } else {
            fatalError("Client secret not found")
        }
    }

    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: clientID, redirectURL: redirectURI)
        configuration.playURI = "spotify:track:4uLU6hMCjMI75M1A2tKUQC"
        // Set these url's to your backend which contains the secret to exchange for an access token
        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
        configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap") // Lehet ez kell a url schemebe?
        configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
        return configuration
    }()

    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()

    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()

    private var connectCancellable: AnyCancellable?
    private var disconnectCancellable: AnyCancellable?

    init(spotifyRepository: SpotifyRepository) {
        self.spotifyRepository = spotifyRepository
        super.init()
        connectCancellable = NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.connect()
            }

        disconnectCancellable = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.disconnect()
            }

    }

    func getAccessToken(from url: URL) async -> Result<Int, Error> {
        let parameters = appRemote.authorizationParameters(from: url)

        if let authorizationCode = parameters?["code"] {
            self.authorizationCode = authorizationCode
            let result = await spotifyRepository.getAuthToken(with: authorizationCode,
                                                              redirectURI: redirectURI.absoluteString,
                                                              secret: clientSecret,
                                                              clientID: clientID)
            switch result {
            case .success(let response):
                appRemote.connectionParameters.accessToken = response.accessToken
                return .success(1)
            case .failure(let error):
                return .failure(error)
            }
        } else if (parameters?["error"]) != nil {
            return .failure(SpotifyError.token)
        }
        return .failure(SpotifyError.token)
    }

    func connect() {
        if self.appRemote.connectionParameters.accessToken != nil {
            self.appRemote.connect()
        }
    }

    func disconnect() {
        if appRemote.isConnected {
            appRemote.disconnect()
        }
    }

    func initiateSession() {
        let scope: SPTScope = [.appRemoteControl, .playlistReadPrivate]
        sessionManager.initiateSession(with: scope, options: .clientOnly)
    }
}

// MARK: - SPTAppRemoteDelegate
extension SpotifyController: SPTAppRemoteDelegate {

    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        return
    }

    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        return
    }

    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        return
    }
}

// MARK: - SPTSessionManagerDelegate
extension SpotifyController: SPTSessionManagerDelegate {

    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        // TODO: Handle error
    }

    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        return
    }

    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        appRemote.connectionParameters.accessToken = session.accessToken
        appRemote.connect()
    }
}
