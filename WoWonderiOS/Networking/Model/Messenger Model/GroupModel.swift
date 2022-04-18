

import Foundation
class FetchGroupModel:BaseModel{
    // MARK: - Welcome
    struct FetchGroupSuccessModel: Codable {
        let apiStatus: Int?
        let data: [Datum]?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case data
        }
    }
    
    // MARK: - Datum
    struct Datum: Codable {
        let groupID, userID, groupName: String?
        let avatar: String?
        let time: String?
        let userData: UserData?
        let owner: Bool?
        let parts: [UserData]?
        let lastSeen: [JSONAny]?
        let chatTime: String?
        
        enum CodingKeys: String, CodingKey {
            case groupID = "group_id"
            case userID = "user_id"
            case groupName = "group_name"
            case avatar, time
            case userData = "user_data"
            case owner
            case parts
            case lastSeen = "last_seen"
            case chatTime = "chat_time"
        }
    }
    
    // MARK: - UserData
    struct UserData: Codable {
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
        let timezone, referrer, refUserID, balance: String?
        let paypalEmail, notificationsSound, orderPostsBy, androidMDeviceID: String?
        let iosMDeviceID, androidNDeviceID, iosNDeviceID, webDeviceID: String?
        let wallet, lat, lng, lastLocationUpdate: String?
        let shareMyLocation, lastDataUpdate: String?
        let details: Details?
        let lastAvatarMod, lastCoverMod, points, dailyPoints: String?
        let pointDayExpire, lastFollowID, shareMyData, lastLoginData: String?
        let twoFactor, newEmail, twoFactorVerified, newPhone: String?
        let infoFile, city, state, zip: String?
        let schoolCompleted, weatherUnit: String?
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
    struct FetchGroupErrorModel: Codable {
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
    
    class JSONCodingKey: CodingKey {
        let key: String
        
        required init?(intValue: Int) {
            return nil
        }
        
        required init?(stringValue: String) {
            key = stringValue
        }
        
        var intValue: Int? {
            return nil
        }
        
        var stringValue: String {
            return key
        }
    }
    
    class JSONAny: Codable {
        
        let value: Any
        
        static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
            return DecodingError.typeMismatch(JSONAny.self, context)
        }
        
        static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
            return EncodingError.invalidValue(value, context)
        }
        
        static func decode(from container: SingleValueDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                return value
            }
            if let value = try? container.decode(Int64.self) {
                return value
            }
            if let value = try? container.decode(Double.self) {
                return value
            }
            if let value = try? container.decode(String.self) {
                return value
            }
            if container.decodeNil() {
                return JSONNull()
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                return value
            }
            if let value = try? container.decode(Int64.self) {
                return value
            }
            if let value = try? container.decode(Double.self) {
                return value
            }
            if let value = try? container.decode(String.self) {
                return value
            }
            if let value = try? container.decodeNil() {
                if value {
                    return JSONNull()
                }
            }
            if var container = try? container.nestedUnkeyedContainer() {
                return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
                return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
            if let value = try? container.decode(Bool.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(Int64.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(Double.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(String.self, forKey: key) {
                return value
            }
            if let value = try? container.decodeNil(forKey: key) {
                if value {
                    return JSONNull()
                }
            }
            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
                return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
            var arr: [Any] = []
            while !container.isAtEnd {
                let value = try decode(from: &container)
                arr.append(value)
            }
            return arr
        }
        
        static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
            var dict = [String: Any]()
            for key in container.allKeys {
                let value = try decode(from: &container, forKey: key)
                dict[key.stringValue] = value
            }
            return dict
        }
        
        static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
            for value in array {
                if let value = value as? Bool {
                    try container.encode(value)
                } else if let value = value as? Int64 {
                    try container.encode(value)
                } else if let value = value as? Double {
                    try container.encode(value)
                } else if let value = value as? String {
                    try container.encode(value)
                } else if value is JSONNull {
                    try container.encodeNil()
                } else if let value = value as? [Any] {
                    var container = container.nestedUnkeyedContainer()
                    try encode(to: &container, array: value)
                } else if let value = value as? [String: Any] {
                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                    try encode(to: &container, dictionary: value)
                } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
                }
            }
        }
        
        static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
            for (key, value) in dictionary {
                let key = JSONCodingKey(stringValue: key)!
                if let value = value as? Bool {
                    try container.encode(value, forKey: key)
                } else if let value = value as? Int64 {
                    try container.encode(value, forKey: key)
                } else if let value = value as? Double {
                    try container.encode(value, forKey: key)
                } else if let value = value as? String {
                    try container.encode(value, forKey: key)
                } else if value is JSONNull {
                    try container.encodeNil(forKey: key)
                } else if let value = value as? [Any] {
                    var container = container.nestedUnkeyedContainer(forKey: key)
                    try encode(to: &container, array: value)
                } else if let value = value as? [String: Any] {
                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                    try encode(to: &container, dictionary: value)
                } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
                }
            }
        }
        
        static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
        
        public required init(from decoder: Decoder) throws {
            if var arrayContainer = try? decoder.unkeyedContainer() {
                self.value = try JSONAny.decodeArray(from: &arrayContainer)
            } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
                self.value = try JSONAny.decodeDictionary(from: &container)
            } else {
                let container = try decoder.singleValueContainer()
                self.value = try JSONAny.decode(from: container)
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            if let arr = self.value as? [Any] {
                var container = encoder.unkeyedContainer()
                try JSONAny.encode(to: &container, array: arr)
            } else if let dict = self.value as? [String: Any] {
                var container = encoder.container(keyedBy: JSONCodingKey.self)
                try JSONAny.encode(to: &container, dictionary: dict)
            } else {
                var container = encoder.singleValueContainer()
                try JSONAny.encode(to: &container, value: self.value)
            }
        }
    }

}
class CreateGroupModel1:BaseModel{
    struct CreateGroupSuccessModel: Codable {
        let apiStatus: Int?
        let data: [Datum]?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case data
        }
    }
    
    // MARK: - Datum
    struct Datum: Codable {
        let groupID, userID, groupName: String?
        let avatar: String?
        let time: String?
        let userData: UserData?
        let owner: Bool?
        let parts: [UserData]?
        let lastSeen: String?
        
        enum CodingKeys: String, CodingKey {
            case groupID = "group_id"
            case userID = "user_id"
            case groupName = "group_name"
            case avatar, time
            case userData = "user_data"
            case owner
            case parts
            case lastSeen = "last_seen"
        }
    }
    
    // MARK: - UserData
    struct UserData: Codable {
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
        let timezone, referrer, refUserID, balance: String?
        let paypalEmail, notificationsSound, orderPostsBy, androidMDeviceID: String?
        let iosMDeviceID, androidNDeviceID, iosNDeviceID, webDeviceID: String?
        let wallet, lat, lng, lastLocationUpdate: String?
        let shareMyLocation, lastDataUpdate: String?
        let details: Details?
        let lastAvatarMod, lastCoverMod, points, dailyPoints: String?
        let pointDayExpire, lastFollowID, shareMyData, lastLoginData: String?
        let twoFactor, newEmail, twoFactorVerified, newPhone: String?
        let infoFile, city, state, zip: String?
        let schoolCompleted, weatherUnit: String?
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
    struct CreateGroupErrorModel: Codable {
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
    
    class JSONCodingKey: CodingKey {
        let key: String
        
        required init?(intValue: Int) {
            return nil
        }
        
        required init?(stringValue: String) {
            key = stringValue
        }
        
        var intValue: Int? {
            return nil
        }
        
        var stringValue: String {
            return key
        }
    }
    
    class JSONAny: Codable {
        
        let value: Any
        
        static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
            return DecodingError.typeMismatch(JSONAny.self, context)
        }
        
        static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
            return EncodingError.invalidValue(value, context)
        }
        
        static func decode(from container: SingleValueDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                return value
            }
            if let value = try? container.decode(Int64.self) {
                return value
            }
            if let value = try? container.decode(Double.self) {
                return value
            }
            if let value = try? container.decode(String.self) {
                return value
            }
            if container.decodeNil() {
                return JSONNull()
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                return value
            }
            if let value = try? container.decode(Int64.self) {
                return value
            }
            if let value = try? container.decode(Double.self) {
                return value
            }
            if let value = try? container.decode(String.self) {
                return value
            }
            if let value = try? container.decodeNil() {
                if value {
                    return JSONNull()
                }
            }
            if var container = try? container.nestedUnkeyedContainer() {
                return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
                return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
            if let value = try? container.decode(Bool.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(Int64.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(Double.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(String.self, forKey: key) {
                return value
            }
            if let value = try? container.decodeNil(forKey: key) {
                if value {
                    return JSONNull()
                }
            }
            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
                return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
            var arr: [Any] = []
            while !container.isAtEnd {
                let value = try decode(from: &container)
                arr.append(value)
            }
            return arr
        }
        
        static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
            var dict = [String: Any]()
            for key in container.allKeys {
                let value = try decode(from: &container, forKey: key)
                dict[key.stringValue] = value
            }
            return dict
        }
        
        static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
            for value in array {
                if let value = value as? Bool {
                    try container.encode(value)
                } else if let value = value as? Int64 {
                    try container.encode(value)
                } else if let value = value as? Double {
                    try container.encode(value)
                } else if let value = value as? String {
                    try container.encode(value)
                } else if value is JSONNull {
                    try container.encodeNil()
                } else if let value = value as? [Any] {
                    var container = container.nestedUnkeyedContainer()
                    try encode(to: &container, array: value)
                } else if let value = value as? [String: Any] {
                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                    try encode(to: &container, dictionary: value)
                } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
                }
            }
        }
        
        static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
            for (key, value) in dictionary {
                let key = JSONCodingKey(stringValue: key)!
                if let value = value as? Bool {
                    try container.encode(value, forKey: key)
                } else if let value = value as? Int64 {
                    try container.encode(value, forKey: key)
                } else if let value = value as? Double {
                    try container.encode(value, forKey: key)
                } else if let value = value as? String {
                    try container.encode(value, forKey: key)
                } else if value is JSONNull {
                    try container.encodeNil(forKey: key)
                } else if let value = value as? [Any] {
                    var container = container.nestedUnkeyedContainer(forKey: key)
                    try encode(to: &container, array: value)
                } else if let value = value as? [String: Any] {
                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                    try encode(to: &container, dictionary: value)
                } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
                }
            }
        }
        
        static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
        
        public required init(from decoder: Decoder) throws {
            if var arrayContainer = try? decoder.unkeyedContainer() {
                self.value = try JSONAny.decodeArray(from: &arrayContainer)
            } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
                self.value = try JSONAny.decodeDictionary(from: &container)
            } else {
                let container = try decoder.singleValueContainer()
                self.value = try JSONAny.decode(from: container)
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            if let arr = self.value as? [Any] {
                var container = encoder.unkeyedContainer()
                try JSONAny.encode(to: &container, array: arr)
            } else if let dict = self.value as? [String: Any] {
                var container = encoder.container(keyedBy: JSONCodingKey.self)
                try JSONAny.encode(to: &container, dictionary: dict)
            } else {
                var container = encoder.singleValueContainer()
                try JSONAny.encode(to: &container, value: self.value)
            }
        }
    }
}


