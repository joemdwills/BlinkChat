import Foundation
import Testing
import SwiftData
@testable import BlinkChat

@MainActor
struct ChatRepositoryTests {

    private func makeContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: Chat.self, Message.self, configurations: config)
    }

    private func seedChat(in container: ModelContainer) -> Chat {
        let context = ModelContext(container)
        let now = Date()

        let message1 = Message(id: "msg1", text: "First", lastUpdated: now.addingTimeInterval(-200))
        let message2 = Message(id: "msg2", text: "Second", lastUpdated: now.addingTimeInterval(-100))
        let message3 = Message(id: "msg3", text: "Third", lastUpdated: now)

        let chat = Chat(
            id: "chat1",
            name: "Test Chat",
            lastUpdated: now,
            messages: [message3, message1, message2] // intentionally unordered
        )

        context.insert(chat)
        try? context.save()
        return chat
    }

    @Test
    func fetchMessagesSortedOldestFirst() async throws {
        let container = try makeContainer()
        seedChat(in: container)
        let chatRepo = ChatRepository(modelContainer: container)

        let messages = try await chatRepo.fetchMessages(chatId: "chat1")
        #expect(messages.count == 3)

        for i in 0..<(messages.count - 1) {
            #expect(messages[i].lastUpdated <= messages[i + 1].lastUpdated)
        }
    }

    @Test
    func sendMessageAppendsAndUpdatesChat() async throws {
        let container = try makeContainer()
        let chat = seedChat(in: container)
        let chatRepo = ChatRepository(modelContainer: container)

        let originalCount = chat.messages.count
        let result = try await chatRepo.sendMessage(
            chatId: "chat1",
            text: "New test message"
        )

        #expect(result.text == "New test message")

        let updatedMessages = try await chatRepo.fetchMessages(chatId: "chat1")
        #expect(updatedMessages.count == originalCount + 1)
        #expect(updatedMessages.last?.text == "New test message")
    }

    @Test
    func sendMessageToInvalidChatThrows() async throws {
        let container = try makeContainer()
        let chatRepo = ChatRepository(modelContainer: container)

        do {
            _ = try await chatRepo.sendMessage(
                chatId: "nonexistent",
                text: "Should fail"
            )
            Issue.record("Expected ChatRepositoryError to be thrown")
        } catch is ChatRepositoryError {
            // Expected
        }
    }
}
