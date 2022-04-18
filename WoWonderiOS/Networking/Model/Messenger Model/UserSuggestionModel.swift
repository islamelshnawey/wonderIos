

import Foundation
class UserSuggestionModel:BaseModel{
    struct UserSuggestionSuccessModel: Codable {
        let apiStatus: Int?
        let suggestions: [Suggestion]?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case suggestions
        }
    }
    
    // MARK: - Suggestion
    struct Suggestion: Codable {
        let userID, username, email, firstName: String?
        let lastName: String?
        let avatar: String?
        let cover: String?
        let backgroundImage, relationshipID, address, working: String?
        let workingLink, about, school: String?
        let gender: String?
        let birthday, countryID, website: String?
        let facebook: String?
        let google, twitter, linkedin, youtube: String?
        let vk: String?
        let instagram: String?
        let language: String?
        let ipAddress, followPrivacy, friendPrivacy: String?
        let postPrivacy: String?
        let messagePrivacy, confirmFollowers, showActivitiesPrivacy, birthPrivacy: String?
        let visitPrivacy, verified, lastseen, emailNotification: String?
        let eLiked, eWondered, eShared, eFollowed: String?
        let eCommented, eVisited, eLikedPage, eMentioned: String?
        let eJoinedGroup, eAccepted, eProfileWallPost, eSentmeMsg: String?
        let eLastNotif, notificationSettings, status, active: String?
        let admin, registered, phoneNumber, isPro: String?
        let proType: String?
        let timezone: String?
        let referrer, refUserID, balance, paypalEmail: String?
        let notificationsSound, orderPostsBy, androidMDeviceID, iosMDeviceID: String?
        let androidNDeviceID, iosNDeviceID, webDeviceID, wallet: String?
        let lat, lng, lastLocationUpdate, shareMyLocation: String?
        let lastDataUpdate: String?
        let details: Details? = nil
        let lastAvatarMod, lastCoverMod, points, dailyPoints: String?
        let pointDayExpire, lastFollowID, shareMyData: String?
        let lastLoginData: String?
        let twoFactor, newEmail, twoFactorVerified, newPhone: String?
        let infoFile, city, state, zip: String?
        let schoolCompleted: String?
        let weatherUnit: String?
        let url: String?
        let name, lastseenUnixTime: String?
        let lastseenStatus: String?
        let lastseenTimeText, avatarFull: String?
        
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
            case timezone, referrer
            case refUserID = "ref_user_id"
            case balance
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
            case details
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
            case city, state, zip
            case schoolCompleted = "school_completed"
            case weatherUnit = "weather_unit"
            case url, name
            case lastseenUnixTime = "lastseen_unix_time"
            case lastseenStatus = "lastseen_status"
            case lastseenTimeText = "lastseen_time_text"
            case avatarFull = "avatar_full"
        }
    }
    
    // MARK: - Details
    struct Details: Codable {
        let postCount, albumCount, followingCount, followersCount: String?
        let groupsCount, likesCount: String?
        
        enum CodingKeys: String, CodingKey {
            case postCount = "post_count"
            case albumCount = "album_count"
            case followingCount = "following_count"
            case followersCount = "followers_count"
            case groupsCount = "groups_count"
            case likesCount = "likes_count"
        }
    }
    
    enum Facebook: String, Codable {
        case empty = ""
        case the1762434704055336 = "1762434704055336"
    }
    
    enum Gender: String, Codable {
        case male = "male"
    }
    
    enum Language: String, Codable {
        case english = "english"
        case german = "german"
        case russian = "russian"
    }
    
    enum LastseenStatus: String, Codable {
        case off = "off"
    }
    
    enum PostPrivacy: String, Codable {
        case ifollow = "ifollow"
    }
    
    enum Timezone: String, Codable {
        case utc = "UTC"
    }
    
    enum Vk: String, Codable {
        case empty = ""
        case id543072448 = "id543072448"
    }
    
    enum WeatherUnit: String, Codable {
        case us = "us"
    }
    struct UserSuggestionErrorModel: Codable {
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