class GroupChatModel:BaseModel{

    struct GroupChatSuccessModel: Codable {
        let apiStatus: Int?
        let data: DataClass?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case data
        }
    }
    
    // MARK: - DataClass
    struct DataClass: Codable {
        let groupID, userID, groupName: String?
        let avatar: String?
        let time: String?
        let messages: [Message]?
        
        enum CodingKeys: String, CodingKey {
            case groupID = "group_id"
            case userID = "user_id"
            case groupName = "group_name"
            case avatar, time, messages
        }
    }
    
    // MARK: - Message
    struct Message: Codable {
        let id, fromID, groupID, pageID: String?
        let toID, text: String?
        let media: String?
        let mediaFileName, mediaFileNames, time, seen: String?
        let deletedOne, deletedTwo, sentPush, notificationID: String?
        let typeTwo, stickers, productID: String?
        let userData: UserData?
        let orginalText: String?
        let onwer: Int?
        let timeText, position, type: String?
        
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
            case userData = "user_data"
            case orginalText = "orginal_text"
            case onwer
            case timeText = "time_text"
            case position, type
        }
    }
    
    enum FileSize: Codable {
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
            throw DecodingError.typeMismatch(FileSize.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for FileSize"))
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
    
    // MARK: - UserData
    struct UserData: Codable {
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
        let timezone, referrer, refUserID, balance: String?
        let paypalEmail, notificationsSound, orderPostsBy, androidMDeviceID: String?
        let iosMDeviceID, androidNDeviceID, iosNDeviceID, webDeviceID: String?
        let wallet, lat, lng, lastLocationUpdate: String?
        let shareMyLocation, lastDataUpdate: String?
        let details: Details?
        let lastAvatarMod, lastCoverMod, points, dailyPoints: String?
        let pointDayExpire, lastFollowID, shareMyData, lastLoginData: String?
        let twoFactor, newEmail, twoFactorVerified, newPhone: String?
        let infoFile, city, state, zip: String?
        let schoolCompleted, weatherUnit: String?
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

   
    struct GroupChatErrorModel: Codable {
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
class LeaveGroupModel:BaseModel{
    struct LeaveGroupSuccessModel: Codable {
        let apiStatus: Int?
        let messageData: String?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case messageData = "message_data"
        }
    }

    struct LeaveGroupErrorModel: Codable {
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
class DeleteGroupModel1:BaseModel{
    struct DeleteGroupSuccessModel: Codable {
        let apiStatus: Int?
        let messageData: String?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case messageData = "message_data"
        }
    }
    
    struct DeleteGroupErrorModel: Codable {
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
class AddUserToGroupModel:BaseModel{
    struct AddUserToGroupSuccessModel: Codable {
        let apiStatus: Int?
        let messageData: String?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case messageData = "message_data"
        }
    }
    
    struct AddUserToGroupErrorModel: Codable {
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
class UpdateGroupModel:BaseModel{
    struct CreateGroupSuccessModel: Codable {
        let apiStatus: Int?
        let data: [Datum]?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case data
        }
    }
    
    // MARK: - Datum
    struct Datum: Codable {
        let groupID, userID, groupName: String?
        let avatar: String?
        let time: String?
        let userData: UserData?
        let owner: Bool?
        let parts: [UserData]?
        let lastSeen: [JSONAny]?
        
        enum CodingKeys: String, CodingKey {
            case groupID = "group_id"
            case userID = "user_id"
            case groupName = "group_name"
            case avatar, time
            case userData = "user_data"
            case owner
            case parts
            case lastSeen = "last_seen"
        }
    }
    // MARK: - UserData
    struct UserData: Codable {
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
        let timezone, referrer, refUserID, balance: String?
        let paypalEmail, notificationsSound, orderPostsBy, androidMDeviceID: String?
        let iosMDeviceID, androidNDeviceID, iosNDeviceID, webDeviceID: String?
        let wallet, lat, lng, lastLocationUpdate: String?
        let shareMyLocation, lastDataUpdate: String?
        let details: Details?
        let lastAvatarMod, lastCoverMod, points, dailyPoints: String?
        let pointDayExpire, lastFollowID, shareMyData, lastLoginData: String?
        let twoFactor, newEmail, twoFactorVerified, newPhone: String?
        let infoFile, city, state, zip: String?
        let schoolCompleted, weatherUnit: String?
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
    struct UpdateGroupErrorModel: Codable {
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
    
    class JSONCodingKey: CodingKey {
        let key: String
        
        required init?(intValue: Int) {
            return nil
        }
        
        required init?(stringValue: String) {
            key = stringValue
        }
        
        var intValue: Int? {
            return nil
        }
        
        var stringValue: String {
            return key
        }
    }
    
    class JSONAny: Codable {
        
        let value: Any
        
        static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
            return DecodingError.typeMismatch(JSONAny.self, context)
        }
        
        static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
            return EncodingError.invalidValue(value, context)
        }
        
        static func decode(from container: SingleValueDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                return value
            }
            if let value = try? container.decode(Int64.self) {
                return value
            }
            if let value = try? container.decode(Double.self) {
                return value
            }
            if let value = try? container.decode(String.self) {
                return value
            }
            if container.decodeNil() {
                return JSONNull()
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                return value
            }
            if let value = try? container.decode(Int64.self) {
                return value
            }
            if let value = try? container.decode(Double.self) {
                return value
            }
            if let value = try? container.decode(String.self) {
                return value
            }
            if let value = try? container.decodeNil() {
                if value {
                    return JSONNull()
                }
            }
            if var container = try? container.nestedUnkeyedContainer() {
                return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
                return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
            if let value = try? container.decode(Bool.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(Int64.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(Double.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(String.self, forKey: key) {
                return value
            }
            if let value = try? container.decodeNil(forKey: key) {
                if value {
                    return JSONNull()
                }
            }
            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
                return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
            var arr: [Any] = []
            while !container.isAtEnd {
                let value = try decode(from: &container)
                arr.append(value)
            }
            return arr
        }
        
        static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
            var dict = [String: Any]()
            for key in container.allKeys {
                let value = try decode(from: &container, forKey: key)
                dict[key.stringValue] = value
            }
            return dict
        }
        
        static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
            for value in array {
                if let value = value as? Bool {
                    try container.encode(value)
                } else if let value = value as? Int64 {
                    try container.encode(value)
                } else if let value = value as? Double {
                    try container.encode(value)
                } else if let value = value as? String {
                    try container.encode(value)
                } else if value is JSONNull {
                    try container.encodeNil()
                } else if let value = value as? [Any] {
                    var container = container.nestedUnkeyedContainer()
                    try encode(to: &container, array: value)
                } else if let value = value as? [String: Any] {
                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                    try encode(to: &container, dictionary: value)
                } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
                }
            }
        }
        
        static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
            for (key, value) in dictionary {
                let key = JSONCodingKey(stringValue: key)!
                if let value = value as? Bool {
                    try container.encode(value, forKey: key)
                } else if let value = value as? Int64 {
                    try container.encode(value, forKey: key)
                } else if let value = value as? Double {
                    try container.encode(value, forKey: key)
                } else if let value = value as? String {
                    try container.encode(value, forKey: key)
                } else if value is JSONNull {
                    try container.encodeNil(forKey: key)
                } else if let value = value as? [Any] {
                    var container = container.nestedUnkeyedContainer(forKey: key)
                    try encode(to: &container, array: value)
                } else if let value = value as? [String: Any] {
                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                    try encode(to: &container, dictionary: value)
                } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
                }
            }
        }
        
        static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
        
        public required init(from decoder: Decoder) throws {
            if var arrayContainer = try? decoder.unkeyedContainer() {
                self.value = try JSONAny.decodeArray(from: &arrayContainer)
            } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
                self.value = try JSONAny.decodeDictionary(from: &container)
            } else {
                let container = try decoder.singleValueContainer()
                self.value = try JSONAny.decode(from: container)
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            if let arr = self.value as? [Any] {
                var container = encoder.unkeyedContainer()
                try JSONAny.encode(to: &container, array: arr)
            } else if let dict = self.value as? [String: Any] {
                var container = encoder.container(keyedBy: JSONCodingKey.self)
                try JSONAny.encode(to: &container, dictionary: dict)
            } else {
                var container = encoder.singleValueContainer()
                try JSONAny.encode(to: &container, value: self.value)
            }
        }
    }
}
class SendMessageToGroupModel:BaseModel{
  
    struct SendMessageToGroupSuccessModel: Codable {
        let apiStatus: Int?
        let data: [Datum]?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case data
        }
    }
    
    // MARK: - Datum
    struct Datum: Codable {
        let id, fromID, groupID, pageID: String?
        let toID, text, media, mediaFileName: String?
        let mediaFileNames, time, seen, deletedOne: String?
        let deletedTwo, sentPush, notificationID, typeTwo: String?
        let stickers, productID: String?
        let userData: UserData?
        let onwer: Int?
        let timeText, position, type: String?
        let messageHashID: String?
        
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
            case userData = "user_data"
            case onwer
            case timeText = "time_text"
            case position, type
            case messageHashID = "message_hash_id"
        }
    }
    
    // MARK: - UserData
    struct UserData: Codable {
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
        let proType, timezone, referrer, refUserID: String?
        let balance, paypalEmail, notificationsSound, orderPostsBy: String?
        let androidMDeviceID, iosMDeviceID, androidNDeviceID, iosNDeviceID: String?
        let webDeviceID, wallet, lat, lng: String?
        let lastLocationUpdate, shareMyLocation, lastDataUpdate: String?
        let details: Details?
        let lastAvatarMod, lastCoverMod, points, dailyPoints: String?
        let pointDayExpire, lastFollowID, shareMyData, lastLoginData: String?
        let twoFactor, newEmail, twoFactorVerified, newPhone: String?
        let infoFile, city, state, zip: String?
        let schoolCompleted, weatherUnit, avatarFull: String?
        let url: String?
        let name: String?
        let mutualFriendsData: [String]? = nil
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
            case avatarFull = "avatar_full"
            case url, name
            case mutualFriendsData = "mutual_friends_data"
            case lastseenUnixTime = "lastseen_unix_time"
            case lastseenStatus = "lastseen_status"
        }
    }
    
    // MARK: - Details
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
    struct SendMessageToGroupErrorModel: Codable {
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
