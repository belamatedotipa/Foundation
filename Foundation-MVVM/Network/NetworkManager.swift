import Alamofire
import Foundation

enum NetworkError: Error {
    case serverError(ServerError)
    case connectionTimeout
    case notConnectedToInternet
    case serverConnectionFailed
    case noAccessToken
    case other(AFError)
}

struct ServerError {
    var statusCode: Int
    var data: Data?
}

final class NetworkManager: Network {

    private let session: Session
    private let decoder: JSONDecoder

    init(session: Session,
         decoder: JSONDecoder) {
        self.session = session
        self.decoder = decoder
    }

    private func process(error: AFError, with responseData: Data?) -> NetworkError {
        switch error {
        case .responseValidationFailed(let reason):
            switch reason {
            case .unacceptableStatusCode(let statusCode):
                let serverError = ServerError(statusCode: statusCode, data: responseData)
                return NetworkError.serverError(serverError)

            default: break
            }
            // swiftlint:disable identifier_name
        case .sessionTaskFailed(let _error as NSError):
            switch _error.code {
            case NSURLErrorTimedOut:
                return NetworkError.connectionTimeout

            case NSURLErrorCannotConnectToHost:
                return NetworkError.serverConnectionFailed

            case NSURLErrorNotConnectedToInternet:
                return NetworkError.notConnectedToInternet

            default: break
            }

        default: break
        }

        return NetworkError.other(error)
    }

    func request<Type: Decodable>(_ route: Route) async -> Result<Type, Error> {

        let dataTask = session
            .request(route)
            .validate()
            .serializingDecodable(Type.self)

        let result = await dataTask.result

        switch result {
        case .success(let responseData):
            return .success(responseData)
        case .failure(let error):
            let networkError = self.process(error: error, with: nil)
            return .failure(networkError)
        }
    }

    func cachedFetch<Type: Decodable>(_ route: Route) async -> Result<Type, Error> where Type: Encodable {
        let userDefaults = UserDefaults.standard
        var hasher = Hasher()
        hasher.combine(route.endpoint)
        hasher.combine(route.method)
        hasher.combine(route.parameters)
        if let parameters = route.parameters {
            hasher.combine(parameters)
        }
        let hash = hasher.finalize()

        let cacheKey = "cache\(hash)"
        if let cachedData = userDefaults.object(forKey: cacheKey) as? Data {
            if let cachedResponse = try? decoder.decode(Type.self, from: cachedData) {
                return .success(cachedResponse)
            }
        }

        let result: Result<Type, Error> = await request(route)

        let encoder = JSONEncoder()
        if case .success(let response) = result,
           let encoded = try? encoder.encode(response) {
            userDefaults.set(encoded, forKey: cacheKey)
        }

        return result
    }
}
