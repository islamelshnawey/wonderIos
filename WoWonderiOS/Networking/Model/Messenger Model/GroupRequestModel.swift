

import Foundation
class GroupRequestModel:BaseModel{
    struct GroupRequestSuccessModel: Codable {
        var apiStatus: Int?
        var groupChatRequests: [GroupChatRequest]?
        var newGroupChatRequestsCount: Int?

        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case groupChatRequests = "group_chat_requests"
            case newGroupChatRequestsCount = "new_group_chat_requests_count"
        }
    }

    // MARK: - GroupChatRequest
    struct GroupChatRequest: Codable {
        var userID, groupID: Int?
        var active, lastSeen: String?
        var groupTab: GroupTab?

        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case groupID = "group_id"
            case active
            case lastSeen = "last_seen"
            case groupTab = "group_tab"
        }
    }

    // MARK: - GroupTab
    struct GroupTab: Codable {
        var groupID, userID, groupName: String?
        var avatar: String?
        var time, timeText: String?

        enum CodingKeys: String, CodingKey {
            case groupID = "group_id"
            case userID = "user_id"
            case groupName = "group_name"
            case avatar, time
            case timeText = "time_text"
        }
    }
    struct GroupRequestErrorModel: Codable {
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
class AcceptGroupRequestModel:BaseModel{
    struct AcceptGroupRequestSuccessModel: Codable {
        var apiStatus: Int?
        var messageData: String?

        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case messageData = "message_data"
        }
    }
    struct AcceptGroupRequestErrorModel: Codable {
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
class RejectGroupRequestModel:BaseModel{
    struct RejectGroupRequestSuccessModel: Codable {
        var apiStatus: Int?
        var messageData: String?

        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case messageData = "message_data"
        }
    }
    struct RejectGroupRequestErrorModel: Codable {
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
