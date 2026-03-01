import XCTest

final class BlinkChatUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws { }

    @MainActor
    func testSendMessageFlow() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
        
        // MockChatRepository.shared.setupDefaultTestData() is called automatically
        // with the following test data:
        // - Chat ID "1" with messages "msg1" and "msg2"
        // - Chat ID "2" with message "msg3"
        
        let testMessage = "Hello from UI Test"
        
        ChatListScreen(app: app)
            .assertConversationsExist()
            .tapConversation(id: "1")
        
        ChatDetailScreen(app: app)
            .assertDetailViewLoaded()
            .typeMessage(testMessage)
            .tapSendButton()
            .assertMessageExists(withText: testMessage)
            .assertMessageIsLast(withText: testMessage)
    }
}
