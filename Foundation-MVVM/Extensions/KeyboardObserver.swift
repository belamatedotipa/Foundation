import UIKit

final class KeyboardObserver: ObservableObject {

    // MARK: Static properties
    static let shared = KeyboardObserver()

    // MARK: Stored properties
    @Published
    private(set) var rect: CGRect = .zero

    // MARK: Computed properties
    var height: CGFloat { rect.height }

    // MARK: Init
    private init() {
        NotificationCenter.default
            .addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                         name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                         name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Actions
    @objc private func keyboardWillShow(notification: Notification) {
        rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
    }

    @objc private func keyboardWillHide(notification: Notification) {
        rect = .zero
    }

}
