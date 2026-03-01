import Foundation

final class MockChatListRepository: ChatListRepositoryProtocol {
    static let shared = MockChatListRepository()

    private var chats: [Chat] = []
    var stubbedError: Error?

    func setStubbedChats(_ chats: [Chat]) {
        self.chats = chats
    }

    func reset() {
        chats = []
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

        let chat1 = Chat(
            id: "1",
            name: "Test chat",
            lastUpdated: Date(),
            messages: [message1, message2]
        )

        let message3 = Message(
            id: "msg3",
            text: "Message in second chat",
            lastUpdated: Date()
        )

        let chat2 = Chat(
            id: "2",
            name: "Another chat",
            lastUpdated: Date(),
            messages: [message3]
        )

        chats = [chat1, chat2]
    }

    func fetchChats() async throws -> [Chat] {
        if let stubbedError { throw stubbedError }
        return chats
    }
}
