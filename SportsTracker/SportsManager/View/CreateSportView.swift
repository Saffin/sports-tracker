//
//  CreateSportView.swift
//  SportsTracker
//
//  Created by David Šafarik on 23.10.2024.
//

import Foundation
import SwiftUI

struct CreateSportView: View {
    @ObservedObject var store: SportsListStore
    
    var body: some View {
        VStack {
            InputView(
                text: Binding(
                    get: { self.store.state.name },
                    set: { text in
                        store.actions?.onNameChange(text)
                    }
                ),
                placeholder: "Name"
            )
            InputView(
                text: Binding(
                    get: { self.store.state.location },
                    set: { text in
                        store.actions?.onLocationChange(text)
                    }
                    ),
                placeholder: "Location"
            )
            InputView(
                text: Binding(
                    get: { store.state.duration },
                    set: { text in
                        store.actions?.onDurationChange(text)
                    }
                    ),
                placeholder: "Duration"
            )

            Button("Local") {
                Task {
                    try await self.store.actions?.onSave(storage: .local)
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(13)
            Button("Remote") {
                Task {
                    try await self.store.actions?.onSave(storage: .remote)
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(13)
        }
        .padding()
    }
}

struct InputView: View {
    @Binding var text: String
    let placeholder: String
    
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
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .textFieldStyle(.plain)
        .overlay {
            RoundedRectangle(cornerRadius: 13)
                .stroke(.red)
        }
    }
}

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(limit))
            }
        }
        return self
    }
}
