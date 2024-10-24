import SwiftUI

struct InputView: View {
    @Binding var text: String
    let placeholder: String
    
    let maxLength = 50

    var body: some View {
        TextField(
            self.placeholder,
            text: $text.max(
            maxLength
        ),
        axis: .vertical
    )
            .padding()
            .frame(maxWidth: .infinity)
            .autocorrectionDisabled()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.systemGray6))
            )
            .padding(.horizontal)
    }
}

#Preview {
    InputView(
        text: .constant(""),
        placeholder: "Name"
    )
    .padding()
}
