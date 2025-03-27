import Foundation

enum Signin {
    struct Request: Encodable {
        var user: User

        struct User: Encodable {  // Вложенная структура для пользователя
            var email: String
            var password: String
        }
        
        // Инициализатор
        init(email: String, password: String) {
            self.user = User(email: email, password: password)
        }
    }

    struct Response: Decodable {
        let messages: String
        let isSuccess: Bool
        let jwt: String  // Ключ "jwt" вместо "token"
        
        enum CodingKeys: String, CodingKey {
            case messages
            case isSuccess = "is_success"
            case jwt
        }
    }
}
