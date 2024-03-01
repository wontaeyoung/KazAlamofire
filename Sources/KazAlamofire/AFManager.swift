import Alamofire

public final class AFManager {
  
  public typealias HTTPStatusCode = Int
  
  // MARK: - Singleton
  public static let shared = AFManager()
  private init() { }
  
  
  // MARK: - Method
  public func callRequest<D: Decodable>(
    responseType: D.Type,
    router: AFRouter,
    completion: @escaping (D) -> Void,
    errorHandle: ((AFError) -> Void)?
  ) {
    
    AF.request(router)
      .validate()
      .responseDecodable(of: responseType.self) { response in
        
        switch response.result {
          case .success(let result):
            completion(result)
            
          case .failure(let error):
            errorHandle?(error)
        }
      }
  }
  
  public func callRequest<D: Decodable>(
    responseType: D.Type,
    router: AFRouter,
    completion: @escaping (Result<D, AFError>) -> Void
  ) {
    
    AF.request(router)
      .validate()
      .responseDecodable(of: responseType.self) { response in
        
        switch response.result {
          case .success(let result):
            completion(.success(result))
            
          case .failure(let error):
            completion(.failure(error))
        }
      }
  }
  
  public func callRequest<D: Decodable>(
    responseType: D.Type,
    router: AFRouter
  ) async throws -> D {
    return try await AF.request(router)
      .validate()
      .serializingDecodable(responseType.self)
      .value
  }
  
  public func callRequest<D: Decodable>(
    responseType: D.Type,
    router: AFRouter,
    additionalError: [HTTPStatusCode: Error] = [:]
  ) async throws -> D {
    let response = await AF.request(router)
      .validate()
      .serializingDecodable(responseType.self)
      .response
    
    guard let httpResponse = response.response else {
      throw AFError.responseValidationFailed(reason: .customValidationFailed(error: AFManagerError.invalidResponse))
    }
    
    for (statusCode, error) in additionalError {
      guard httpResponse.statusCode != statusCode else {
        throw error
      }
    }
    
    guard let result = response.value else {
      throw AFError.responseValidationFailed(reason: .customValidationFailed(error: AFManagerError.invalidData))
    }
    
    return result
  }
}
