//
//  ChatCellView.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/11/23.
//

import SwiftUI

struct ChatCellView: View {
    let chat: Chat
    
    var body: some View {
        HStack {
            // User profile image
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .padding(5)
            
            ZStack {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        // Username text
                        Text(chat.otherUser.name)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        // Time last message received text
                        Text(chat.messages.last?.date.descriptiveString() ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        // Message sent to user text
                        Text(chat.messages.last?.text ?? "")
                            .lineLimit(2)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .frame(height: 50, alignment: .top)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.trailing, 40)
                    }
                }
                // Unread message indicator (blue/none)
                Circle()
                    .foregroundColor(chat.hasUnreadMessages ? .blue : .clear)
                    .frame(width: 15, height: 15)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .frame(height: 80)
    }
}

struct ChatCellView_Previews: PreviewProvider {
    static var previews: some View {
        ChatCellView(chat: SAMPLE_CHAT_LIST[0])
    }
}
