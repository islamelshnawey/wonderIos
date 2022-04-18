

import Foundation

class ColorModel:BaseModel{
    struct ColorSuccessModel: Codable {
        let apiStatus: Int?
        let color: String?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case color
        }
    }
    struct ColorErrorModel: Codable {
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
