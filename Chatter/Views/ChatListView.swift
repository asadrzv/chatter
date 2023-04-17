//
//  ChatListView.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/11/23.
//

import SwiftUI

struct ChatListView: View {
    @StateObject private var chatListViewModel = ChatListViewModel()
    @State private var isLoggedOut = false
        
    var body: some View {
        NavigationView {
            // List of all user chats
            List {
                ForEach(chatListViewModel.filteredChatList) { chat in
                    NavigationLink(destination: {
                        ChatView(chat: chat)
                            .environmentObject(chatListViewModel)
                    }) {
                        ChatCellView(chat: chat)
                    }
                }
            }
            // Search bar for user to filter chats by user name
            .searchable(text: $chatListViewModel.searchText)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // Compose new chat message button
                    Button(action: handleComposeMessage) {
                        Image(systemName: "square.and.pencil")
                    }
                }
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    // Logout button
                    Button(action: handleLogout) {
                        Text("Log out")
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Messages")
        }
        // Segue back to Login View if user successfully logged out
        .fullScreenCover(isPresented: $isLoggedOut, onDismiss: nil) {
            LoginView()
        }
    }
    
    // MARK: - Action Handlers
    
    // Segue to compose new chat message screen on button press
    private func handleComposeMessage() {
        print("Compose new message button pressed")
    }
    
    // Logout user on button press
    private func handleLogout() {
        logoutUser()
    }
    
    // MARK: - Firebase
    
    // Logout user from Firebase Auth using their credentials
    private func logoutUser() {
        do {
            try FirebaseManager.shared.auth.signOut()
            self.isLoggedOut = true
            print("Succesfully logged out!")
        } catch let err as NSError {
            print("Failed to log out user:", err)
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}
