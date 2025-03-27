import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var profile: UserProfile?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showAuthError = false
    @State private var isEditing = false
    @State private var editedProfile: UserProfile?
    
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if isLoading {
                    ProgressView()
                } else if let profile = isEditing ? editedProfile : self.profile {
                    if isEditing {
                        editProfileContent(profile)
                    } else {
                        viewProfileContent(profile)
                           
                        
                    }
                } else if let error = errorMessage {
                    errorContent(error)
                }
            }
        }
        .background(Color.background)
        .refreshable {
            await loadProfile()
        }
        .task {
            await loadProfile()
        }
        .alert("Ошибка авторизации", isPresented: $showAuthError) {
            Button("OK", role: .cancel) {
                viewModel.clearToken()
            }
        } message: {
            Text("Требуется повторная авторизация")
        }
    }
    
    private var editButton: some View {
        Button(action: {
            if isEditing {
                saveProfileChanges()
            } else {
                editedProfile = profile
                isEditing = true
            }
        }) {
            editprofileButton(text: isEditing ? "Save" : "Edit")
        }
        .disabled(profile == nil)
    }
    
    // MARK: - View Components
    @ViewBuilder
    private func viewProfileContent(_ profile: UserProfile) -> some View {
        VStack(spacing: 0) {
            HStack {
                H1(text: "Profile")
                    .frame(width: 180)
                Spacer()
                HStack {
                    editButton
                    
                    logoutButton()
                    
                }
                
                .padding(.bottom, 8)
            }
            .padding(.horizontal, 16)
            VStack(alignment: .leading, spacing: 16) {
                ViewThatFits {
                    HStack {
                        CustomTagProfile(text: "\(profile.programType)")
                        CustomTagProfile(text: "\(profile.faculty)")
                    }
                    HStack {
                        VStack (alignment: .leading) {
                            CustomTagProfile(text: "\(profile.programType)")
                            CustomTagProfile(text: "\(profile.faculty)")
                            
                        }
                        Spacer()
                    }
                    .frame(width:326)
                    
                }
               
                
                HStack {
                    profileImage(profile.profilePhotoUrl)
                        .frame(width: 122, height: 122) // Добавьте размеры для изображения
                    
                    VStack(alignment: .leading) {
                        H4(text: "\(profile.firstName) \(profile.lastName)")
                        p(text: "\(profile.email ?? "")")
                            .font(.custom("TTHoves-Medium", size: 14))
                            .foregroundColor(.greyscale500)
                        pTabs(text: "\(profile.languages.replacingOccurrences(of: ", ", with: " / "))")
                            .padding(.top, 16)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.white)
            )
            
        }
    }
    
    @ViewBuilder
    private func editProfileContent(_ profile: UserProfile) -> some View {
        VStack(spacing: 0) {
            HStack {
                H1(text: "Profile")
                    .frame(width: 180)
                Spacer()
                HStack {
                    editButton
                    Button(action: {
                        isEditing = false
                    }) {
                        logoutprofileButton(text: "Cancel")
                    }
                    
                }
                
                .padding(.bottom, 8)
            }
            .padding(.horizontal,16)
            VStack (spacing: 16){
                profileImage(profile.profilePhotoUrl)
                VStack {
                    HStack {
                        CustomTextField(
                            text: Binding<String>(
                                get: { editedProfile?.firstName ?? "" },
                                set: { editedProfile?.firstName = $0 }
                            ),
                            title: "First Name",
                            placeholder: "Your First name"
                        )
                        CustomTextField(
                            text: Binding<String>(
                                get: { editedProfile?.lastName ?? "" },
                                set: { editedProfile?.lastName = $0 }
                            ),
                            title: "Last Name",
                            placeholder: "Your last name"
                        )
                    }
                    FacultyPicker(
                        selectedOption: Binding<String>(
                            get: { editedProfile?.faculty ?? "" },
                            set: { editedProfile?.faculty = $0 }
                        )
                    )
                    CustomTextField(
                        text: Binding<String>(
                            get: { editedProfile?.country ?? "" },
                            set: { editedProfile?.country = $0 }
                        ),
                        title: "Country",
                        placeholder: "Your country"
                    )
                    CustomTextField(
                        text: Binding<String>(
                            get: { editedProfile?.languages ?? "" },
                            set: { editedProfile?.languages = $0 }
                        ),
                        title: "Languages",
                        placeholder: "Your languages"
                    )
                    let dateFormatter: DateFormatter = {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd.MM.yyyy"
                        return formatter
                    }()
                    
                    CustomCalendar(
                        selectedDate: Binding<Date>(
                            get: {
                                if let dateString = editedProfile?.dateOfBirth {
                                    return dateFormatter.date(from: dateString) ?? defaultDate
                                }
                                return defaultDate
                            },
                            set: {
                                editedProfile?.dateOfBirth = dateFormatter.string(from: $0)
                            }
                        )
                    )
                    
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.white)
            )
        }
    }
    private var defaultDate: Date {
        Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
    }
    
    @ViewBuilder
    private func profileImage(_ urlString: String?) -> some View {
        if let urlString = urlString, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 122, height: 122)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                case .failure:
                    defaultProfileImage()
                case .empty:
                    ProgressView()
                        .frame(width: 120, height: 120)
                @unknown default:
                    defaultProfileImage()
                }
            }
        } else {
            defaultProfileImage()
        }
    }
    
    private func defaultProfileImage() -> some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 120)
            .foregroundColor(.gray)
    }
    
    private func profileInfoSection(_ profile: UserProfile) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            InfoRow(title: "Факультет", value: profile.faculty)
            InfoRow(title: "Страна", value: profile.country)
            InfoRow(title: "Дата рождения", value: formattedDate(profile.dateOfBirth))
            InfoRow(title: "Языки", value: profile.languages)
            InfoRow(title: "Программа", value: profile.programType)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
    }
    
    private func logoutButton() -> some View {
        Button(action: {
            viewModel.clearToken()
        }) {
            logoutprofileButton(text: "Log out")
        }
    }
    
    @ViewBuilder
    private func errorContent(_ error: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.yellow)
            
            Text(error)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            logoutButton()
        }
        .padding()
    }
    
    // MARK: - Profile Editing Logic
    private func saveProfileChanges() {
        guard let editedProfile = editedProfile else { return }
        print(editedProfile)
        Task {
            await MainActor.run {
                isLoading = true
                errorMessage = nil
            }
            
            do {
                let updatedProfile = try await updateProfileOnServer(editedProfile)
                await MainActor.run {
                    self.profile = updatedProfile
                    isEditing = false
                }
            } catch {
                await handleError(error)
            }
            
            await MainActor.run {
                isLoading = false
            }
        }
    }
    
    private func updateProfileOnServer(_ updatedProfile: UserProfile) async throws -> UserProfile {
        // 1. Проверка токена
        guard let token = KeychainService().getString(forKey: ViewModel.Const.tokenKey) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Токен не найден"])
        }
        
        // 2. Формирование URL
        let urlString = "http://127.0.0.1:3000/api/v1/profiles/\(updatedProfile.id)"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Некорректный URL"])
        }
        
        // 3. Подготовка тела запроса в точном соответствии с Postman-примером
        let profileData: [String: Any] = [
            "first_name": updatedProfile.firstName,
            "last_name": updatedProfile.lastName,
            "languages": updatedProfile.languages,
            "date_of_birth": updatedProfile.dateOfBirth,
            "faculty": updatedProfile.faculty,
            "country": updatedProfile.country,
            "program_type": updatedProfile.programType
        ]
        
        let requestBody: [String: Any] = [
            "profile": profileData
        ]
        
        print("Отправляемые данные:", requestBody)
        
        // 4. Конвертация в JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
            throw NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "Ошибка создания JSON"])
        }
        
        // 5. Настройка запроса
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        // 6. Отправка запроса и обработка ответа
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NSError(domain: "", code: -4, userInfo: [NSLocalizedDescriptionKey: "Некорректный ответ сервера"])
            }
            
            print("Статус код:", httpResponse.statusCode)
            
            // Логирование сырого ответа для отладки
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Полученный ответ:", jsonString)
            }
            
            // Проверка статус кода
            if !(200...299).contains(httpResponse.statusCode) {
                if let errorInfo = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let errorMessage = errorInfo["message"] as? String ?? errorInfo["error"] as? String {
                    throw NSError(domain: "", code: httpResponse.statusCode,
                                  userInfo: [NSLocalizedDescriptionKey: errorMessage])
                }
                throw NSError(domain: "", code: httpResponse.statusCode,
                              userInfo: [NSLocalizedDescriptionKey: "HTTP ошибка: \(httpResponse.statusCode)"])
            }
            
            // 7. Гибкое декодирование ответа
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            // Вариант 1: Декодирование только необходимых полей
            struct ProfileResponse: Codable {
                let id: Int
                let firstName: String
                let lastName: String
                let faculty: String
                let country: String
                let languages: String
                let programType: String
                let dateOfBirth: String
            }
            
            let profileResponse = try decoder.decode(ProfileResponse.self, from: data)
            
            // Создаем обновленный UserProfile
            var resultProfile = updatedProfile
            resultProfile.firstName = profileResponse.firstName
            resultProfile.lastName = profileResponse.lastName
            resultProfile.faculty = profileResponse.faculty
            resultProfile.country = profileResponse.country
            resultProfile.languages = profileResponse.languages
            resultProfile.programType = profileResponse.programType
            resultProfile.dateOfBirth = profileResponse.dateOfBirth
            
            print("✅ Профиль успешно обновлен!")
            return resultProfile
            
        } catch {
            print("❌ Ошибка при обновлении профиля:", error)
            throw error
        }
    }
    
    // MARK: - Helper Functions
    private func formattedDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            formatter.dateStyle = .long
            return formatter.string(from: date)
        }
        return dateString
    }
    
    // MARK: - Network Functions
    private func loadProfile() async {
        guard let token = KeychainService().getString(forKey: ViewModel.Const.tokenKey) else {
            await handleAuthError("Токен не найден")
            return
        }
        
        guard let email = JWTDecoder.getUserEmailFromToken(token) else {
            await handleAuthError("Не удалось извлечь email из токена")
            return
        }
        
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let profile = try await fetchUserProfile(email: email, token: token)
            await MainActor.run {
                self.profile = profile
            }
        } catch {
            await handleError(error)
        }
        
        await MainActor.run {
            isLoading = false
        }
    }
    
    private func fetchUserProfile(email: String, token: String) async throws -> UserProfile {
        return try await withCheckedThrowingContinuation { continuation in
            let urlString = "http://127.0.0.1:3000/api/v1/profiles"
            guard let url = URL(string: urlString) else {
                continuation.resume(throwing: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Некорректный URL"]))
                return
            }
            
            var request = URLRequest(url: url)
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    continuation.resume(throwing: NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Сервер вернул ошибку"]))
                    return
                }
                
                guard let data = data else {
                    continuation.resume(throwing: NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "Нет данных в ответе"]))
                    return
                }
                
                do {
                    if let profiles = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                        if let profileDict = profiles.first(where: { $0["email"] as? String == email }) {
                            let jsonData = try JSONSerialization.data(withJSONObject: profileDict)
                            let profile = try JSONDecoder().decode(UserProfile.self, from: jsonData)
                            continuation.resume(returning: profile)
                        } else {
                            continuation.resume(throwing: NSError(domain: "", code: -4, userInfo: [NSLocalizedDescriptionKey: "Пользователь не найден"]))
                        }
                    } else {
                        continuation.resume(throwing: NSError(domain: "", code: -5, userInfo: [NSLocalizedDescriptionKey: "Неверный формат данных"]))
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
            
            task.resume()
        }
    }
    
    @MainActor
    private func handleAuthError(_ message: String) {
        errorMessage = message
        showAuthError = true
    }
    
    @MainActor
    private func handleError(_ error: Error) {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .userAuthenticationRequired:
                errorMessage = "Требуется авторизация"
                showAuthError = true
            default:
                errorMessage = "Ошибка сети: \(urlError.localizedDescription)"
            }
        } else {
            errorMessage = error.localizedDescription
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct JWTDecoder {
    static func getUserEmailFromToken(_ token: String) -> String? {
        let parts = token.components(separatedBy: ".")
        guard parts.count == 3 else { return nil }
        
        var payload = parts[1]
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let padding = payload.count % 4
        if padding > 0 {
            payload += String(repeating: "=", count: 4 - padding)
        }
        
        guard let data = Data(base64Encoded: payload),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let email = json["email"] as? String else {
            return nil
        }
        
        return email
    }
}
