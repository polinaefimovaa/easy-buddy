import SwiftUI

struct StudentView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var students: [UserProfile] = []
    @State private var assignedStudentIds: Set<Int> = [] // Храним ID назначенных студентов
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showAuthError = false
    @State private var selectedTag = "ALL APPLICATIONS"
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if isLoading {
                        ProgressView()
                    } else if !students.isEmpty {
                        studentsList
                    } else if let error = errorMessage {
                        errorContent(error)
                    } else {
                        emptyContent
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
            }
            .background(Color.background)
            .refreshable {
                await loadStudents()
            }
            .task {
                await loadStudents()
            }
            .alert("Authentication Error", isPresented: $showAuthError) {
                Button("OK", role: .cancel) {
                    viewModel.clearToken()
                }
            } message: {
                Text("Re-authentication required")
            }
        }
    }
    
    private var studentsList: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            H1(text: "FIND STUDENTS")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 12) {
                    ForEach(["ALL APPLICATIONS", "MY STUDENTS"], id: \.self) { tag in
                        TagView(tag: tag, isSelected: selectedTag == tag) {
                            selectedTag = tag
                        }
                    }
                }
            }
            
            ForEach(students) { student in
                studentCard(student)
            }
        }
    }
    
    private func studentCard(_ student: UserProfile) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            ViewThatFits {
                HStack {
                    CustomTagProfile(text: "\(student.programType)")
                    CustomTagProfile(text: "\(student.faculty)")
                    Spacer()
                }
                HStack {
                    VStack(alignment: .leading) {
                        CustomTagProfile(text: "\(student.programType)")
                        CustomTagProfile(text: "\(student.faculty)")
                    }
                    Spacer()
                }
                .frame(width: 326)
                
            }
            
            HStack(alignment: .top) {
                profileImage(student.profilePhotoUrl)
                    .frame(width: 129, height: 129)
                
                VStack(alignment: .leading, spacing: 8) {
                    H4(text: "\(student.firstName) \(student.lastName)")
                    pTabs(text: "\(student.languages.replacingOccurrences(of: ", ", with: " / "))")
                        .padding(.top, 8)
                    
                    Spacer()
                    
                    // Кнопка с индивидуальным состоянием для каждого студента
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            toggleAssignment(for: student.id)
                        }
                    }) {
                        Text(assignedStudentIds.contains(student.id) ? "Assigned" : "Take this student")
                            .font(.custom("TTHoves-Medium", size: 13))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(assignedStudentIds.contains(student.id) ? Color.greyscale500 : Color.black)
                            .cornerRadius(8)
                    }
                    
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
    
    private func toggleAssignment(for studentId: Int) {
        if assignedStudentIds.contains(studentId) {
            assignedStudentIds.remove(studentId)
        } else {
            assignedStudentIds.insert(studentId)
        }
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
                        .frame(width: 129, height: 129)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                case .failure:
                    defaultProfileImage()
                case .empty:
                    ProgressView()
                        .frame(width: 129, height: 129)
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
            .frame(width: 129, height: 129)
            .foregroundColor(.gray)
    }
    
    private var emptyContent: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.3.fill")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            Text("No other students found")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .padding()
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
            
            Button("Logout") {
                viewModel.clearToken()
            }
        }
        .padding()
    }
    
    // MARK: - Network Functions
    private func loadStudents() async {
        guard let token = KeychainService().getString(forKey: ViewModel.Const.tokenKey) else {
            await handleAuthError("Token not found")
            return
        }
        
        guard let currentUserEmail = JWTDecoder.getUserEmailFromToken(token) else {
            await handleAuthError("Failed to get email from token")
            return
        }
        
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let allProfiles = try await fetchAllProfiles(token: token)
            let filteredProfiles = allProfiles.filter { $0.email != currentUserEmail }
            
            await MainActor.run {
                students = filteredProfiles
            }
        } catch {
            await handleError(error)
        }
        
        await MainActor.run {
            isLoading = false
        }
    }
    
    private func fetchAllProfiles(token: String) async throws -> [UserProfile] {
        return try await withCheckedThrowingContinuation { continuation in
            let urlString = "http://127.0.0.1:3000/api/v1/profiles"
            guard let url = URL(string: urlString) else {
                continuation.resume(throwing: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
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
                    continuation.resume(throwing: NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Server returned an error"]))
                    return
                }
                
                guard let data = data else {
                    continuation.resume(throwing: NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "No data in response"]))
                    return
                }
                
                do {
                    let profiles = try JSONDecoder().decode([UserProfile].self, from: data)
                    continuation.resume(returning: profiles)
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
                errorMessage = "Authentication required"
                showAuthError = true
            default:
                errorMessage = "Network error: \(urlError.localizedDescription)"
            }
        } else {
            errorMessage = error.localizedDescription
        }
    }
}
