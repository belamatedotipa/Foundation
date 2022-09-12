import Foundation

extension Endpoint {

    static func search(_ endpoint: Endpoint.SpotifySearch) -> Endpoint {
        endpoint.value
    }

    enum SpotifySearch {
        case get

        var value: Endpoint {
            switch self {
            case .get:
                return Endpoint(base: URL(string: "https://api.spotify.com")!,
                                path: "/v1/search")
            }
        }
    }
}
