//
//  BreackingBadTests.swift
//  BreackingBadTests
//
//  Created by Yan  on 21/12/2025.
//
@testable import BreackingBad
import Testing

struct BreackingBadTests {

    @Test func fetchQuotasTest() async throws {
            let result = try await FetchingServise().fetchRandomQuote(production: Production.BreakingBad)
            let a = result.quote
        let t = 0
    }

    
    @Test func fetchCharacterTest() async throws {
        let result = try await FetchingServise().fetchCharacter(name: "Jesse Pinkman")
       
    }
    
    @Test func fetchDeath() async throws {
        let result = try await FetchingServise().fetchDeath(name: "Walter White")
        assert(result != nil)
    }

}
