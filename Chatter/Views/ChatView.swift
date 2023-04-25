//
//  ChatView.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/13/23.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var chatViewModel: ChatViewModel
    let otherUser: User
    
    private let columns = [GridItem(.flexible(minimum: 10))]
    @FocusState private var isFocused
    
    init(otherUser: User) {
        self.otherUser = otherUser
        self.chatViewModel = ChatViewModel.init(otherUser: otherUser)
    }

    var body: some View {
        VStack {
            // Chat messsage bubbles between users
            ScrollView {
                getMessagesView(viewWidth: 400)
                    .padding(.horizontal)
            }
            // Botoom tool bar view to type/send new message
            getToolBarView()
        }
        .padding(.top, 1)
        .navigationTitle(chatViewModel.otherUser?.name ?? "Unknown")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Custom Views
    
    // Return all message bubble views for user chat
    private func getMessagesView(viewWidth: CGFloat) -> some View {
        ForEach(chatViewModel.messages) { message in
            let uid = FirebaseManager.shared.auth.currentUser?.uid
            let isReceived = message.toId == uid

            HStack {
                ZStack {
                    // Message text content
                    Text(message.text)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        // Set message bubble color to gray (received) or blue (sent)
                        .background(isReceived ? .gray.opacity(0.3) : .blue.opacity(0.9))
                        // Set message text to gray (received) or blue (sent)
                        .foregroundColor(isReceived ? .black : .white)
                        .cornerRadius(10)
                }
                .frame(width: viewWidth * 0.7, alignment: isReceived ? .leading : .trailing)
                .padding(.vertical)
            }
            // Align message to left (received) or right (sent)
            .frame(maxWidth: .infinity, alignment: isReceived ? .leading : .trailing)
        }
    }
    
    // Return Toolbar view for user to type new message to send
    private func getToolBarView() -> some View {
        VStack {
            HStack {
                // Get message to send from user
                TextField("Message", text: $chatViewModel.messageText)
                    .padding(.horizontal)
                    .frame(height: 40)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .focused($isFocused)
                
                // Send messsage button
                Button(action: chatViewModel.handleSendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Circle()
                            // Set send message button to gray (nothing to send) or blue (text to send)
                            .foregroundColor(chatViewModel.messageText.isEmpty ? .gray : .blue)
                        )
                }
                .disabled(chatViewModel.messageText.isEmpty)
            }
            .frame(height: 40)
        }
        .padding(.vertical)
        .padding(.horizontal)
        .background(.thickMaterial)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(otherUser: SAMPLE_USER)
    }
}
