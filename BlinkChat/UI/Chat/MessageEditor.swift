import SwiftUI

struct MessageEditor: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String = "Type a message..."
    let minHeight: CGFloat = 36
    let maxHeight: CGFloat = 120
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isScrollEnabled = false
        textView.font = .preferredFont(forTextStyle: .body)
        textView.backgroundColor = .systemGray6
        textView.cornerConfiguration = .corners(radius: 16)
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.textContainer.lineFragmentPadding = 0
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.accessibilityIdentifier = A11yIdentifier.ChatDetail.messageEditor
        
        if text.isEmpty {
            textView.text = placeholder
            textView.textColor = .placeholderText
        } else {
            textView.text = text
            textView.textColor = .label
        }
        
        return textView
    }
    
    func updateUIView(_ textView: UITextView, context: Context) {
        if text.isEmpty && textView.textColor == .label {
            textView.text = placeholder
            textView.textColor = .placeholderText
        } else if !text.isEmpty {
            if textView.text != text {
                textView.text = text
                textView.textColor = .label
            }
        }
        
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: .infinity))
        textView.isScrollEnabled = size.height > maxHeight
        textView.invalidateIntrinsicContentSize()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UITextView, context: Context) -> CGSize? {
        let width = proposal.width ?? 100
        let size = uiView.sizeThatFits(CGSize(width: width, height: .infinity))
        let height = min(max(size.height, minHeight), maxHeight)
        return CGSize(width: width, height: height)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: MessageEditor
        
        init(_ parent: MessageEditor) {
            self.parent = parent
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == .placeholderText {
                textView.text = ""
                textView.textColor = .label
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = parent.placeholder
                textView.textColor = .placeholderText
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: .infinity))
            textView.isScrollEnabled = size.height > parent.maxHeight
            textView.invalidateIntrinsicContentSize()
        }
    }
}

#Preview {
    @Previewable @State var text: String = ""
    MessageEditor(text: $text)
}
