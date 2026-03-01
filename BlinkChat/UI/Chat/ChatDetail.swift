import SwiftUI

struct ChatDetail: View {
    @State var viewModel: ChatDetailViewModel

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                List(viewModel.messages) { message in
                    MessageRow(message: message)
                        .id(message.id)
                        .listRowSeparator(Visibility.hidden)
                }
                .listStyle(.plain)
                .onChange(of: viewModel.messages.count) {
                    if let lastId = viewModel.messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
            }

            Divider()

            HStack(alignment: .bottom, spacing: 8) {
                MessageEditor(text: $viewModel.messageText)

                Button("Send") {
                    Task {
                        await viewModel.sendMessage()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
        }
        .navigationTitle(viewModel.chatName)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadMessages()
        }
    }
}
#Preview("With Messages") {
    NavigationStack {
        ChatDetail(
            viewModel: ChatDetailViewModel(
                chatId: "1",
                chatName: "Alice Johnson",
                repository: PreviewDetailRepository(hasMessages: true)
            )
        )
    }
}


#Preview("Empty Chat") {
    NavigationStack {
        ChatDetail(
            viewModel: ChatDetailViewModel(
                chatId: "1",
                chatName: "Bob Smith",
                repository: PreviewDetailRepository(hasMessages: false),
            )
        )
    }
}

// Preview-only repository
private struct PreviewDetailRepository: ChatRepositoryProtocol {
    let hasMessages: Bool
    
    func fetchMessages(chatId: String) async throws -> [Message] {
        guard hasMessages else { return [] }
        
        let now = Date()
        return [
            Message(
                id: "1",
                text: "Hey! How are you doing?",
                lastUpdated: now.addingTimeInterval(-3600)
            ),
            Message(
                id: "2",
                text: "I'm doing great, thanks for asking! Just finished the new feature.",
                lastUpdated: now.addingTimeInterval(-3500)
            ),
            Message(
                id: "3",
                text: "That's awesome! When can I see it?",
                lastUpdated: now.addingTimeInterval(-3400)
            ),
            Message(
                id: "4",
                text: "I'll share it with you tomorrow morning.",
                lastUpdated: now.addingTimeInterval(-3300)
            ),
            Message(
                id: "5",
                text: "Perfect! Looking forward to it.",
                lastUpdated: now.addingTimeInterval(-3200)
            )
        ]
    }
    
    func sendMessage(chatId: String, text: String) async throws -> Message {
        Message(
            id: UUID().uuidString,
            text: text,
            lastUpdated: Date()
        )
    }
}

