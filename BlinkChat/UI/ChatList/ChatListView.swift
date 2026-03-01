import SwiftUI

struct ChatListView: View {
    @State private var viewModel: ChatListViewModel

    private let chatListRepository: any ChatListRepositoryProtocol

    init(chatListRepository: any ChatListRepositoryProtocol) {
        self.chatListRepository = chatListRepository
        self._viewModel = State(initialValue: ChatListViewModel(repository: chatListRepository))
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.chats.isEmpty {
                    ContentUnavailableView(
                        "No Chats",
                        systemImage: "bubble.left.and.bubble.right",
                        description: Text("Start a new chat to get started")
                    )
                } else {
                    List(viewModel.chats) { chat in
                        Text(chat.name)
                    }
                }
            }
            .navigationTitle("Conversations")
            .task {
                await viewModel.loadChats()
            }
        }
    }
}
#Preview("With Conversations") {
    ChatListView(
        chatListRepository: PreviewChatListRepository(hasData: true),
    )
}

#Preview("Empty State") {
    ChatListView(
        chatListRepository: PreviewChatListRepository(hasData: false),
    )
}

// Preview-only repositories
private struct PreviewChatListRepository: ChatListRepositoryProtocol {
    let hasData: Bool
    
    func fetchChats() async throws -> [Chat] {
        guard hasData else { return [] }
        
        let conversation1 = Chat(
            id: "1",
            name: "Project Discussion",
            lastUpdated: Date().addingTimeInterval(-3600)
        )
        
        let conversation2 = Chat(
            id: "2",
            name: "Team Standup",
            lastUpdated: Date().addingTimeInterval(-7200)
        )
        
        let conversation3 = Chat(
            id: "3",
            name: "Design Review",
            lastUpdated: Date().addingTimeInterval(-86400)
        )
        
        return [conversation1, conversation2, conversation3]
    }
}


