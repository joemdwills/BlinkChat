import Foundation

protocol ChatRepositoryProtocol {
    func fetchMessages(chatId: String) async throws -> [Message]
    func sendMessage(chatId: String, text: String) async throws -> Message
}
