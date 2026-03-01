import Foundation

extension Date {
    /// Returns a formatted string based on how recent the date is:
    /// - Today: time (e.g., "2:30 PM")
    /// - Yesterday: "Yesterday"
    /// - Within last week: day of week (e.g., "Wednesday")
    /// - Otherwise: calendar date (e.g., "15 Jan 2026")

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()

    private static let dayNameFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()

    private static let calendarDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()

    var conversationTimestamp: String {
        let calendar = Calendar.current
        let now = Date()

        // Check if today
        if calendar.isDateInToday(self) {
            return Self.timeFormatter.string(from: self)
        }

        // Check if yesterday
        if calendar.isDateInYesterday(self) {
            return "Yesterday"
        }

        // Check if within the last 7 days
        if let daysAgo = calendar.dateComponents([.day], from: self, to: now).day,
           daysAgo < 7 {
            return Self.dayNameFormatter.string(from: self)
        }

        // Otherwise, show calendar date in DD MMM YYYY format
        return Self.calendarDateFormatter.string(from: self)
    }
}
