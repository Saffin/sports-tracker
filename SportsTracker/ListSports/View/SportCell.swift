import SwiftUI

struct SportCell: View {
    let model: SportModel
    
    var body: some View {
        self.contentView
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(self.backgroundColor)
        )
        .frame(maxWidth: .infinity)
    }
}

private extension SportCell {
    var contentView: some View {
        VStack {
            HStack {
                Text(self.model.name)
                    .font(.title)
                    .padding()
                Spacer()
                self.image
                    .padding()
            }
            VStack {
                HStack {
                    Text(self.model.location)
                        .font(.caption)
                        .padding()
                    Spacer()
                    Text(self.model.duration)
                        .font(.caption)
                        .padding()
                }
            }
        }
    }
    var backgroundColor: Color {
        self.model.isLocal ? .red : .green
    }
    
    var image: Image {
        self.model.isLocal ? Image(systemName: "icloud.and.arrow.down") : Image(systemName: "icloud.and.arrow.up")
    }
}
#Preview {
    VStack {
        SportCell(
            model: SportModel(
                id: UUID(),
                name: "Football",
                location: "London",
                duration: "2 hours",
                storage: .remote
            )
        )
        SportCell(
            model: SportModel(
                id: UUID(),
                name: "Football",
                location: "London",
                duration: "2 hours",
                storage: .local
            )
        )
    }
}
