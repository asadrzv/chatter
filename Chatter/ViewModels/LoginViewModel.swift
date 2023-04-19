//
//  LoginViewModel.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/18/23.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var loginStatusMessage = ""
    @Published var email = ""
    @Published var password = ""
    
    // MARK: - Action Handlers
    
    // Login user on button press
    func handleLogin() {
        self.loginUser()
    }
    
    // Create account on button press
    func handleCreateAccount() {
        self.createUser()
    }
    
    // MARK: - Firebase
    
    // Login user to Firebase Auth using specified credentials
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                // Failed to login user
                print("Failed to login user:", err)
                self.loginStatusMessage = "Failed to login user: \(err.localizedDescription)"
            } else {
                // Succesfully logged in user
                self.storeUserInformation()
                self.isLoggedIn = true
                self.loginStatusMessage = "Succesfully logged in as user: \(result?.user.uid ?? "")"
                print("Succesfully logged in as user: \(result?.user.uid ?? "")")
            }
        }
    }
    
    // Create user to Firebase Auth using specified credentials
    private func createUser() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                // Failed to create user
                print("Failed to create user:", err)
                self.loginStatusMessage = "Failed to create user: \(err.localizedDescription)"
            } else {
                // Succesfully created user
                self.storeUserInformation()
                self.isLoggedIn = true
                self.loginStatusMessage = "Succesfully created user: \(result?.user.uid ?? "")"
                print("Succesfully created user: \(result?.user.uid ?? "")")
            }
        }
    }
    
    // Store user credentials to Firebase Firestore
    private func storeUserInformation() {
        // Create user data (key-value pair) to store in collection if user doesn't exist
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = User(email: self.email).dictionary
        
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { err in
                if let err = err {
                    // Failed to store user data
                    print("Failed to store user data:", err)
                    self.loginStatusMessage += "\n\nFailed to store user data: \(err.localizedDescription)"
                } else {
                    // Succesfully stored user data
                    print("Succesfully stored data for user: \(uid)")
                }
            }
    }
}
