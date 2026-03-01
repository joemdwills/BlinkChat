import Foundation
import Testing
@testable import BlinkChat

@MainActor
struct ChatDetailViewModelTests {

    @Test func loadMessages() async throws {
        let mock = MockChatRepository()
        mock.setStubbedMessages([
            Message(id: "1", text: "Hello", lastUpdated: Date()),
            Message(id: "2", text: "World", lastUpdated: Date())
        ], for: "conv1")

        let viewModel = ChatDetailViewModel(
            chatId: "conv1",
            chatName: "Test Conversation",
            repository: mock
        )
        await viewModel.loadMessages()

        #expect(viewModel.messages.count == 2)
        #expect(viewModel.messages.first?.text == "Hello")
    }

    @Test func sendMessageClearsText() async throws {
        let mock = MockChatRepository()
        let viewModel = ChatDetailViewModel(
            chatId: "conv1",
            chatName: "Test Conversation",
            repository: mock
        )
        viewModel.messageText = "New message"

        await viewModel.sendMessage()

        #expect(viewModel.messageText.isEmpty)
    }

    @Test func sendMessageAppendsToList() async throws {
        let mock = MockChatRepository()
        let viewModel = ChatDetailViewModel(
            chatId: "conv1",
            chatName: "Test Conversation",
            repository: mock
        )
        viewModel.messageText = "New message"

        await viewModel.sendMessage()

        #expect(viewModel.messages.count == 1)
        #expect(viewModel.messages.first?.text == "New message")
    }

    @Test func sendEmptyMessageDoesNothing() async throws {
        let mock = MockChatRepository()
        let viewModel = ChatDetailViewModel(
            chatId: "conv1",
            chatName: "Test Conversation",
            repository: mock
        )
        viewModel.messageText = "   "

        await viewModel.sendMessage()

        #expect(viewModel.messages.isEmpty)
        #expect(mock.sentMessages.isEmpty)
    }

    @Test func sendMessageCapturedInMock() async throws {
        let mock = MockChatRepository()
        let viewModel = ChatDetailViewModel(
            chatId: "conv1",
            chatName: "Test Conversation",
            repository: mock
        )
        viewModel.messageText = "Captured text"

        await viewModel.sendMessage()

        #expect(mock.sentMessages.count == 1)
        #expect(mock.sentMessages.first?.chatId == "conv1")
        #expect(mock.sentMessages.first?.text == "Captured text")
    }

    @Test func chatNameIsCorrectlyAssigned() {
        let mock = MockChatRepository()
        let viewModel = ChatDetailViewModel(
            chatId: "conv1",
            chatName: "Test Conversation",
            repository: mock
        )

        #expect(viewModel.chatName == "Test Conversation")
    }

    @Test func loadMessagesSetsErrorOnFailure() async throws {
        let mock = MockChatRepository()
        mock.stubbedError = TestError.stubbed
        let viewModel = ChatDetailViewModel(
            chatId: "conv1",
            chatName: "Test Conversation",
            repository: mock
        )

        await viewModel.loadMessages()

        #expect(viewModel.error is TestError)
        #expect(viewModel.messages.isEmpty)
        #expect(viewModel.isLoading == false)
    }

    @Test func sendMessageSetsErrorAndPreservesText() async throws {
        let mock = MockChatRepository()
        mock.stubbedError = TestError.stubbed
        let viewModel = ChatDetailViewModel(
            chatId: "conv1",
            chatName: "Test Conversation",
            repository: mock
        )
        viewModel.messageText = "Unsent message"

        await viewModel.sendMessage()

        #expect(viewModel.error is TestError)
        #expect(viewModel.messageText == "Unsent message")
        #expect(viewModel.messages.isEmpty)
    }
}

private enum TestError: Error {
    case stubbed
}
