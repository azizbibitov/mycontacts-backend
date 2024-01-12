import Foundation

struct Contact: Identifiable, Codable {
    var id: String?
    var _id: String?
    var name: String?
    var email: String?
    var phone: String?
    
}

struct User: Codable {
    var id: String?
    var username: String?
    var email: String?
    var password: String?
}
