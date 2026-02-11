import Foundation
import Moya

public enum MainService {
    case getNamazTimes(body:NamazTimesRequest)
    case getCityNames
    case getMediaFiles
    case getNamazs
    case getTimePeriod(body: NamazPeriodRequest)
}



// MARK: - TargetType Protocol Implementation
extension MainService:BaseService {
    public var path: String{
        switch self {
        case .getNamazTimes:
            return "/namazes/time"
        case .getCityNames:
            return "/namazes/regions"
        case .getMediaFiles:
            return "/mediaFiles"
        case .getNamazs:
            return "/mediaFiles/namaz"
        case .getTimePeriod:
            return "/namazes/time/period"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .getNamazTimes, .getTimePeriod:
            return .post
        case .getCityNames, .getMediaFiles, .getNamazs:
             return .get
        }
    }
    public var task: Task {
        switch self {
        case let .getNamazTimes(body):
            return .requestJSONEncodable(body)
        case .getCityNames:
            return .requestPlain
        case .getMediaFiles:
            return .requestPlain
        case .getNamazs:
            return .requestPlain
        case let .getTimePeriod(body):
            return .requestJSONEncodable(body)
        }
    }
    public var sampleData: Data{
        //TODO: Add real sample data for test cases!!!
        return Data()
    }

}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
