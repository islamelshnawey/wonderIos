
import Foundation
class GetUserListModel:BaseModel{
    struct GetUserListErrorModel: Codable {
        let apiStatus, apiText: String?
        let errors: Errors?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case apiText = "api_text"
            case errors
        }
    }
    struct Errors: Codable {
        let errorID, errorText: String?
        enum CodingKeys: String, CodingKey {
            case errorID = "error_id"
            case errorText = "error_text"
        }
    }
    struct GetUserListSuccessModel: Codable {
        let apiStatus: Int?
        var data: [Datum]?
        let videoCall: Bool?
//        let videoCallUser:[JSONAny]?
        let audioCall: Bool?
//        let audioCallUser: [JSONAny]?
        let agoraCall: Bool?
//        var agoraCallData:[JSONAny]?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case data
            case videoCall = "video_call"
//            case videoCallUser = "video_call_user"
            case audioCall = "audio_call"
//            case audioCallUser = "audio_call_user"
            case agoraCall = "agora_call"
//            case agoraCallData = "agora_call_data"
        }
    }
  
    struct AgoraCallData: Codable {
        let data: DataClass?
        let userID: String?
        let avatar: String?
        let name: String?
        
        enum CodingKeys: String, CodingKey {
            case data
            case userID = "user_id"
            case avatar, name
        }
    }
    
    // MARK: - DataClass
    struct DataClass: Codable {
        let id, fromID, toID, type: String?
        let roomName, time, status: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case fromID = "from_id"
            case toID = "to_id"
            case type
            case roomName = "room_name"
            case time, status
        }
    }
    struct Datum: Codable {
        let userID, username, email, password: String?
        let firstName, lastName: String?
        let avatar, cover: String?
        let backgroundImage, backgroundImageStatus, relationshipID, address: String?
        let working, workingLink, about, school: String?
        let gender, birthday, countryID, website: String?
        let facebook, google, twitter, linkedin: String?
        let youtube, vk, instagram: String?
        let language, emailCode, src, ipAddress: String?
        let followPrivacy, friendPrivacy, postPrivacy, messagePrivacy: String?
        let confirmFollowers, showActivitiesPrivacy, birthPrivacy, visitPrivacy: String?
        let verified, lastseen, showlastseen, emailNotification: String?
        let eLiked, eWondered, eShared, eFollowed: String?
        let eCommented, eVisited, eLikedPage, eMentioned: String?
        let eJoinedGroup, eAccepted, eProfileWallPost, eSentmeMsg: String?
        let eLastNotif, notificationSettings, status, active: String?
        let admin, type, registered, startUp: String?
        let startUpInfo, startupFollow, startupImage, lastEmailSent: String?
        let phoneNumber, smsCode, isPro, proTime: String?
        let proType, joined, cssFile, timezone: String?
        let referrer, refUserID, balance, paypalEmail: String?
        let notificationsSound, orderPostsBy, socialLogin, androidMDeviceID: String?
        let iosMDeviceID, androidNDeviceID, iosNDeviceID, webDeviceID: String?
        let wallet, lat, lng, lastLocationUpdate: String?
        let shareMyLocation, lastDataUpdate: String?
        let sidebarData, lastAvatarMod, lastCoverMod, points: String?
        let dailyPoints, pointDayExpire, lastFollowID, shareMyData: String?
        let twoFactor, newEmail, twoFactorVerified, newPhone: String?
        let infoFile, city, state, zip: String?
        let schoolCompleted, weatherUnit, paystackRef, codeSent: String?
        let timeCodeSent, avatarPostID: String?
        let coverPostID: Int?
        let avatarOrg, coverOrg, coverFull, avatarFull: String?
        let id, userPlatform: String?
        let url: String?
        let name: String?
        let apiNotificationSettings: [String: Int]?
        let isNotifyStopped: Int?
        let followingData, followersData: [String]?
        let mutualFriendsData, likesData: String?
        let groupsData: [String]?
        let albumData, lastseenUnixTime, lastseenStatus: String?
        let isReported, isStoryMuted: Bool?
        let isFollowingMe: Int?
        let chatTime, chatID, chatType: String?
        let lastMessage: LastMessage?
        let messageCount: String?

        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case username, email, password
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
            case timezone, referrer
            case refUserID = "ref_user_id"
            case balance
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
            case twoFactor = "two_factor"
            case newEmail = "new_email"
            case twoFactorVerified = "two_factor_verified"
            case newPhone = "new_phone"
            case infoFile = "info_file"
            case city, state, zip
            case schoolCompleted = "school_completed"
            case weatherUnit = "weather_unit"
            case paystackRef = "paystack_ref"
            case codeSent = "code_sent"
            case timeCodeSent = "time_code_sent"
            case avatarPostID = "avatar_post_id"
            case coverPostID = "cover_post_id"
            case avatarOrg = "avatar_org"
            case coverOrg = "cover_org"
            case coverFull = "cover_full"
            case avatarFull = "avatar_full"
            case id
            case userPlatform = "user_platform"
            case url, name
            case apiNotificationSettings = "API_notification_settings"
            case isNotifyStopped = "is_notify_stopped"
            case followingData = "following_data"
            case followersData = "followers_data"
            case mutualFriendsData = "mutual_friends_data"
            case likesData = "likes_data"
            case groupsData = "groups_data"
            case albumData = "album_data"
            case lastseenUnixTime = "lastseen_unix_time"
            case lastseenStatus = "lastseen_status"
            case isReported = "is_reported"
            case isStoryMuted = "is_story_muted"
            case isFollowingMe = "is_following_me"
            case chatTime = "chat_time"
            case chatID = "chat_id"
            case chatType = "chat_type"
            case lastMessage = "last_message"
            case messageCount = "message_count"
        }
    }
    struct messageUser: Codable {
        let userID, username, email, password: String?
        let firstName, lastName: String?
        let avatar, cover: String?
        let backgroundImage, backgroundImageStatus, relationshipID, address: String?
        let working, workingLink, about, school: String?
        let gender, birthday, countryID, website: String?
        let facebook, google, twitter, linkedin: String?
        let youtube, vk, instagram: String?
        let language, emailCode, src, ipAddress: String?
        let followPrivacy, friendPrivacy, postPrivacy, messagePrivacy: String?
        let confirmFollowers, showActivitiesPrivacy, birthPrivacy, visitPrivacy: String?
        let verified, lastseen, showlastseen, emailNotification: String?
        let eLiked, eWondered, eShared, eFollowed: String?
        let eCommented, eVisited, eLikedPage, eMentioned: String?
        let eJoinedGroup, eAccepted, eProfileWallPost, eSentmeMsg: String?
        let eLastNotif, notificationSettings, status, active: String?
        let admin, type, registered, startUp: String?
        let startUpInfo, startupFollow, startupImage, lastEmailSent: String?
        let phoneNumber, smsCode, isPro, proTime: String?
        let proType, joined, cssFile, timezone: String?
        let referrer, refUserID, balance, paypalEmail: String?
        let notificationsSound, orderPostsBy, socialLogin, androidMDeviceID: String?
        let iosMDeviceID, androidNDeviceID, iosNDeviceID, webDeviceID: String?
        let wallet, lat, lng, lastLocationUpdate: String?
        let shareMyLocation, lastDataUpdate: String?
        let sidebarData, lastAvatarMod, lastCoverMod, points: String?
        let dailyPoints, pointDayExpire, lastFollowID, shareMyData: String?
        let twoFactor, newEmail, twoFactorVerified, newPhone: String?
        let infoFile, city, state, zip: String?
        let schoolCompleted, weatherUnit, paystackRef, codeSent: String?
        let timeCodeSent, avatarPostID: String?
        let coverPostID: Int?
        let avatarOrg, coverOrg, coverFull, avatarFull: String?
        let id, userPlatform: String?
        let url: String?
        let name: String?
        let apiNotificationSettings: [String: Int]?
        let isNotifyStopped: Int?
        let followingData, followersData: [String]?
        let mutualFriendsData, likesData: String?
        let groupsData: [String]?
        let albumData, lastseenUnixTime, lastseenStatus: String?
        let isReported, isStoryMuted: Bool?
        let isFollowingMe: Int?
        let chatTime, chatID, chatType: String?
//        let lastMessage: LastMessage?
        let messageCount: String?

        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case username, email, password
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
            case timezone, referrer
            case refUserID = "ref_user_id"
            case balance
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
            case twoFactor = "two_factor"
            case newEmail = "new_email"
            case twoFactorVerified = "two_factor_verified"
            case newPhone = "new_phone"
            case infoFile = "info_file"
            case city, state, zip
            case schoolCompleted = "school_completed"
            case weatherUnit = "weather_unit"
            case paystackRef = "paystack_ref"
            case codeSent = "code_sent"
            case timeCodeSent = "time_code_sent"
            case avatarPostID = "avatar_post_id"
            case coverPostID = "cover_post_id"
            case avatarOrg = "avatar_org"
            case coverOrg = "cover_org"
            case coverFull = "cover_full"
            case avatarFull = "avatar_full"
            case id
            case userPlatform = "user_platform"
            case url, name
            case apiNotificationSettings = "API_notification_settings"
            case isNotifyStopped = "is_notify_stopped"
            case followingData = "following_data"
            case followersData = "followers_data"
            case mutualFriendsData = "mutual_friends_data"
            case likesData = "likes_data"
            case groupsData = "groups_data"
            case albumData = "album_data"
            case lastseenUnixTime = "lastseen_unix_time"
            case lastseenStatus = "lastseen_status"
            case isReported = "is_reported"
            case isStoryMuted = "is_story_muted"
            case isFollowingMe = "is_following_me"
            case chatTime = "chat_time"
            case chatID = "chat_id"
            case chatType = "chat_type"
//            case lastMessage = "last_message"
            case messageCount = "message_count"
        }
    }
