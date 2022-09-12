import Foundation

extension Endpoint {

    static func token(_ endpoint: Endpoint.SpotifyToken) -> Endpoint {
        endpoint.value
    }

    enum SpotifyToken {
        case post

        var value: Endpoint {
            switch self {
            case .post:
                return Endpoint(base: URL(string: "https://accounts.spotify.com")!,
                                path: "/api/token")
            }
        }
    }
}
