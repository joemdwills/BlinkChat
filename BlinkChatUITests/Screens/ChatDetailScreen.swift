import XCTest
@testable import BlinkChat

@MainActor
final class ChatDetailScreen {
    private let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    // MARK: - Elements
    private var messagesList: XCUIElement {
        app.collectionViews.matching(identifier: A11yIdentifier.ChatDetail.messages).firstMatch
    }
    
    private var messageEditor: XCUIElement {
        app.textViews.matching(identifier: A11yIdentifier.ChatDetail.messageEditor).firstMatch
    }
    
    private var sendButton: XCUIElement {
        app.buttons.matching(identifier: A11yIdentifier.ChatDetail.sendButton).firstMatch
    }
    
    private func messageCell(id: String) -> XCUIElement {
        app.otherElements.matching(identifier: A11yIdentifier.ChatDetail.message(id: id)).firstMatch
    }
    
    // MARK: - Assertions
    @discardableResult
    func assertDetailViewLoaded() -> Self {
        XCTAssertTrue(messagesList.waitForExistence(timeout: 5), "Messages list should exist")
        XCTAssertTrue(messageEditor.exists, "Message input field should exist")
        XCTAssertTrue(sendButton.exists, "Send button should exist")
        return self
    }
    
    @discardableResult
    func assertMessageExists(withText text: String) -> Self {
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", text)
        let message = app.staticTexts.containing(predicate).firstMatch
        XCTAssertTrue(message.waitForExistence(timeout: 5), "Message with text '\(text)' should exist")
        return self
    }
    
    @discardableResult
    func assertMessageIsLast(withText text: String) -> Self {
        // Wait for the message to appear
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", text)
        let message = app.staticTexts.containing(predicate).firstMatch
        XCTAssertTrue(message.waitForExistence(timeout: 5), "Message with text '\(text)' should exist")
        return self
    }
    
    // MARK: - Actions
    @discardableResult
    func typeMessage(_ text: String) -> Self {
        messageEditor.tap()
        messageEditor.typeText(text)
        return self
    }
    
    @discardableResult
    func tapSendButton() -> Self {
        XCTAssertTrue(sendButton.isEnabled, "Send button should be enabled")
        sendButton.tap()
        return self
    }
}
