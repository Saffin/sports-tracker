//
//  SportsManagerProtocol.swift
//  SportsTracker
//
//  Created by David Šafarik on 23.10.2024.
//


protocol SportsManagerProtocol {
    func save(_ sport: SportModel) async throws
    func delete(_ sport: SportModel) async throws
    func getAll() async throws -> [SportModel]
}