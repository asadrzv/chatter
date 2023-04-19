//
//  ChatListView.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/11/23.
//

import SwiftUI

struct ChatListView: View {
    @StateObject private var chatListViewModel = ChatListViewModel()
        
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
                    Button(action: chatListViewModel.handleComposeMessage) {
                        Image(systemName: "square.and.pencil")
                    }
                }
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    // Logout button
                    Button(action: chatListViewModel.handleLogout) {
                        Text("Log out")
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Messages")
        }
        // Segue back to Login View if user successfully logged out
        .fullScreenCover(isPresented: $chatListViewModel.isLoggedOut, onDismiss: nil) {
            LoginView()
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}
