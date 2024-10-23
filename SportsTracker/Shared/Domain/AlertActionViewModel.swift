import SwiftUI

struct AlertActionViewModel: Equatable {
    let title: String
    let buttonRole: ButtonRole?
    let action: (() -> Void)?

    static func == (lhs: AlertActionViewModel, rhs: AlertActionViewModel) -> Bool {
        lhs.title == rhs.title && lhs.buttonRole == rhs.buttonRole
    }
}
