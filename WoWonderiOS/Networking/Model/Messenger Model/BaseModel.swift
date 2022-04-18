
import Foundation
class BaseModel{
    struct ServerKeyErrorModel: Codable {
        let apiStatus: String?
        let errors: ServerKeyErrors?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case errors
        }
    }
    
    struct ServerKeyErrors: Codable {
        let  errorText: String?
        
        enum CodingKeys: String, CodingKey {
            case errorText = "error_text"
        }
    }

    
}
