import Foundation

// MARK: - Error
struct DefaultError: Codable {
    let statusCode: Int
    let message: String
    let ver: Int?
}

public class ErrorModel {
    private(set) public var message: String?
    private(set) public var code: String?
    
    convenience public init() {
        self.init(
            title: "Error!",
            message: "Oops! Something went wrong!\nHelp us improve your experience by sending an error report.")
    }
    
    convenience public init(message: String? = nil, code: String? = nil) {
        self.init(title: "Error!", message: message, code: code)
    }
    
    public init(title: String, message: String? = nil, code: String? = nil) {
        self.message = message
        self.code = code
    }
}
