//
//  TrendingModel.swift
//  WoWonderiOS
//
//  Created by Abdul Moid on 18/06/2021.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation

class TrendingModel {
   
    // MARK: - TrendingModel_Error
    struct TrendingModel_Error: Codable {
        let apiStatus, apiText, apiVersion: String?
        let errors: Errors?

        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case apiText = "api_text"
            case apiVersion = "api_version"
            case errors
        }
    }

    // MARK: - Errors
    struct Errors: Codable {
        let errorID, errorText: String?

        enum CodingKeys: String, CodingKey {
            case errorID = "error_id"
            case errorText = "error_text"
        }
    }

    
    // MARK: - Welcome
    struct TrendingModel_Sucess: Codable {
        let apiStatus, apiText, apiVersion: String?
        let blogs: [Blog]?

        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case apiText = "api_text"
            case apiVersion = "api_version"
            case blogs
        }
    }

    // MARK: - Blog
    struct Blog: Codable {
        let id, user, title, blogDescription: String?
        let posted, category: String?
        let thumbnail: String?
        let view, shared, tags, active: String?
        let author: Author?
        let tagsArray: [String]?
        let url: String?
        let categoryLink: String?
        let categoryName: String?
        let isPostAdmin: Bool?
        let reaction: Reaction?

        enum CodingKeys: String, CodingKey {
            case id, user, title
            case blogDescription = "description"
            case posted, category, thumbnail, view, shared, tags, active, author
            case tagsArray = "tags_array"
            case url
            case categoryLink = "category_link"
            case categoryName = "category_name"
            case isPostAdmin = "is_post_admin"
            case reaction
        }
    }

    // MARK: - Author
    struct Author: Codable {
        let userID, username, email, firstName: String?
        let lastName: String?
        let avatar: String?
        let cover: String?
        let relationshipID: String?
        let address, working, workingLink: String?
        let about: String?
        let school: String?
        let gender: String?
        let birthday: String?
        let website, facebook: String?
        let google: String?
        let twitter, linkedin, youtube, vk: String?
        let instagram: String?
//        let qq, wechat, discord, mailru: JSONNull?
//        let language: Language?
        let ipAddress, followPrivacy, friendPrivacy: String?
//        let postPrivacy: PostPrivacy?
        let messagePrivacy, confirmFollowers, showActivitiesPrivacy, birthPrivacy: String?
        let visitPrivacy, verified, lastseen, showlastseen: String?
        let eSentmeMsg, eLastNotif, notificationSettings, status: String?
        let active, admin, registered, phoneNumber: String?
        let isPro, proType, joined: String?
        let timezone: String?
        let referrer, refUserID, balance, paypalEmail: String?
        let notificationsSound, orderPostsBy, socialLogin, androidMDeviceID: String?
        let iosMDeviceID, androidNDeviceID, iosNDeviceID, webDeviceID: String?
        let wallet, lat, lng, lastLocationUpdate: String?
        let shareMyLocation, lastDataUpdate: String?
        let details: Details?
        let sidebarData: String?
        let lastAvatarMod, lastCoverMod, points, dailyPoints: String?
        let pointDayExpire, lastFollowID, shareMyData: String?
//        let lastLoginData: JSONNull?
        let twoFactor, newEmail, twoFactorVerified, newPhone: String?
        let infoFile, city, state, zip: String?
        let schoolCompleted: String?
        let weatherUnit: String?
        let paystackRef, codeSent: String?
//        let stripeSessionID: JSONNull?
        let timeCodeSent: String?
//        let avatarPostID, coverPostID: AvatarPostID?
        let avatarFull: String?
        let userPlatform: String? = ""
        let url: String?
        let name: String?
        let apiNotificationSettings: [String: Int]?
        let isNotifyStopped: Int?
//        let followingData, followersData, mutualFriendsData: FollowersDataUnion?
//        let likesData: String?
//        let groupsData: FollowersDataUnion?
        let lastseenUnixTime: String?
//        let lastseenStatus: LastseenStatus?
        let isReported, isStoryMuted: Bool?

        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case username, email
            case firstName = "first_name"
            case lastName = "last_name"
            case avatar, cover
            case relationshipID = "relationship_id"
            case address, working
            case workingLink = "working_link"
            case about, school, gender, birthday, website, facebook, google, twitter, linkedin, youtube, vk, instagram
            case ipAddress = "ip_address"
            case followPrivacy = "follow_privacy"
            case friendPrivacy = "friend_privacy"
//            case postPrivacy = "post_privacy"
            case messagePrivacy = "message_privacy"
            case confirmFollowers = "confirm_followers"
            case showActivitiesPrivacy = "show_activities_privacy"
            case birthPrivacy = "birth_privacy"
            case visitPrivacy = "visit_privacy"
            case verified, lastseen, showlastseen
            case eSentmeMsg = "e_sentme_msg"
            case eLastNotif = "e_last_notif"
            case notificationSettings = "notification_settings"
            case status, active, admin, registered
            case phoneNumber = "phone_number"
            case isPro = "is_pro"
            case proType = "pro_type"
            case joined, timezone, referrer
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
            case details
            case sidebarData = "sidebar_data"
            case lastAvatarMod = "last_avatar_mod"
            case lastCoverMod = "last_cover_mod"
            case points
            case dailyPoints = "daily_points"
            case pointDayExpire = "point_day_expire"
            case lastFollowID = "last_follow_id"
            case shareMyData = "share_my_data"
//            case lastLoginData = "last_login_data"
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
//            case stripeSessionID = "StripeSessionId"
            case timeCodeSent = "time_code_sent"
//            case avatarPostID = "avatar_post_id"
//            case coverPostID = "cover_post_id"
            case avatarFull = "avatar_full"
            case userPlatform = "user_platform"
            case url, name
            case apiNotificationSettings = "API_notification_settings"
            case isNotifyStopped = "is_notify_stopped"
//            case followingData = "following_data"
//            case followersData = "followers_data"
//            case mutualFriendsData = "mutual_friends_data"
//            case likesData = "likes_data"
//            case groupsData = "groups_data"
//            case albumData = "album_data"
            case lastseenUnixTime = "lastseen_unix_time"
//            case lastseenStatus = "lastseen_status"
            case isReported = "is_reported"
            case isStoryMuted = "is_story_muted"
        }
    }

    enum AvatarPostID: Codable {
        case integer(Int)
        case string(String)

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let x = try? container.decode(Int.self) {
                self = .integer(x)
                return
            }
            if let x = try? container.decode(String.self) {
                self = .string(x)
                return
            }
            throw DecodingError.typeMismatch(AvatarPostID.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for AvatarPostID"))
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .integer(let x):
                try container.encode(x)
            case .string(let x):
                try container.encode(x)
            }
        }
    }

    // MARK: - Details
    struct Details: Codable {
        let postCount, albumCount, followingCount, followersCount: AvatarPostID?
        let groupsCount, likesCount: AvatarPostID?
        let mutualFriendsCount: MutualFriendsCount?

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

    enum MutualFriendsCount: Codable {
        case bool(Bool)
        case integer(Int)

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let x = try? container.decode(Bool.self) {
                self = .bool(x)
                return
            }
            if let x = try? container.decode(Int.self) {
                self = .integer(x)
                return
            }
            throw DecodingError.typeMismatch(MutualFriendsCount.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for MutualFriendsCount"))
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .bool(let x):
                try container.encode(x)
            case .integer(let x):
                try container.encode(x)
            }
        }
    }

    enum FollowersDataUnion: Codable {
        case string(String)
        case stringArray([String])

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let x = try? container.decode([String].self) {
                self = .stringArray(x)
                return
            }
            if let x = try? container.decode(String.self) {
                self = .string(x)
                return
            }
            throw DecodingError.typeMismatch(FollowersDataUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for FollowersDataUnion"))
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .string(let x):
                try container.encode(x)
            case .stringArray(let x):
                try container.encode(x)
            }
        }
    }

    enum Gender: String, Codable {
        case female = "female"
        case male = "male"
    }

    enum PostPrivacy: String, Codable {
        case ifollow = "ifollow"
    }

    enum Timezone: String, Codable {
        case utc = "UTC"
    }

    enum UserPlatform: String, Codable {
        case web = "web"
    }

    enum WeatherUnit: String, Codable {
        case us = "us"
    }

    // MARK: - Reaction
    struct Reaction: Codable {
        let isReacted: Bool?
        let type: String?
        let count, the1, the6, the2: Int?

        enum CodingKeys: String, CodingKey {
            case isReacted = "is_reacted"
            case type, count
            case the1 = "1"
            case the6 = "6"
            case the2 = "2"
        }
    }

    // MARK: - Encode/decode helpers

    class JSONNull: Codable, Hashable {

        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
        }

        public var hashValue: Int {
            return 0
        }

        public init() {}

        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }

    
}
