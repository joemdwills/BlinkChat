import Foundation
import SwiftData

@Model
final class Message {
    @Attribute(.unique) private(set) var id: String
    private(set) var text: String
    private(set) var lastUpdated: Date
    private(set) var conversation: Chat?
    
    init(id: String, text: String, lastUpdated: Date) {
        self.id = id
        self.text = text
        self.lastUpdated = lastUpdated
    }
}

struct MessageDTO: Codable {
    let id: String
    let text: String
    let lastUpdated: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case lastUpdated = "last_updated"
    }
}
