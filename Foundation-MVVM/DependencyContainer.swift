import Foundation
import Alamofire

final class DependencyContainer {

    // MARK: - Basic network
    private lazy var session = Session(
        configuration: .default
    )

    private lazy var networkManager = NetworkManager(
        session: session,
        decoder: JSONDecoder.default
    )

    // MARK: - Repositories
    lazy var spotifyRepository = SpotifyRepository(network: networkManager)
    lazy var pixrayRepository = PixrayRepository()

    // MARK: - Controllers
    lazy var spotifyController = SpotifyController(spotifyRepository: spotifyRepository)
}
