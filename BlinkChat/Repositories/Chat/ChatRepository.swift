import Foundation
import SwiftData

final class ChatRepository: ChatRepositoryProtocol {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        self.modelContext = ModelContext(modelContainer)
    }

    func fetchMessages(chatId: String) async throws -> [Message] {
        let predicate = #Predicate<Chat> { chat in
            chat.id == chatId
        }
        let descriptor = FetchDescriptor<Chat>(predicate: predicate)

        guard let chat = try modelContext.fetch(descriptor).first else {
            return []
        }

        return chat.messages.sorted { $0.lastUpdated < $1.lastUpdated }
    }

    func sendMessage(chatId: String, text: String) async throws -> Message {
        let predicate = #Predicate<Chat> { chat in
            chat.id == chatId
        }
        let descriptor = FetchDescriptor<Chat>(predicate: predicate)

        guard let chat = try modelContext.fetch(descriptor).first else {
            throw ChatRepositoryError.chatNotFound(chatId)
        }

        let message = Message(
            id: UUID().uuidString,
            text: text,
            lastUpdated: Date()
        )

        chat.messages.append(message)
        chat.lastUpdated = message.lastUpdated

        try modelContext.save()

        return message
    }
}

enum ChatRepositoryError: LocalizedError {
    case chatNotFound(String)

    var errorDescription: String? {
        switch self {
        case .chatNotFound(let id):
            "Chat not found: \(id)"
        }
    }
}
