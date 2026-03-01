import Foundation

final class MockChatRepository: ChatRepositoryProtocol {
    static let shared = MockChatRepository()

    private var chatMessagesMap: [String: [Message]] = [:]
    var sentMessages: [(chatId: String, text: String)] = []
    var stubbedError: Error?

    func setStubbedMessages(_ messages: [Message], for chatId: String) {
        chatMessagesMap[chatId] = messages
    }

    func reset() {
        chatMessagesMap = [:]
        sentMessages = []
    }

    // Helper to set up default test data
    func setupDefaultTestData() {
        let message1 = Message(
            id: "msg1",
            text: "Hello, this is a test message",
            lastUpdated: Date()
        )
        let message2 = Message(
            id: "msg2",
            text: "This is the second message",
            lastUpdated: Date()
        )

        let message3 = Message(
            id: "msg3",
            text: "Message in second chat",
            lastUpdated: Date()
        )

        chatMessagesMap["1"] = [message1, message2]
        chatMessagesMap["2"] = [message3]
    }

    func fetchMessages(chatId: String) async throws -> [Message] {
        if let stubbedError { throw stubbedError }
        return chatMessagesMap[chatId] ?? []
    }

    func sendMessage(chatId: String, text: String) async throws -> Message {
        if let stubbedError { throw stubbedError }
        sentMessages.append((chatId: chatId, text: text))

        let message = Message(
            id: UUID().uuidString,
            text: text,
            lastUpdated: Date()
        )

        // Update the chat's messages in memory
        if chatMessagesMap[chatId] != nil {
            chatMessagesMap[chatId]?.append(message)
        } else {
            chatMessagesMap[chatId] = [message]
        }

        return message
    }
}
