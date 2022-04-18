



import Foundation
class SelectContactModel:BaseModel{
    
    
    struct SelectContactSuccessModel: Codable {
        let apiStatus: Int?
        let apiText, apiVersion: String?
        let themeURL: String?
        let users: [User]?
      
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case apiText = "api_text"
            case apiVersion = "api_version"
            case themeURL = "theme_url"
            case users
        }
    }
    struct SelectContactErrorModel: Codable {
        let apiStatus, apiText, apiVersion: String?
        let errors: Errors?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case apiText = "api_text"
            case apiVersion = "api_version"
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

    
    struct User: Codable {
        let userID, username, email, firstName: String?
        let lastName: String?
        let avatar: String?
        let cover: String?
        let relationshipID: String?
        let ipAddress, followPrivacy, friendPrivacy, postPrivacy: String?
        let messagePrivacy, confirmFollowers, showActivitiesPrivacy, birthPrivacy: String?
        let status, active, admin, registered: String?
        let  notificationsSound: String?
        let orderPostsBy, socialLogin, androidMDeviceID, iosMDeviceID: String?
        let androidNDeviceID, iosNDeviceID, webDeviceID, wallet: String?
        let lat, lng, lastLocationUpdate, shareMyLocation: String?
        let lastDataUpdate: String?
        let sidebarData: String?
        let lastAvatarMod, lastCoverMod, points, dailyPoints: String?
        let pointDayExpire, lastFollowID, shareMyData: String?
        let lastLoginData: String?
        let twoFactor, newEmail, twoFactorVerified, newPhone: String?
        let infoFile, avatarFull: String?
        let url: String?
        let name: String?
 
        let albumData, lastseenUnixTime: String?
   
   
        let isFollowing: Int?
         let userPlatform: String?
        
        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case username, email
            case firstName = "first_name"
            case lastName = "last_name"
            case avatar, cover
            case relationshipID = "relationship_id"
            case ipAddress = "ip_address"
            case followPrivacy = "follow_privacy"
            case friendPrivacy = "friend_privacy"
            case postPrivacy = "post_privacy"
            case messagePrivacy = "message_privacy"
            case confirmFollowers = "confirm_followers"
            case showActivitiesPrivacy = "show_activities_privacy"
            case birthPrivacy = "birth_privacy"
            case status, active, admin, registered
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
            case avatarFull = "avatar_full"
            case url, name
             case userPlatform = "user_platform"
            case albumData = "album_data"
            case lastseenUnixTime = "lastseen_unix_time"
            case isFollowing = "is_following"
        }
    }
    
    enum Address: String, Codable {
        case avcılarIstanbulTurkey = "Avcılar, Istanbul, Turkey"
        case empty = ""
    }
    
    struct Details: Codable {
        let postCount, albumCount, followingCount, followersCount: Count?
        let groupsCount, likesCount: Count?
        let mutualFriendsCount: Bool?
        
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
    
    enum Count: Codable {
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
            throw DecodingError.typeMismatch(Count.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Count"))
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
        case male = "male"
    }
    
    enum Google: String, Codable {
        case alidoughousadiga = "Alidoughousadiga"
        case empty = ""
    }
    
    enum Instagram: String, Codable {
        case empty = ""
        case wolfdarkman1992 = "wolfdarkman1992"
    }
    
    enum Language: String, Codable {
        case english = "english"
        case portuguese = "portuguese"
        case spanish = "spanish"
    }
    
    enum Lastseen: String, Codable {
        case off = "off"
    }
    
    enum Linkedin: String, Codable {
        case elindoughouz = "elindoughouz"
        case empty = ""
    }
    
    enum Timezone: String, Codable {
        case utc = "UTC"
    }
    
    enum Twitter: String, Codable {
        case elinDoughos = "Elin Doughos"
        case empty = ""
    }
    
    enum UserPlatform: String, Codable {
        case web = "web"
    }
    
    enum Working: String, Codable {
        case doughouzLight = "DoughouzLight"
        case empty = ""
    }
    
    enum Youtube: String, Codable {
        case empty = ""
        case uc2Rr6W4QbQCRGkTTxD4U2Q = "UC2Rr6w4QbQCRGk-TTxD4U2Q"
    }
    
    // MARK: Encode/decode helpers
    
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
