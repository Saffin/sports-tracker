//
//  SportModel.swift
//  SportsTracker
//
//  Created by David Šafarik on 23.10.2024.
//


import Foundation

struct SportModel: Identifiable {
    enum Storage {
        case local
        case remote
    }
    
    let id: UUID
    let name: String
    let location: String
    let duration: String
    let storage: Storage = .local
}
