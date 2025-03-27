import Foundation
import UIKit

struct Signup {
    struct Request: Encodable {
        var user: User
        var profile: Profile
        
        struct User: Encodable {
            var email: String
            var password: String
            var passwordConfirmation: String
            var userRole: String
            
            enum CodingKeys: String, CodingKey {
                case email
                case password
                case passwordConfirmation = "password_confirmation"
                case userRole = "user_role"
            }
        }

        struct Profile: Encodable {
            var firstName: String
            var lastName: String
            var dateOfBirth: String
            var faculty: String
            var country: String
            var languages: String
            var programType: String
            var profilePhoto: String? // Опциональное поле для фотографии профиля

            enum CodingKeys: String, CodingKey {
                case firstName = "first_name"
                case lastName = "last_name"
                case dateOfBirth = "date_of_birth"
                case faculty
                case country
                case languages
                case programType = "program_type"
                case profilePhoto = "profile_photo"
            }
        }
    }

    struct Response: Decodable {
        let messages: String
        let isSuccess: Bool
        let jwt: String
        
        enum CodingKeys: String, CodingKey {
            case messages
            case isSuccess = "is_success"
            case jwt
        }
    }
}



final class ViewModel: ObservableObject {
    enum Const {
        static let tokenKey = "token"
    }
    
    @Published var email: String = ""
    @Published var gotToken: Bool = {
        let keychain = KeychainService()
        let token = keychain.getString(forKey: Const.tokenKey)
        
        print("Инициализация ViewModel, токен: \(token ?? "nil")")
        
        return token != nil && !token!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }()
    private var worker = AuthWorker()
    let keychain = KeychainService()
    func clearToken() {
        keychain.removeData(forKey: Const.tokenKey)
        DispatchQueue.main.async {
            self.gotToken = false
        }
        print("Токен удалён, новое значение gotToken = \(gotToken)")
    }
    func signUp(
        email: String,
        password: String,
        passwordConfirmation: String,
        firstName: String,
        lastName: String,
        dateOfBirth: String,
        faculty: String,
        country: String,
        languages: String,
        programType: String,
        profilePhoto: UIImage?,
        authenticityToken: String
    ) {
        print("SignUp function called")
        let boundary = UUID().uuidString
        var body = Data()

        // Добавляем данные пользователя
        func appendText(_ text: String, forKey key: String) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(text)\r\n".data(using: .utf8)!)
        }

        // Добавляем authenticity_token
        appendText(authenticityToken, forKey: "authenticity_token")

        // Основные данные пользователя
        appendText(email, forKey: "user[email]")
        appendText(password, forKey: "user[password]")
        appendText(passwordConfirmation, forKey: "user[password_confirmation]")
        appendText("buddy", forKey: "user[user_role]")

        // Данные профиля
        appendText(firstName, forKey: "user[profile_attributes][first_name]")
        appendText(lastName, forKey: "user[profile_attributes][last_name]")
        appendText(dateOfBirth, forKey: "user[profile_attributes][date_of_birth]")
        appendText(faculty, forKey: "user[profile_attributes][faculty]")
        appendText(country, forKey: "user[profile_attributes][country]")
        appendText(languages, forKey: "user[profile_attributes][languages]")
        appendText(programType, forKey: "user[profile_attributes][program_type]")

        // Добавляем изображение, если оно есть
        if let profilePhoto = profilePhoto, let imageData = profilePhoto.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"user[profile_attributes][profile_photo]\"; filename=\"profile.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }

        // Завершаем тело запроса
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        // Создаем запрос
        var request = URLRequest(url: URL(string: "http://127.0.0.1:3000/api/v1/sign_up")!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = body

        print("Sending request to: \(request.url?.absoluteString ?? "Invalid URL")")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }

            let jsonString = String(data: data, encoding: .utf8) ?? "Invalid data"
            print("Received JSON: \(jsonString)")

            do {
                let response = try JSONDecoder().decode(Signup.Response.self, from: data)
                let token = response.jwt
                print("Decoded token: \(token)")
                self?.keychain.setString(token, forKey: Const.tokenKey)
                DispatchQueue.main.async {
                    self?.gotToken = true
                }
            } catch {
                print("Failed to decode response: \(error)")
                if let errorResponse = try? JSONDecoder().decode([String: [String]].self, from: data) {
                    print("Error details: \(errorResponse)")
                }
            }
        }.resume()
    }
    
    func signIn(
        login: String,
        password: String
    ) {
        let endpoint = AuthEndpoint.signin
        let requestData = Signin.Request(
            email: login,
            password: password
        )
        
        let body = try? JSONEncoder().encode(requestData)
        let request = Request(endpoint: endpoint, method: .post, body: body)
        print("Sending request to: \(worker.worker.baseUrl)\(endpoint.compositePath)")
        worker.load(request: request) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                if let data {
                    let jsonString = String(data: data, encoding: .utf8) ?? "Invalid data"
                    print("Received JSON: \(jsonString)")
                    if let response = try? JSONDecoder().decode(Signin.Response.self, from: data) {
                        let token = response.jwt
                        print("Decoded token: \(token)")
                        self?.keychain.setString(token, forKey: Const.tokenKey)
                        DispatchQueue.main.async {
                            self?.gotToken = true
                        }
                    } else {
                        print("Failed to decode token")
                    }
                } else {
                    print("No data received")
                }
            }
        }
    }
    
    func getUsers() {
        let token = keychain.getString(forKey: Const.tokenKey) ?? ""
        let request = Request(endpoint: AuthEndpoint.users(token: token))
        print("Sending request to: \(worker.worker.baseUrl)\(request.endpoint.compositePath)")
        worker.load(request: request) { result in
            switch result {
            case .failure(_):
                print("error")
            case .success(let data):
                guard let data else {
                    print("error")
                    return
                }
                print(String(data: data, encoding: .utf8))
            }
        }
    }
}

enum AuthEndpoint: Endpoint {
    case signup
    case signin
    case users(token: String)
    
    var rawValue: String {
        switch self {
        case .signup:
            return "sign_up"
        case .signin:
            return "sign_in"
        case .users:
            return "posts"
        }
    }
    
    var compositePath: String {
        return "/api/v1/\(self.rawValue)"
    }
    
    var headers: [String: String] {
        switch self {
        case .users(let token): ["Authorization": "Bearer \(token)"]
        default: ["Content-Type": "application/json"]
        }
        
    }
}

final class AuthWorker {
    let worker = BaseURLWorker(baseUrl: "http://127.0.0.1:3000")
    
    func load(request: Request, completion: @escaping (Result<Data?, Error>) -> Void) {
        worker.executeRequest(with: request) { response in
            switch response {
            case .failure(let error):
                completion(.failure(error))
            case .success(let result):
                completion(.success(result.data))
            }
        }
    }
}
