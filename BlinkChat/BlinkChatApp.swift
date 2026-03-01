import SwiftUI
import SwiftData

@main
struct BlinkChatApp: App {
    let modelContainer: ModelContainer
    let chatListRepository: any ChatListRepositoryProtocol
    let chatRepository: any ChatRepositoryProtocol
    
    init() {
        // Check if running UI tests
         let isUITesting = CommandLine.arguments.contains("--uitesting")
        
        if isUITesting {
            // Use mock repository for UI tests - no SwiftData needed
            do {
                // Still need a container for the modelContainer modifier, but it won't be used
                let container = try ModelContainer(
                    for: Chat.self, Message.self,
                    configurations: ModelConfiguration(isStoredInMemoryOnly: true)
                )
                self.modelContainer = container
            } catch {
                fatalError("Failed to initialize ModelContainer: \(error)")
            }
            
            // Use shared mock repositories and set up default test data
            let mockChatListRepo = MockChatListRepository.shared
            let mockChatRepo = MockChatRepository.shared
            self.chatListRepository = mockChatListRepo
            self.chatRepository = mockChatRepo
            
            mockChatListRepo.setupDefaultTestData()
            mockChatRepo.setupDefaultTestData()
        } else {
            // Production: use real SwiftData repositories
            do {
                let container = try ModelContainer(for: Chat.self, Message.self)
                self.modelContainer = container
                
                let chatListRepo = ChatListRepository(modelContainer: container)
                let chatRepo = ChatRepository(modelContainer: container)
                self.chatListRepository = chatListRepo
                self.chatRepository = chatRepo
                
                chatListRepo.migrateInitialDataIfNeeded()
            } catch {
                fatalError("Failed to initialize ModelContainer: \(error)")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ChatListView(
                chatListRepository: chatListRepository,
                chatRepository: chatRepository
            )
        }
        .modelContainer(modelContainer)
    }
}
