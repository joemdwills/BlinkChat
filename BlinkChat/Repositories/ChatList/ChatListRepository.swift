import Foundation
import SwiftData

final class ChatListRepository: ChatListRepositoryProtocol {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "GMT")
        return formatter
    }()

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        self.modelContext = ModelContext(modelContainer)
    }

    // Migration: Load initial data from JSON if database is empty
    func migrateInitialDataIfNeeded() {
        let descriptor = FetchDescriptor<Chat>()
        guard let chats = try? modelContext.fetch(descriptor),
              chats.isEmpty else {
            return
        }

        guard let url = Bundle.main.url(forResource: "Messages", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Self.dateFormatter)

        guard let chatDTOs = try? decoder.decode([ChatDTO].self, from: data) else {
            return
        }

        for chatDTO in chatDTOs {
            let messages = chatDTO.messages.map { messageDTO in
                Message(
                    id: messageDTO.id,
                    text: messageDTO.text,
                    lastUpdated: messageDTO.lastUpdated
                )
            }

            let chat = Chat(
                id: chatDTO.id,
                name: chatDTO.name,
                lastUpdated: chatDTO.lastUpdated,
                messages: messages
            )

            modelContext.insert(chat)
        }

        try? modelContext.save()
    }

    func fetchChats() async throws -> [Chat] {
        let descriptor = FetchDescriptor<Chat>(
            sortBy: [SortDescriptor(\.lastUpdated, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
}
