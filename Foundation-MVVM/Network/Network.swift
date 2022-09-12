import Foundation

protocol Network {
    func request<Type: Decodable>(_ route: Route) async -> Result<Type, Error>
    func cachedFetch<Type: Decodable>(_ route: Route) async -> Result<Type, Error> where Type: Encodable
}
