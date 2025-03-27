struct UserProfile: Codable, Identifiable {
    let id: Int
    let userId: Int
    var email: String?
    var dateOfBirth: String
    var faculty: String
    var country: String
    var languages: String
    var programType: String
    var firstName: String
    var lastName: String
    var profilePhotoUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case email
        case dateOfBirth = "date_of_birth"
        case faculty, country, languages
        case programType = "program_type"
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePhotoUrl = "profile_photo_url"
    }
}
