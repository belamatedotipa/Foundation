import Alamofire
import Foundation

struct Route {

    let method: HTTPMethod
    let endpoint: Endpoint
    let parameters: [String: AnyHashable]?
    let headers: HTTPHeaders?
    let encoding: ParameterEncoding

    init(_ method: HTTPMethod,
         _ endpoint: Endpoint,
         with params: [String: AnyHashable]? = nil,
         headers: HTTPHeaders? = nil,
         encoding: ParameterEncoding? = nil) {
        self.method = method
        self.endpoint = endpoint
        self.parameters = params
        self.headers = headers

        /* Call to connect/token requires a specific way of encoding
           Because of this, a parameter with specific type of encoding can be optionally passed
         */
        self.encoding = encoding ?? {
            switch method {
            case .get, .delete: return URLEncoding.default
            default: return JSONEncoding.default
            }}()
    }
}

extension Route: URLRequestConvertible {
    public func asURLRequest() throws -> URLRequest {
        let request = try URLRequest(
            url: endpoint.url,
            method: method,
            headers: headers
        )
        return try encoding.encode(request, with: parameters)
    }
}
