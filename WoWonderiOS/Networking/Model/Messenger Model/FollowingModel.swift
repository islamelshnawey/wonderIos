

import Foundation
class FollowingModel:BaseModel{
    
    struct FollowingSuccessModel: Codable {
        let apiStatus: Int?
        let following: [Following]?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case following
        }
    }
    struct FollowingErrorModel: Codable {
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
    struct Following: Codable {
        var userID: String?
        let username, email, firstName: String?
        let lastName: String?
        let avatar, cover: String?
        let backgroundImage, backgroundImageStatus, relationshipID, address: String?
        let working, workingLink, about, school: String?
        let gender, birthday, countryID, website: String?
        let facebook, google, twitter, linkedin: String?
        let youtube, vk, instagram, language: String?
        let emailCode, src, ipAddress, followPrivacy: String?
        let friendPrivacy, postPrivacy, messagePrivacy, confirmFollowers: String?
        let showActivitiesPrivacy, birthPrivacy, visitPrivacy, verified: String?
        let lastseen, showlastseen, emailNotification, eLiked: String?
        let eWondered, eShared, eFollowed, eCommented: String?
        let eVisited, eLikedPage, eMentioned, eJoinedGroup: String?
        let eAccepted, eProfileWallPost, eSentmeMsg, eLastNotif: String?
        let notificationSettings, status, active, admin: String?
        let type, registered, startUp, startUpInfo: String?
        let startupFollow, startupImage, lastEmailSent, phoneNumber: String?
        let smsCode, isPro, proTime, proType: String?
        let joined, cssFile, timezone, referrer: String?
        let balance, paypalEmail, notificationsSound, orderPostsBy: String?
        let socialLogin, androidMDeviceID, iosMDeviceID, androidNDeviceID: String?
        let iosNDeviceID, webDeviceID, wallet, lat: String?
        let lng, lastLocationUpdate, shareMyLocation, lastDataUpdate: String?
        let sidebarData, lastAvatarMod, lastCoverMod, points: String?
        let dailyPoints, pointDayExpire, lastFollowID, shareMyData: String?
        let lastLoginData, twoFactor, newEmail, twoFactorVerified: String?
        let newPhone, infoFile, avatarOrg, coverOrg: String?
        let coverFull, id: String?
        let url: String?
        let name: String?
        let lastseenUnixTime, lastseenStatus, familyMember: String?
        var isFollowing: Int?
        let avatarFull: String?
        
        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case username, email
            case firstName = "first_name"
            case lastName = "last_name"
            case avatar, cover
            case backgroundImage = "background_image"
            case backgroundImageStatus = "background_image_status"
            case relationshipID = "relationship_id"
            case address, working
            case workingLink = "working_link"
            case about, school, gender, birthday
            case countryID = "country_id"
            case website, facebook, google, twitter, linkedin, youtube, vk, instagram, language
            case emailCode = "email_code"
            case src
            case ipAddress = "ip_address"
            case followPrivacy = "follow_privacy"
            case friendPrivacy = "friend_privacy"
            case postPrivacy = "post_privacy"
            case messagePrivacy = "message_privacy"
            case confirmFollowers = "confirm_followers"
            case showActivitiesPrivacy = "show_activities_privacy"
            case birthPrivacy = "birth_privacy"
            case visitPrivacy = "visit_privacy"
            case verified, lastseen, showlastseen, emailNotification
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
            case status, active, admin, type, registered
            case startUp = "start_up"
            case startUpInfo = "start_up_info"
            case startupFollow = "startup_follow"
            case startupImage = "startup_image"
            case lastEmailSent = "last_email_sent"
            case phoneNumber = "phone_number"
            case smsCode = "sms_code"
            case isPro = "is_pro"
            case proTime = "pro_time"
            case proType = "pro_type"
            case joined
            case cssFile = "css_file"
            case timezone, referrer, balance
            case paypalEmail = "paypal_email"
            case notificationsSound = "notifications_sound"
            case orderPostsBy = "order_posts_by"
            case socialLogin = "social_login"
            case androidMDeviceID = "android_m_device_id"
            case iosMDeviceID = "ios_m_device_id"
            case androidNDeviceID = "android_n_device_id"
            case iosNDeviceID = "ios_n_device_id"
            case webDeviceID = "web_device_id"
            case wallet, lat, lng
            case lastLocationUpdate = "last_location_update"
            case shareMyLocation = "share_my_location"
            case lastDataUpdate = "last_data_update"
            case sidebarData = "sidebar_data"
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
            case avatarOrg = "avatar_org"
            case coverOrg = "cover_org"
            case coverFull = "cover_full"
            case id, url, name
            case lastseenUnixTime = "lastseen_unix_time"
            case lastseenStatus = "lastseen_status"
            case familyMember = "family_member"
            case isFollowing = "is_following"
            case avatarFull = "avatar_full"
        }
    }
    
    
   
}
class FollowUnFollowModel:BaseModel{
    struct FollowUnFollowSuccessModel: Codable {
        let apiStatus: Int?
        let followStatus: String?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case followStatus = "follow_status"
        }
    }
    struct FollowUnFollowErrorModel: Codable {
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
