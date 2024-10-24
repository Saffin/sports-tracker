import SwiftUI

// just for navigation purposes
struct SportDetailView: View {
    let sport: SportModel
    
    var body: some View {
        self.contentView
        .padding()
        .frame(maxWidth: .infinity)
        .roundedCard()
        .padding()
        .navigationBarTitle("Record Details", displayMode: .inline)
    }
}

private extension SportDetailView {
    var contentView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text(sport.name)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .frame(alignment: .leading)
                        .padding(.bottom)
                    Spacer()
                    self.sportImage
                }
                HStack {
                    Text(sport.location)
                        .font(.system(size: 24, weight: .medium, design: .default))
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(sport.duration)
                        .font(.system(size: 18, weight: .light, design: .monospaced))
                }
            }
            Spacer()
        }
    }
    var sportImage: some View {
        Image(systemName: sport.storage == .local ? "icloud.and.arrow.down" : "icloud.and.arrow.up")
    }
}

#Preview {
    SportDetailView(
        sport: SportModel(
            id: UUID(),
            name: "Football",
            location: "London",
            duration: "2 hours",
            storage: .remote
        )
    )
}


// MARK: - Extensions
extension View {
    func roundedCard() -> some View {
        self.modifier(RoundedCardModifier())
    }
}

struct RoundedCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
    }
}
