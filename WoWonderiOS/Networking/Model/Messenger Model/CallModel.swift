

import Foundation
class CallModel:BaseModel{
    struct CallSuccessModel: Codable {
        let status: Int?
        let roomName: String?
        let id: Int?
        
        enum CodingKeys: String, CodingKey {
            case status
            case roomName = "room_name"
            case id
        }
    }

    struct CallErrorModel: Codable {
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
class CheckForAgoraCallModel:BaseModel{
    
    struct CheckForAgoraCallSuccessModel: Codable {
        
        let apiStatus, apiText, apiVersion, callStatus: String?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case apiText = "api_text"
            case apiVersion = "api_version"
            case callStatus = "call_status"
        }
    }

    struct CheckForAgoraCallErrorModel: Codable {
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
class AgoraCallActionModel:BaseModel{
    struct AgoraCallActionSuccessModel: Codable {
        let status: Int?
    }
    struct AgoraCallActionErrorModel: Codable {
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
