import SwiftUI

struct ChatRow: View {
    private let chat: Chat
    
    init(for chat: Chat) {
        self.chat = chat
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(chat.name)
                .font(.headline)
            
            Text(chat.lastUpdated.conversationTimestamp)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 16) {
        ChatRow(
            for: Chat(
                id: "1",
                name: "Alice Johnson",
                lastUpdated: Date()
            )
        )
        
        ChatRow(
            for: Chat(
                id: "2",
                name: "Bob Smith",
                lastUpdated: Calendar.current.date(byAdding: .day, value: -1, to: Date())!
            )
        )
        
        ChatRow(
            for: Chat(
                id: "3",
                name: "Charlie Davis",
                lastUpdated: Calendar.current.date(byAdding: .day, value: -3, to: Date())!
            )
        )
        
        ChatRow(
            for: Chat(
                id: "4",
                name: "Diana Evans",
                lastUpdated: Calendar.current.date(byAdding: .day, value: -30, to: Date())!
            )
        )
    }
    .padding()
}

