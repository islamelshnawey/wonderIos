

import Foundation

class LoginModel:BaseModel{
    
    struct LoginSuccessModel: Codable {
      let apiStatus: Int
        let timezone:String? = nil
        let accessToken:String? 
        let userID: String?
        let message:String?
        

        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case timezone
            case message
            case accessToken = "access_token"
            case userID = "user_id"
        }
    }
    struct LoginErrorModel: Codable {
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
class RegisterModel:BaseModel{
    struct RegisterSuccessModel: Codable {
        let apiStatus: Int?
        let accessToken, userID: String?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case accessToken = "access_token"
            case userID = "user_id"
        }
    }
    struct RegisterErrorModel: Codable {
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
class ForgetPasswordModel1:BaseModel{
    struct ForgetPasswordSuccessModel: Codable {
        let apiStatus: Int?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
        }
    }
    struct ForgetPasswordErrorModel: Codable {
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

class SocialLoginModel:BaseModel{
    
    struct SocialLoginSuccessModel: Codable {
        let apiStatus: Int?
        let timezone, accessToken, userID: String?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case timezone
            case accessToken = "access_token"
            case userID = "user_id"
        }
    }
    struct SocialLoginErrorModel: Codable {
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
class DeleteUserModel:BaseModel{
    struct DeleteUserSuccessModel: Codable {
        let apiStatus: Int?
        let message: String?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case message
        }
    }
    struct DeleteUserErrorModel: Codable {
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