//    struct User: Codable {
//        let userID, username, name: String?
//        let avatar, coverPicture: String?
//        let verified, lastseen, lastseenUnixTime, lastseenTimeText: String?
//        let url: String?
//        let chatColor, chatTime: String?
//        let lastMessage: LastMessage?
//
//        enum CodingKeys: String, CodingKey {
//            case userID = "user_id"
//            case username, name
//            case avatar = "avatar"
//            case coverPicture = "cover_picture"
//            case verified, lastseen
//            case lastseenUnixTime = "lastseen_unix_time"
//            case lastseenTimeText = "lastseen_time_text"
//            case url
//            case chatColor = "chat_color"
//            case chatTime = "chat_time"
//            case lastMessage = "last_message"
//        }
//    }
    struct TwilloAudioCallData: Codable {
        let data: TwilloAudioCallDataClass?
        let userID: String?
        let avatar: String?
        let name: String?
        
        enum CodingKeys: String, CodingKey {
            case data
            case userID = "user_id"
            case avatar, name
        }
    }
    
    // MARK: - DataClass
    struct TwilloAudioCallDataClass: Codable {
        let id, callID, accessToken, callID2: String?
        let accessToken2, fromID, toID, roomName: String?
        let active, called, time, declined: String?
        let url: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case callID = "call_id"
            case accessToken = "access_token"
            case callID2 = "call_id_2"
            case accessToken2 = "access_token_2"
            case fromID = "from_id"
            case toID = "to_id"
            case roomName = "room_name"
            case active, called, time, declined, url
        }
    }
  
    struct TwilloVideoCallData: Codable {
        let data: TwilloVideoCallDataClass?
        let userID: String?
        let avatar: String?
        let name: String?
        
        enum CodingKeys: String, CodingKey {
            case data
            case userID = "user_id"
            case avatar, name
        }
    }
    
    struct TwilloVideoCallDataClass: Codable {
        let id, accessToken, accessToken2, fromID: String?
        let toID, roomName, active, called: String?
        let time, declined: String?
        let url: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case accessToken = "access_token"
            case accessToken2 = "access_token_2"
            case fromID = "from_id"
            case toID = "to_id"
            case roomName = "room_name"
            case active, called, time, declined, url
        }
    }
    
