//
//  ChatView.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/13/23.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var chatListViewModel: ChatListViewModel
    let chat: Chat
    private let columns = [
        GridItem(.flexible(minimum: 10))
    ]
    @State private var messageText = ""
    @FocusState private var isFocused

    var body: some View {
        VStack {
            // Chat messsage bubbles between users
            GeometryReader { geometry in
                ScrollView {
                    // Message bubble views for each user
                    LazyVGrid(columns: columns) {
                        getMessagesView(viewWidth: geometry.size.width)
                            .padding(.horizontal)
                    }
                }
            }
            // Botoom tool bar view to type/send new message
            getToolBarView()
        }
        // Mark chat messages as read and clear blue indicator
        .onAppear {
            chatListViewModel.markChatAsRead(chat: chat)
        }
        .padding(.top, 1)
        .navigationTitle(chat.otherUser.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Custom Views
    
    // Return all message bubble views for user chat
    private func getMessagesView(viewWidth: CGFloat) -> some View {
        ForEach(chat.messages) { message in
            if let isReceived = message.type == .Received {
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
    }
    
    // Return Toolbar view for user to type new message to send
    private func getToolBarView() -> some View {
        VStack {
            HStack {
                // Get message to send from user
                TextField("Message", text: $messageText)
                    .padding(.horizontal)
                    .frame(height: 40)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .focused($isFocused)
                
                // Send messsage button
                Button(action: handleSendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Circle()
                            // Set send message button to gray (nothing to send) or blue (text to send)
                            .foregroundColor(messageText.isEmpty ? .gray : .blue)
                        )
                }
                .disabled(messageText.isEmpty)
            }
            .frame(height: 40)
        }
        .padding(.vertical)
        .padding(.horizontal)
        .background(.thickMaterial)
    }
    
    // MARK: - Action Handlers
    
    // Send message on button press
    private func handleSendMessage() {
        chatListViewModel.sendMesage(text: messageText, in: chat)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(chat: SAMPLE_CHAT_LIST[0])
            .environmentObject(ChatListViewModel())
    }
}
