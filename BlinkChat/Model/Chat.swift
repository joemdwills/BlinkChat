import Foundation
import SwiftData

@Model
final class Chat {
    @Attribute(.unique)
    private(set) var id: String
    private(set) var name: String
    var lastUpdated: Date
    @Relationship(deleteRule: .cascade, inverse: \Message.conversation)
    var messages: [Message]
    
    init(
        id: String,
        name: String,
        lastUpdated: Date,
        messages: [Message] = []
    ) {
        self.id = id
        self.name = name
        self.lastUpdated = lastUpdated
        self.messages = messages
    }
}

struct ChatDTO: Codable {
    let id: String
    let name: String
    let lastUpdated: Date
    let messages: [MessageDTO]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case lastUpdated = "last_updated"
        case messages
    }
}
