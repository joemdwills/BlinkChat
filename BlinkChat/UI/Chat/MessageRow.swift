import SwiftUI

struct MessageRow: View {
    let message: Message

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(message.lastUpdated.conversationTimestamp)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(message.text)
                .font(.body)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    MessageRow(
        message: Message(
            id: "1",
            text: "Hey! How are you doing?",
            lastUpdated: Date()
        )
    )
    .padding()
}

