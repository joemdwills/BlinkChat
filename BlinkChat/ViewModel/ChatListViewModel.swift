import Foundation

@Observable
final class ChatListViewModel {
    private(set) var chats: [Chat] = []
    private(set) var isLoading = false
    private(set) var error: Error?

    private let repository: any ChatListRepositoryProtocol

    init(repository: any ChatListRepositoryProtocol) {
        self.repository = repository
    }

    func loadChats() async {
        isLoading = true
        error = nil
        do {
            chats = try await repository.fetchChats()
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
