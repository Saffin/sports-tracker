import SwiftUI

struct InputView: View {
    @Binding var text: String
    let placeholder: String
    let keyboardType: UIKeyboardType
    
    let maxLength = 50

    var body: some View {
        TextField(
            placeholder,
            text: $text.max(
                maxLength
            ),
            axis: .vertical
        )
        .autocorrectionDisabled()
        .keyboardType(self.keyboardType)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .textFieldStyle(.plain)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.blue, lineWidth: 1)
        }
    }
}

#Preview {
    InputView(
        text: .constant(""),
        placeholder: "Name",
        keyboardType: .alphabet
    )
    .padding()
}
