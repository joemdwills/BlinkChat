import XCTest
@testable import BlinkChat

@MainActor
final class ChatListScreen {
    private let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    // MARK: - Elements
    private var conversationsList: XCUIElement {
        app.collectionViews[A11yIdentifier.Chats.list].firstMatch
    }
    
    private func conversationCell(id: String) -> XCUIElement {
        app.buttons.matching(identifier: A11yIdentifier.Chats.chat(id: id)).firstMatch
    }
    
    // MARK: - Assertions
    @discardableResult
    func assertConversationsExist() -> Self {
        XCTAssertTrue(conversationsList.waitForExistence(timeout: 5), "Conversations list should exist")
        return self
    }
    
    @discardableResult
    func assertConversationExists(id: String) -> Self {
        XCTAssertTrue(conversationCell(id: id).exists, "Chat with id \(id) should exist")
        return self
    }
    
    // MARK: - Actions
    @discardableResult
    func tapConversation(id: String) -> Self {
        let cell = conversationCell(id: id)
        XCTAssertTrue(cell.waitForExistence(timeout: 5), "Chat cell should exist before tapping")
        cell.tap()
        return self
    }
}
