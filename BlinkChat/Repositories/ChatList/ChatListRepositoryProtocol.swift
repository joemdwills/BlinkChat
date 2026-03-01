import Foundation

protocol ChatListRepositoryProtocol {
    func fetchChats() async throws -> [Chat]
}
