import Foundation

@Observable
final class ChatDetailViewModel {
    private(set) var messages: [Message] = []
    private(set) var isLoading = false
    private(set) var error: Error?
    var messageText = ""

    let chatId: String
    let chatName: String
    private let repository: any ChatRepositoryProtocol

    init(chatId: String, chatName: String, repository: any ChatRepositoryProtocol) {
        self.chatId = chatId
        self.chatName = chatName
        self.repository = repository
    }

    func loadMessages() async {
        isLoading = true
        error = nil
        do {
            messages = try await repository.fetchMessages(chatId: chatId)
        } catch {
            self.error = error
        }
        isLoading = false
    }

    func sendMessage() async {
        let text = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        messageText = ""

        do {
            let message = try await repository.sendMessage(chatId: chatId, text: text)
            messages.append(message)
        } catch {
            self.error = error
        }
    }
}
