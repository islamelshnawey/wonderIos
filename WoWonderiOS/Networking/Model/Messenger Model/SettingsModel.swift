
import Foundation

class UpdateUserDataModel1:BaseModel{
    struct UpdateUserDataSuccessModel: Codable {
        let apiStatus: Int?
        let message: String?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case message
        }
    }

    
    struct UpdateUserDataErrorModel: Codable {
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
class UpdateAvatarAndCoverModel:BaseModel{
    struct UpdateAvatarAndCoverSuccessModel: Codable {
        let apiStatus: Int?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
        }
    }
    struct UpdateAvatarAndCoverErrorModel: Codable {
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
