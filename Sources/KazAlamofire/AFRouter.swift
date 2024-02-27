import Alamofire
import Foundation

public protocol AFRouter: URLRequestConvertible {
  
  var method: HTTPMethod { get }
  var baseURL: String { get }
  var path: String { get }
  var headers: HTTPHeaders { get }
  var parameters: Parameters? { get }
}

public extension AFRouter {
  
  public func asURLRequest() throws -> URLRequest {
    let url: URL = try baseURL.asURL().appendingPathComponent(path)
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.headers = headers
    
    return try URLEncoding.default.encode(request, with: parameters)
  }
}
