import Alamofire

public final class AFManager {
  
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
}
