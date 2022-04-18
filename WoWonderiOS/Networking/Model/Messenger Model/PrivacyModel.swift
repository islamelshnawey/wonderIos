

import Foundation
class PrivacyModel:BaseModel{
    struct PrivacySuccessModel: Codable {
        let apiStatus: Int?
        let message: String?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case message
        }
    }
    
    
    struct PrivacyErrorModel: Codable {
        let apiStatus: String?
        let errors: Errors?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case errors
        }
    }
    
    struct Errors: Codable {
        let errorID: Int?
        let errorText: String?
        
        enum CodingKeys: String, CodingKey {
            case errorID = "error_id"
            case errorText = "error_text"
        }
    }
    
}
