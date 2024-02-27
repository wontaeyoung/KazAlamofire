import Alamofire

extension AFError {
  
  var logDescription: String {
    switch self {
      case .explicitlyCancelled:
        return "요청이 명시적으로 취소되었습니다."
        
      case .sessionTaskFailed(let error):
        return "세션 작업 실패: \(error.localizedDescription)"
        
      case .sessionInvalidated(let error):
        if let error = error {
          return "세션 비정상 오류: \(error.localizedDescription)"
        } else {
          return "알 수 없는 세션 비정상 오류 발생."
        }
      case .sessionDeinitialized:
        return "세션이 해제되었습니다. 참조가 소실되었을 가능성이 있습니다."
        
      case .invalidURL(let url):
        return "잘못된 URL: \(url)"
        
      case .urlRequestValidationFailed(let reason):
        return "URLRequest 검증 실패: \(reason)"
        
      default:
        return "알 수 없는 오류가 발생했습니다. 더 자세한 내용은 AFError 케이스를 확인하세요."
    }
  }
  
  var alertDescription: String {
    switch self {
      case .explicitlyCancelled:
        return "요청이 취소되었어요. 다시 시도해주세요."
        
      case .sessionTaskFailed, .sessionInvalidated, .sessionDeinitialized:
        return "네트워크 연결에 문제가 있어요. 와이파이 연결을 확인하거나 데이터 네트워크 상태를 확인해주세요."
        
      case .invalidURL, .urlRequestValidationFailed:
        return "요청한 주소(URL)가 잘못되었어요. 주소를 확인하고 다시 시도해주세요."
        
      default:
        return "알 수 없는 오류가 발생했어요. 앱을 다시 시작해보시고, 문제가 지속되면 고객센터에 문의해주세요."
    }
  }
}
