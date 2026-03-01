import Testing
import SwiftData
@testable import BlinkChat

@MainActor
struct ChatListRepositoryTests {

    @Test func fetchChatsSortedNewestFirst() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Chat.self, Message.self, configurations: config)
        let repository = ChatListRepository(modelContainer: container)

        repository.migrateInitialDataIfNeeded()
        let chats = try await repository.fetchChats()

        #expect(!chats.isEmpty)

        for i in 0..<(chats.count - 1) {
            #expect(chats[i].lastUpdated >= chats[i + 1].lastUpdated)
        }
    }
}
