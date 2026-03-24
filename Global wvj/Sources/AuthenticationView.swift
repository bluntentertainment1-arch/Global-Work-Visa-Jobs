import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AuthViewModel()
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("user_id") private var userId: String = ""
    @AppStorage("user_email") private var userEmail: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        
                        inputFieldsView
                        
                        actionButtonsView
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 40)
                }
                
                if viewModel.isLoading {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.white)
                }
            }
            .navigationTitle("Welcome")
            .navigationBarTitleDisplayMode(.large)
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
            .onChange(of: viewModel.loginSuccess) { success in
                if success {
                    isLoggedIn = true
                    userId = viewModel.userId
                    userEmail = viewModel.email
                    dismiss()
                }
            }
        }
        .tint(themeManager.navigationText)
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            Image(systemName: "number")
                .font(.system(size: 60))
                .foregroundColor(themeManager.accentColor)
            
            Text("Join the Conversation")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.primaryText)
            
            Text("Sign in or create an account to start posting")
                .font(.body)
                .foregroundColor(themeManager.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, 20)
    }
    
    private var inputFieldsView: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(themeManager.secondaryText)
                
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(themeManager.secondaryText)
                    
                    TextField("Enter your email", text: $viewModel.email)
                        .foregroundColor(themeManager.primaryText)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                .padding()
                .background(themeManager.secondaryBackground)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(themeManager.borderColor, lineWidth: 1)
                )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(themeManager.secondaryText)
                
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(themeManager.secondaryText)
                    
                    SecureField("Enter your password", text: $viewModel.password)
                        .foregroundColor(themeManager.primaryText)
                }
                .padding()
                .background(themeManager.secondaryBackground)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(themeManager.borderColor, lineWidth: 1)
                )
            }
        }
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: 16) {
            Button(action: {
                Task {
                    await viewModel.login()
                }
            }) {
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                    Text("Sign In")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(themeManager.buttonBackground)
                .foregroundColor(themeManager.buttonText)
                .cornerRadius(10)
            }
            .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)
            .opacity(viewModel.email.isEmpty || viewModel.password.isEmpty ? 0.6 : 1.0)
            
            Button(action: {
                Task {
                    await viewModel.signup()
                }
            }) {
                HStack {
                    Image(systemName: "person.badge.plus")
                    Text("Create Account")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(themeManager.secondaryBackground)
                .foregroundColor(themeManager.accentColor)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(themeManager.accentColor, lineWidth: 2)
                )
            }
            .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)
            .opacity(viewModel.email.isEmpty || viewModel.password.isEmpty ? 0.6 : 1.0)
        }
        .padding(.top, 8)
    }
}

class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var loginSuccess = false
    @Published var userId = ""
    
    @MainActor
    func login() async {
        isLoading = true
        
        do {
            let user = try await NetworkService.shared.login(email: email, password: password)
            self.userId = user.id ?? ""
            self.loginSuccess = true
        } catch let error as NSError {
            if error.code == 400 {
                self.errorMessage = "Invalid credentials"
            } else {
                self.errorMessage = error.localizedDescription
            }
            self.showError = true
        }
        
        isLoading = false
    }
    
    @MainActor
    func signup() async {
        isLoading = true
        
        do {
            let user = try await NetworkService.shared.createUser(email: email, password: password)
            self.userId = user.id ?? ""
            self.loginSuccess = true
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
        
        isLoading = false
    }
}