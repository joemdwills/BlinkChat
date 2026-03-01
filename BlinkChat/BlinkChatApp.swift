import SwiftUI
import SwiftData

@main
struct BlinkChatApp: App {
    let modelContainer: ModelContainer
    let chatListRepository: any ChatListRepositoryProtocol
    
    init() {
        do {
            let container = try ModelContainer(for: Chat.self, Message.self)
            self.modelContainer = container
            
            let chatListRepo = ChatListRepository(modelContainer: container)
            self.chatListRepository = chatListRepo
            
            chatListRepo.migrateInitialDataIfNeeded()
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ChatListView(
                chatListRepository: chatListRepository,
            )
        }
        .modelContainer(modelContainer)
    }
}
