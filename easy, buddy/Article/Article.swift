import Foundation

struct Article: Codable, Hashable {
    let userName: String
    let title: String
    let content: String
    let tag: String
    let postImage: PostImage
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case title
        case content
        case tag
        case postImage = "post_image"
        case url
    }
}

struct PostImage: Codable, Hashable {
    let url: String
    let thumb: ImageVariant
    let q70: ImageVariant
}

struct ImageVariant: Codable, Hashable {
    let url: String
}
