import SwiftUI

struct SportDetailView: View {
    let sport: SportModel
    var body: some View {
        VStack {
            Text(sport.name)
                .font(.largeTitle)
            Text(sport.location)
                .font(.headline)
            Text(sport.duration)
                .font(.headline)
        }
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
