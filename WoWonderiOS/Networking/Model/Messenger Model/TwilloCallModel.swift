

import Foundation

class TwilloCallModel:BaseModel{
    struct TwilloCallSuccessModel: Codable {
        let status: Int?
        let accessToken, accessToken2, roomName: String?
        let id: Int?
        
        enum CodingKeys: String, CodingKey {
            case status
            case accessToken = "access_token"
            case accessToken2 = "access_token_2"
            case roomName = "room_name"
            case id
        }
    }
    
    struct TwilloCallErrorModel: Codable {
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
class TwilloCallActionModel:BaseModel{
    struct TwilloCallActionSuccessModel: Codable {
        let status: Int?
    }
    struct TwilloCallActionErrorModel: Codable {
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
class CheckForTwilloCallModel:BaseModel{
    struct CheckForTwilloCallSuccessModel: Codable {
        let apiStatus, apiText, apiVersion, callType: String?
        let callStatus: Int?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case apiText = "api_text"
            case apiVersion = "api_version"
            case callType = "call_type"
            case callStatus = "call_status"
        }
    }

    struct CheckForTwilloCallErrorModel: Codable {
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

class TwilloVidooCallModel:BaseModel{
    struct TwilloVidooCallSuccessModel: Codable {
        let status: Int?
        let accessToken, accessToken2, roomName: String?
        let id: Int?
        
        enum CodingKeys: String, CodingKey {
            case status
            case accessToken = "access_token"
            case accessToken2 = "access_token_2"
            case roomName = "room_name"
            case id
        }
    }
    
    struct TwilloVidooCallErrorModel: Codable {
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
class TwilloVideoCallActionModel:BaseModel{
    struct TwilloVideoCallActionSuccessModel: Codable {
        let status: Int?
        let url: String?
    }

    struct TwilloVideoCallActionErrorModel: Codable {
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
