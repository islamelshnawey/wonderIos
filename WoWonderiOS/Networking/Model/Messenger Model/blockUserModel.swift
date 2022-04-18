

import Foundation
class GetBlockedUsersModel:BaseModel{
  
    
    struct GetBlockedUsersSusscessModel: Codable {
        let apiStatus: Int?
        let blockedUsers: [BlockedUser]?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case blockedUsers = "blocked_users"
        }
    }
    struct GetBlockedUsersErrorModel: Codable {
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
    
    struct BlockedUser: Codable {
        let userID, username, email, firstName: String?
        let lastName: String?
        let avatar, cover: String?
        let backgroundImage, relationshipID, address, working: String?
        let workingLink, about, school, gender: String?
        let birthday, countryID, website, facebook: String?
        let google, twitter, linkedin, youtube: String?
        let vk, instagram, language, ipAddress: String?
        let followPrivacy, friendPrivacy, postPrivacy, messagePrivacy: String?
        let confirmFollowers, showActivitiesPrivacy, birthPrivacy, visitPrivacy: String?
        let verified, lastseen, emailNotification, eLiked: String?
        let eWondered, eShared, eFollowed, eCommented: String?
        let eVisited, eLikedPage, eMentioned, eJoinedGroup: String?
        let eAccepted, eProfileWallPost, eSentmeMsg, eLastNotif: String?
        let notificationSettings, status, active, admin: String?
        let registered, phoneNumber, isPro, proType: String?
        let timezone, referrer, balance, paypalEmail: String?
        let notificationsSound, orderPostsBy, androidMDeviceID, iosMDeviceID: String?
        let androidNDeviceID, iosNDeviceID, webDeviceID, wallet: String?
        let lat, lng, lastLocationUpdate, shareMyLocation: String?
        let lastDataUpdate: String?
        let lastAvatarMod, lastCoverMod, points, dailyPoints: String?
        let pointDayExpire, lastFollowID, shareMyData, lastLoginData: String?
        let twoFactor, newEmail, twoFactorVerified, newPhone: String?
        let infoFile: String?
        let url: String?
        let name: String?
        let
        lastseenTimeText: String?
        
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
            case url, name
            
            case lastseenTimeText = "lastseen_time_text"
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

class BlockUnblockModel:BaseModel{
    struct BlockUnblockSuccessModel: Codable {
        let apiStatus: Int?
        let blockStatus: String?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case blockStatus = "block_status"
        }
    }
    struct BlockUnblockErrorModel: Codable {
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
