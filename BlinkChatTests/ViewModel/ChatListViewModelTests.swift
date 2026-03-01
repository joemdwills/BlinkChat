import Foundation
import Testing
@testable import BlinkChat

@MainActor
struct ChatListViewModelTests {

    @Test func loadConversations() async {
        let mock = MockChatListRepository()
        mock.setStubbedChats([
            Chat(
                id: "1",
                name: "Test Chat",
                lastUpdated: Date(),
                messages: []
            )
        ])

        let viewModel = ChatListViewModel(repository: mock)
        await viewModel.loadChats()

        #expect(viewModel.chats.count == 1)
        #expect(viewModel.chats.first?.name == "Test Chat")
    }

    @Test func loadEmptyConversations() async {
        let mock = MockChatListRepository()
        let viewModel = ChatListViewModel(repository: mock)
        await viewModel.loadChats()

        #expect(viewModel.chats.isEmpty)
    }

    @Test func isLoadingTransitions() async {
        let mock = MockChatListRepository()
        let viewModel = ChatListViewModel(repository: mock)

        #expect(viewModel.isLoading == false)
        await viewModel.loadChats()
        #expect(viewModel.isLoading == false)
    }

    @Test func loadChatsSetsErrorOnFailure() async {
        let mock = MockChatListRepository()
        mock.stubbedError = TestError.stubbed
        let viewModel = ChatListViewModel(repository: mock)

        await viewModel.loadChats()

        #expect(viewModel.error is TestError)
        #expect(viewModel.chats.isEmpty)
        #expect(viewModel.isLoading == false)
    }
}

private enum TestError: Error {
    case stubbed
}
