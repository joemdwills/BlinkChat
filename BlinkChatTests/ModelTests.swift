import Testing
import Foundation
import SwiftData
@testable import BlinkChat

@MainActor
struct ModelDecodingTests {
    
    @Test
    func decodeConversationsFromJSON() throws {
        let json = """
        [
          {
            "id": "1",
            "name": "Test Chat",
            "last_updated": "2020-05-04T03:37:18",
            "messages": [
              {
                "id": "m1",
                "text": "Hello",
                "last_updated": "2020-02-16T04:35:16"
              }
            ]
          }
        ]
        """

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "GMT")

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)

        let data = json.data(using: .utf8)!
        let conversations = try decoder.decode([ChatDTO].self, from: data)

        #expect(conversations.count == 1)
        #expect(conversations[0].name == "Test Chat")
        #expect(conversations[0].messages.count == 1)
        #expect(conversations[0].messages[0].text == "Hello")
    }

    @Test
    func decodeDateFormat() throws {
        let json = """
        {
          "id": "1",
          "text": "Test",
          "last_updated": "2020-05-04T03:37:18"
        }
        """

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "GMT")

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)

        let data = json.data(using: .utf8)!
        let message = try decoder.decode(MessageDTO.self, from: data)

        let components = Calendar(identifier: .gregorian).dateComponents(
            in: TimeZone(identifier: "GMT")!,
            from: message.lastUpdated
        )
        #expect(components.year == 2020)
        #expect(components.month == 5)
        #expect(components.day == 4)
    }
}