//    struct LastMessage: Codable {
//        let id, fromID, groupID, toID: String?
//        let text, media, mediaFileName, mediaFileNames: String?
//        let time, seen, deletedOne, deletedTwo: String?
//        let sentPush, notificationID, typeTwo, stickers: String?
//        let dateTime: String?
//        let productId: String
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
//            case stickers
//            case dateTime = "date_time"
//            case productId = "product_id"
//            case lat = "lat"
//            case long = "lng"
//        }
//    }
        
//
        
        struct LastMessage: Codable {
            let id, fromID, groupID, pageID: String?
            let toID, text, media, mediaFileName: String?
            let mediaFileNames, time, seen, deletedOne: String?
            let deletedTwo, sentPush, notificationID, typeTwo: String?
            let productId: String?
            let stickers, lat, lng: String?
            let replyID, storyID, broadcastID, forward: String?
            let messageUser: messageUser?
            let onwer: Int?
            let timeText, position, type: String?
            let fileSize: Int?
            let chatColor: String?

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
                case productId = "product_id"
                case lat, lng
                case replyID = "reply_id"
                case storyID = "story_id"
                case broadcastID = "broadcast_id"
                case forward, messageUser, onwer
                case timeText = "time_text"
                case position, type
                case fileSize = "file_size"
                case chatColor = "chat_color"
            }
        }

}
struct CallDataModel: Codable {
    let agoraCallData: AgoraCallData?
    enum CodingKeys: String, CodingKey {
        case agoraCallData = "agora_call_data"
    }
}

// MARK: - AgoraCallData
struct AgoraCallData: Codable {
    let data: DataClass?
    let userID: String?
    let avatar: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case data
        case userID = "user_id"
        case avatar, name
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let id, fromID, toID, type: String?
    let roomName, time, status: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fromID = "from_id"
        case toID = "to_id"
        case type
        case roomName = "room_name"
        case time, status
    }
}
