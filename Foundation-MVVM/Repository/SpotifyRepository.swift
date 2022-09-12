import Foundation
import Alamofire

internal struct TokenEndpointResponse: Codable {

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
    }

    let accessToken: String
    let expiresIn: Double
    let refreshToken: String?
}

enum EncodingError: Error {
    case returnsNil
}

final class SpotifyRepository {

    private let network: Network
    private var accessToken: String?

    init(network: Network) {
        self.network = network
    }

    func getAuthToken(with authorizationCode: String,
                      redirectURI: String,
                      secret: String,
                      clientID: String) async -> Result<TokenEndpointResponse, Error> {

        let parameters = ["grant_type": "authorization_code",
                                      "code": authorizationCode,
                                      "redirect_uri": redirectURI]
        let idAndSecret = clientID+":"+secret
        guard let encodedIdAndSecret = idAndSecret.data(using: .utf8)?
            .base64EncodedString() else { return .failure(EncodingError.returnsNil)}
        let headers: HTTPHeaders = [HTTPHeader(name: "Authorization",
                                               value: "Basic \(encodedIdAndSecret)")]
        let route = Route(.post,
                          .token(.post),
                          with: parameters,
                          headers: headers,
                          encoding: URLEncoding.default)
        let result: Result<TokenEndpointResponse, Error> = await network.request(route)

        if case .success(let data) = result {
            self.accessToken = data.accessToken
        }
        return result
    }

    func searchTracks(for searchTerm: String, with offset: Int = 0) async -> Result<SearchDTO, Error> {

        let parameters: [String: AnyHashable] = ["q": "track:\(searchTerm)",
                                      "limit": 20,
                                      "offset": offset,
                                      "type": "track"]
        guard let accessToken = accessToken else { return .failure(NetworkError.noAccessToken) }
        let headers: HTTPHeaders = [HTTPHeader(name: "Authorization",
                                               value: "Bearer \(accessToken)")]
        let route = Route(.get,
                          .search(.get),
                          with: parameters,
                          headers: headers,
                          encoding: URLEncoding.queryString)
        let request: Result<SearchDTO, Error> = await network.cachedFetch(route)
        return request
    }
}
