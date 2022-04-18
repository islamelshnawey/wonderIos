
import Foundation

class UserChatModel:BaseModel{
    struct UserChatSuccessModel: Codable {
        let apiStatus : String?
        let typing: Int?
        let isRecording: Int?
        let messages: [Message]?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case typing, messages
            case isRecording = "is_recording"
        }
    }
    struct UserChatErrorModel: Codable {
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
    
//    struct Message: Codable {
//        let id, fromID, groupID, toID: String?
//        let text, media, mediaFileName, mediaFileNames: String?
//        let time, seen, deletedOne, deletedTwo: String?
//        let sentPush, notificationID, typeTwo, stickers: String?
//        let messageUser: MessageUser?
//        let timeText, position, type: String?
//        let product: Product?
//        let lat, long: String?
//
//        enum CodingKeys: String, CodingKey {
//            case id
//            case fromID = "from_id"
//            case groupID = "group_id"
//            case toID = "to_id"
//            case text, media, mediaFileName, mediaFileNames, time, seen
//            case deletedOne = "deleted_one"
//            case deletedTwo = "deleted_two"
//            case sentPush = "sent_push"
//            case notificationID = "notification_id"
//            case typeTwo = "type_two"
//            case stickers, messageUser
//            case timeText = "time_text"
//            case position, type
//            case product
//            case lat = "lat"
//            case long = "lng"
//
//        }
//    }
//
    
    struct Message: Codable {
        let id, fromID, groupID, pageID: String?
        let toID, text, media, mediaFileName: String?
        let mediaFileNames, time, seen, deletedOne: String?
        let deletedTwo, sentPush, notificationID, typeTwo: String?
        let stickers, productID, lat, lng: String?
        let replyID, storyID, broadcastID, forward: String?
        let reply:repltMessage?
//        let messageUser: MessageUser?
        let pin: String?
        let timeText, position, type: String?
        let product: Product?
        let fileSize: Int?
        

        enum CodingKeys: String, CodingKey {
            case id
            case fromID = "from_id"
            case groupID = "group_id"
            case pageID = "page_id"
            case toID = "to_id"
            case text, media, mediaFileName, mediaFileNames, time, seen
            case deletedOne = "deleted_one"
            case deletedTwo = "deleted_two"
            case sentPush = "sent_push"
            case notificationID = "notification_id"
            case typeTwo = "type_two"
            case stickers
            case productID = "product_id"
            case lat, lng
            case replyID = "reply_id"
            case reply
            case storyID = "story_id"
            case broadcastID = "broadcast_id"
            case forward
//            case messageUser
            case pin
            case timeText = "time_text"
            case position, type
            case product
            case fileSize = "file_size"
        }
    }
    
    struct repltMessage: Codable {
        let id, fromID, groupID, pageID: String?
        let toID, text, media, mediaFileName: String?
        let mediaFileNames, time, seen, deletedOne: String?
        let deletedTwo, sentPush, notificationID, typeTwo: String?
        let stickers, productID, lat, lng: String?
        let replyID, storyID, broadcastID, forward: String?
//        let messageUser: MessageUser?
        let pin: String?
        let timeText, position, type: String?
        let product: Product?
        let fileSize: Int?
        

        enum CodingKeys: String, CodingKey {
            case id
            case fromID = "from_id"
            case groupID = "group_id"
            case pageID = "page_id"
            case toID = "to_id"
            case text, media, mediaFileName, mediaFileNames, time, seen
            case deletedOne = "deleted_one"
            case deletedTwo = "deleted_two"
            case sentPush = "sent_push"
            case notificationID = "notification_id"
            case typeTwo = "type_two"
            case stickers
            case productID = "product_id"
            case lat, lng
            case replyID = "reply_id"
            case storyID = "story_id"
            case broadcastID = "broadcast_id"
            case forward
//            case messageUser
            case pin
            case timeText = "time_text"
            case position, type
            case product
            case fileSize = "file_size"
        }
    }
    
    struct MessageUser: Codable {
        let userID: String?
        let avatar: String?
        
        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case avatar
        }
    }
    

    // MARK: - Product
    struct Product: Codable {
        let id, userID, pageID, name: String?
        let productDescription, category, subCategory, price: String?
        let location, status, type, currency: String?
        let lng, lat, time, active: String?
        let images: [Image]?
        let timeText, postID, editDescription: String?
        let url: String?
        let productSubCategory: String?
        let fields: [String]?

        enum CodingKeys: String, CodingKey {
            case id
            case userID = "user_id"
            case pageID = "page_id"
            case name
            case productDescription = "description"
            case category
            case subCategory = "sub_category"
            case price, location, status, type, currency, lng, lat, time, active, images
            case timeText = "time_text"
            case postID = "post_id"
            case editDescription = "edit_description"
            case url
            case productSubCategory = "product_sub_category"
            case fields
        }
    }
    

    // MARK: - Image
    struct Image: Codable {
        let id: String?
        let image: String?
        let productID: String?
        let imageOrg: String?

        enum CodingKeys: String, CodingKey {
            case id, image
            case productID = "product_id"
            case imageOrg = "image_org"
        }
    }
    

}
class DeleteChatModel:BaseModel{
    struct DeleteChatSuccessModel: Codable {
        let apiStatus: Int?
        let message: String?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case message
        }
    }
    struct DeleteChatErrorModel: Codable {
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
class SendMessageModel:BaseModel{
    struct SendMessageSuccessModel: Codable {
    let apiStatus: Int?
    let messageData: [MessageDatum]?
    
    enum CodingKeys: String, CodingKey {
        case apiStatus = "api_status"
        case messageData = "message_data"
    }
    }
    
    struct SendMessageErrorModel: Codable {
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
    struct MessageDatum: Codable {
        let id, fromID, groupID, toID: String?
        let text, media, mediaFileName, mediaFileNames: String?
        let time, seen, deletedOne, deletedTwo: String?
        let sentPush, notificationID, typeTwo, stickers: String?
        let messageUser: MessageUser?
        let onwer: Int?
        let timeText, position, type: String?
        
        let messageHashID: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case fromID = "from_id"
            case groupID = "group_id"
            case toID = "to_id"
            case text, media, mediaFileName, mediaFileNames, time, seen
            case deletedOne = "deleted_one"
            case deletedTwo = "deleted_two"
            case sentPush = "sent_push"
            case notificationID = "notification_id"
            case typeTwo = "type_two"
            case stickers, messageUser, onwer
            case timeText = "time_text"
            case position, type
           
            case messageHashID = "message_hash_id"
        }
    }
    
    struct MessageUser: Codable {
        let userID, username, email, firstName: String?
        let lastName: String?
        let avatar, cover: String?
        let backgroundImage, relationshipID, address, working: String?
        let workingLink, about, school, gender: String?
        let birthday, countryID: String?
        let website: String?
        let facebook, google, twitter, linkedin: String?
        let youtube, vk, instagram, language: String?
        let ipAddress, followPrivacy, friendPrivacy, postPrivacy: String?
        let messagePrivacy, confirmFollowers, showActivitiesPrivacy, birthPrivacy: String?
        let visitPrivacy, verified, lastseen, emailNotification: String?
        let eLiked, eWondered, eShared, eFollowed: String?
        let eCommented, eVisited, eLikedPage, eMentioned: String?
        let eJoinedGroup, eAccepted, eProfileWallPost, eSentmeMsg: String?
        let eLastNotif, notificationSettings, status, active: String?
        let admin, registered, phoneNumber, isPro: String?
        let proType, timezone, referrer, balance: String?
        let paypalEmail, notificationsSound, orderPostsBy, androidMDeviceID: String?
        let iosMDeviceID, androidNDeviceID, iosNDeviceID, webDeviceID: String?
        let wallet, lat, lng, lastLocationUpdate: String?
        let shareMyLocation, lastDataUpdate: String?
       
        let lastAvatarMod, lastCoverMod, points, dailyPoints: String?
        let pointDayExpire, lastFollowID, shareMyData, lastLoginData: String?
        let twoFactor, newEmail, twoFactorVerified, newPhone: String?
        let infoFile, avatarFull: String?
        let url: String?
        let name: String?
        let lastseenUnixTime, lastseenStatus: String?
        
        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case username, email
            case firstName = "first_name"
            case lastName = "last_name"
            case avatar, cover
            case backgroundImage = "background_image"
            case relationshipID = "relationship_id"
            case address, working
            case workingLink = "working_link"
            case about, school, gender, birthday
            case countryID = "country_id"
            case website, facebook, google, twitter, linkedin, youtube, vk, instagram, language
            case ipAddress = "ip_address"
            case followPrivacy = "follow_privacy"
            case friendPrivacy = "friend_privacy"
            case postPrivacy = "post_privacy"
            case messagePrivacy = "message_privacy"
            case confirmFollowers = "confirm_followers"
            case showActivitiesPrivacy = "show_activities_privacy"
            case birthPrivacy = "birth_privacy"
            case visitPrivacy = "visit_privacy"
            case verified, lastseen, emailNotification
            case eLiked = "e_liked"
            case eWondered = "e_wondered"
            case eShared = "e_shared"
            case eFollowed = "e_followed"
            case eCommented = "e_commented"
            case eVisited = "e_visited"
            case eLikedPage = "e_liked_page"
            case eMentioned = "e_mentioned"
            case eJoinedGroup = "e_joined_group"
            case eAccepted = "e_accepted"
            case eProfileWallPost = "e_profile_wall_post"
            case eSentmeMsg = "e_sentme_msg"
            case eLastNotif = "e_last_notif"
            case notificationSettings = "notification_settings"
            case status, active, admin, registered
            case phoneNumber = "phone_number"
            case isPro = "is_pro"
            case proType = "pro_type"
            case timezone, referrer, balance
            case paypalEmail = "paypal_email"
            case notificationsSound = "notifications_sound"
            case orderPostsBy = "order_posts_by"
            case androidMDeviceID = "android_m_device_id"
            case iosMDeviceID = "ios_m_device_id"
            case androidNDeviceID = "android_n_device_id"
            case iosNDeviceID = "ios_n_device_id"
            case webDeviceID = "web_device_id"
            case wallet, lat, lng
            case lastLocationUpdate = "last_location_update"
            case shareMyLocation = "share_my_location"
            case lastDataUpdate = "last_data_update"
           
            case lastAvatarMod = "last_avatar_mod"
            case lastCoverMod = "last_cover_mod"
            case points
            case dailyPoints = "daily_points"
            case pointDayExpire = "point_day_expire"
            case lastFollowID = "last_follow_id"
            case shareMyData = "share_my_data"
            case lastLoginData = "last_login_data"
            case twoFactor = "two_factor"
            case newEmail = "new_email"
            case twoFactorVerified = "two_factor_verified"
            case newPhone = "new_phone"
            case infoFile = "info_file"
            case avatarFull = "avatar_full"
            case url, name
            
            case lastseenUnixTime = "lastseen_unix_time"
            case lastseenStatus = "lastseen_status"
        }
    }
    
    struct Details: Codable {
        let postCount, albumCount, followingCount, followersCount: String?
        let groupsCount, likesCount: String?
        let mutualFriendsCount: Int?
        
        enum CodingKeys: String, CodingKey {
            case postCount = "post_count"
            case albumCount = "album_count"
            case followingCount = "following_count"
            case followersCount = "followers_count"
            case groupsCount = "groups_count"
            case likesCount = "likes_count"
            case mutualFriendsCount = "mutual_friends_count"
        }
    }
    
}
class DeleteConservationModel:BaseModel{
    // MARK: - Welcome
    struct DeleteConservationSuccessModel: Codable {
        var apiStatus: Int?
        var message: String?

        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case message
        }
    }
    struct DeleteConservationErrorModel: Codable {
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
