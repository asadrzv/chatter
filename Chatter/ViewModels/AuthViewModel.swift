//
//  SignInViewModel.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/18/23.
//

import Foundation

class AuthViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var errorStatusMessage = ""
    @Published var isShowingErrorAlert = false
    
    @Published var isSignedIn = false
    
    // MARK: - Action Handlers
    
    // Sign in user on button press
    func handleSignIn() {
        self.signInUser()
    }
    
    // Sign up user on button press
    func handleSignUp() {
        self.signUpUser()
    }
    
    // MARK: - Firebase
    
    // Sign in user to Firebase Auth using specified credentials
    private func signInUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                // Failed to login user
                print("Failed to login user: ", err)
                self.errorStatusMessage = "Failed to login user: \(err.localizedDescription)"
                self.isShowingErrorAlert = true
                return
            }
            // Succesfully logged in user
            self.storeUserInformation()
            self.isSignedIn = true
            self.errorStatusMessage = "Succesfully logged in as user: \(result?.user.uid ?? "")"
            print("Succesfully logged in as user: \(result?.user.uid ?? "")")
        }
    }
    
    // Sign up user to Firebase Auth using specified credentials
    private func signUpUser() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
            if let err = err, self.isPasswordConfirmed() {
                // Failed to create user
                print("Failed to create user: ", err)
                self.errorStatusMessage = "Failed to create user: \(err.localizedDescription)"
                self.isShowingErrorAlert = true
                return
            }
            // Succesfully created user
            self.storeUserInformation()
            self.isSignedIn = true
            self.errorStatusMessage = "Succesfully created user: \(result?.user.uid ?? "")"
            print("Succesfully created user: \(result?.user.uid ?? "")")
        }
    }
    
    // Store user credentials to Firebase Firestore
    private func storeUserInformation() {
        // Create user data (key-value pair) to store in collection if user doesn't exist
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = User(id: uid, email: self.email, name: self.name).dictionary
        
        // Get/create 'users' collection and store user data
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { err in
                if let err = err {
                    // Failed to store/retrieve user data
                    print("Failed to store/retrieve user data: ", err)
                    self.errorStatusMessage += "\n\nFailed to store user data: \(err.localizedDescription)"
                    self.isShowingErrorAlert = true
                    return
                }
                // Succesfully stored/retrieved user data
                print("Succesfully stored/retrieved data for user: \(uid)")
            }
    }
    
    // Return true if password fields match
    private func isPasswordConfirmed() -> Bool {
        if (password.isEmpty || confirmPassword.isEmpty) && (self.password != self.confirmPassword) {
            self.errorStatusMessage += "\nPasswords do not match"
            self.isShowingErrorAlert = true
            print("\nPasswords do not match")
            return false
        }
        
        return true
    }
}
