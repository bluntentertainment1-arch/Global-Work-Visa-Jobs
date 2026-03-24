import SwiftUI
import PhotosUI

struct CreatePostView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = CreatePostViewModel()
    @AppStorage("user_id") private var userId: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        textInputView
                        
                        if let image = viewModel.selectedImage {
                            selectedImageView(image: image)
                        }
                        
                        imagePickerButton
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }
                
                if viewModel.isLoading {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.white)
                        
                        Text("Posting...")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Create Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(themeManager.accentColor)
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Post") {
                        Task {
                            await viewModel.createPost(userId: userId)
                        }
                    }
                    .foregroundColor(themeManager.accentColor)
                    .fontWeight(.semibold)
                    .disabled(viewModel.postContent.isEmpty)
                    .opacity(viewModel.postContent.isEmpty ? 0.5 : 1.0)
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
            .onChange(of: viewModel.postSuccess) { success in
                if success {
                    dismiss()
                }
            }
            .photosPicker(
                isPresented: $viewModel.showImagePicker,
                selection: $viewModel.imageSelection,
                matching: .images
            )
            .onChange(of: viewModel.imageSelection) { newValue in
                Task {
                    await viewModel.loadImage()
                }
            }
        }
        .tint(themeManager.navigationText)
    }
    
    private var textInputView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("What's on your mind?")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(themeManager.primaryText)
            
            TextEditor(text: $viewModel.postContent)
                .frame(minHeight: 150)
                .padding(12)
                .background(themeManager.secondaryBackground)
                .foregroundColor(themeManager.primaryText)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(themeManager.borderColor, lineWidth: 1)
                )
        }
    }
    
    private func selectedImageView(image: UIImage) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Selected Image")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(themeManager.primaryText)
                
                Spacer()
                
                Button(action: {
                    viewModel.removeImage()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(themeManager.secondaryText)
                }
            }
            
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipped()
                .cornerRadius(10)
        }
    }
    
    private var imagePickerButton: some View {
        Button(action: {
            viewModel.showImagePicker = true
        }) {
            HStack {
                Image(systemName: "photo.on.rectangle.angled")
                Text(viewModel.selectedImage == nil ? "Add Image" : "Change Image")
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(themeManager.secondaryBackground)
            .foregroundColor(themeManager.accentColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(themeManager.borderColor, lineWidth: 1)
            )
        }
    }
}

class CreatePostViewModel: ObservableObject {
    @Published var postContent = ""
    @Published var selectedImage: UIImage?
    @Published var imageSelection: PhotosPickerItem?
    @Published var showImagePicker = false
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var postSuccess = false
    
    @MainActor
    func loadImage() async {
        guard let imageSelection = imageSelection else { return }
        
        do {
            if let data = try await imageSelection.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    self.selectedImage = uiImage
                }
            }
        } catch {
            self.errorMessage = "Failed to load image"
            self.showError = true
        }
    }
    
    func removeImage() {
        selectedImage = nil
        imageSelection = nil
    }
    
    @MainActor
    func createPost(userId: String) async {
        guard !postContent.isEmpty else { return }
        
        isLoading = true
        
        do {
            var imageUrl: String?
            
            if let image = selectedImage,
               let imageData = image.jpegData(compressionQuality: 0.7) {
                imageUrl = try await NetworkService.shared.uploadImage(imageData: imageData, userId: userId)
            }
            
            _ = try await NetworkService.shared.createPost(
                userId: userId,
                content: postContent,
                imageUrl: imageUrl
            )
            
            self.postSuccess = true
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
        
        isLoading = false
    }
}