import Foundation

nonisolated enum A11yIdentifier {
    enum Chats {
        nonisolated static let list = "chats_list"
        nonisolated static func chat(id: String) -> String {
            "conversation_\(id)"
        }
    }
    
    enum ChatDetail {
        nonisolated static let messages = "messages_list"
        nonisolated static let messageEditor = "message_editor"
        nonisolated static let sendButton = "send_button"
        
        nonisolated static func message(id: String) -> String {
            "message_\(id)"
        }
    }
}
