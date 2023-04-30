//
//  SignUpView.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/24/23.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Sign up view image
                Image(systemName: "message.circle.fill")
                    .font(.system(size: 100))
                
                Group {
                    // Get name from user
                    TextField("Name", text: $authViewModel.name)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    // Get email from user
                    TextField("Email", text: $authViewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    // Get password from user
                    SecureField("Password", text: $authViewModel.password)
                    
                    // Get password confirmation from user
                    SecureField("Confirm Password", text: $authViewModel.confirmPassword)
                }
                .padding(15)
                .background(.white)
                
                VStack {
                    // Create Account Button
                    Button(action: authViewModel.handleSignUp) {
                        Text("Create Account")
                            .font(.headline)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(15)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(40)
                }
                .padding(15)
                
                // Error status message
                /*Text(authViewModel.errorStatusMessage)
                    .foregroundColor(.red)
                 */
            }
            .padding()
        }
        .background(Color(.init(white: 0, alpha: 0.05)).ignoresSafeArea())
        // Error status message alert
        .alert(isPresented: $authViewModel.isShowingErrorAlert) {
            Alert(
                title: Text("Error 🙁"),
                message: Text(authViewModel.errorStatusMessage),
                dismissButton: .default(Text("Ok"), action: {
                    authViewModel.isShowingErrorAlert = false
                })
            )
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(authViewModel: AuthViewModel())
    }
}
