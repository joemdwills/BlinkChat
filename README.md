# BlinkChat - Test Submission by Joe Williams
A chat application for iOS demonstrating offline first architecture with SwiftData persistence, protocol-driven dependency injection, and comprehensive test coverage.

## Target & Build Technologies
- iOS 26.0+
- Swift 6
- SwiftUI & some UIKit
- SwiftData

## Architecture (MVVM + Repository)
BlinkChat follows a **View → ViewModel → Repository** layered architecture.

**Views** are lightweight SwiftUI screens that bind to `@Observable` ViewModels. ViewModels own the presentation state and delegate all data operations to repository protocols. Concrete repository implementations are injected at app launch, enabling the UI and business logic to remain decoupled from the persistence layer.

The **repository pattern** was chosen for several reasons:

- **Offline first requirement**: The app needs to read and write messages without a network connection. Abstracting data access behind a protocol makes it straightforward to swap the underlying store (SwiftData today, a sync-capable backend tomorrow) without touching the ViewModel or View layers.

- **Testability**: Every ViewModel is tested against a mock repository. Because repositories conform to protocols, mocks can be substituted at injection point (initialiser) with no runtime flags or conditional logic in production code. The same mechanism supports Xcode Previews via lightweight preview only conformances.

All repositories and ViewModels run on `@MainActor`, sharing the same isolation domain as SwiftData's `ModelContext` and the UI. This avoids the complexity of cross-actor data transfer and keeps `@Model` objects safely within a single concurrency domain.

## Key Decisions

**SwiftData for persistence**: SwiftData provides a low-ceremony way to model, persist, and query data with minimal boilerplate. For a technical test this felt like  a pragmatic choice, though a production messaging app may require end-to-end encryption at the storage layer, which SwiftData does not natively support.

**Date formatting**: Conversation timestamps use contextual formatting following patterns from other popular messaging apps. (time only for today, day name for the past week, full date beyond that).

**UIKit UITextView via UIViewRepresentable**: The message composer uses a wrapped `UITextView` rather than a SwiftUI `TextField` or `TextEditor`. SwiftUI still lacks a native multi-line text input that dynamically grows with content, caps at a maximum height, and transitions to scrollable. `UITextView` handles all of this out of the box, so it felt appropriate to fall back to this framework.

**Testing**: Several tests have been added to cover several layers of the architecture. I also wanted to demonstrate the **Page Object Pattern** for UITesting which I first came across whilst working at in the Mobile team @ Dyson. It is a fairly simple but neat way to convert UI Tests in Swift to appear like inline step functions, making them far more readable. This helps to clearly define the flow of the test and improve the speed of modification / extension or even debugging.

## Next Steps
Given more time, the following improvements would be prioritised:

- **Message ownership**: Extend the `Message` model with a sender identifier and direction (sent vs received) so the app can distinguish between participants in a conversation. Depending on the architecture of the models from the service/scource (in a real world scenario) this may require dicsussions with back-end engineers to agree on the best approach.
- **Network service layer**: Introduce a networking layer to sync messages with a remote backend. WebSockets or a push-based mechanism (e.g. server-sent events) would provide real-time delivery; the offline first repository pattern means the local store remains the source of truth with background sync.
- **Encryption**: Add end-to-end encryption for messages both in transit and at rest. This would likely require replacing or wrapping the SwiftData store, but encryption is actually something I've never really worked with so wouldn't be able to comment on an ideal solution.
- **UI improvements**: Differentiate sent and received messages visually with aligned message bubbles, distinct colours, and sender labels. Add read receipts, typing indicators, richer media support, message reactions (like emojis).
