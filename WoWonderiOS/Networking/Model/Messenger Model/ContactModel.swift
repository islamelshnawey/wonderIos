
import Foundation

struct ContactModel: Codable {
    let key, value: String?
    
    enum CodingKeys: String, CodingKey {
        case key = "Key"
        case value = "Value"
    }
}

