//
//  SportsListStore.swift
//  SportsTracker
//
//  Created by David Šafarik on 23.10.2024.
//

import Foundation

final class SportsListStore: ObservableObject, ViewStore {
    @Published var state: SportsListState = .init()
    @Published var selectedType: Selected = .all
    var actions: SportsListPresenter?
}

extension SportsListStore {
    func update(state: SportsListState) {
        DispatchQueue.main.async {
            self.state = state
            self.selectedType = state.selectedType
        }
    }
}
