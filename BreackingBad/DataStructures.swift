//
//  Quote.swift
//  BreackingBad
//
//  Created by Yan  on 21/12/2025.
//

import Foundation

struct Quote: Codable{
    let quoteId:Int
    let quote:String
    let character:String
    let production:String
    let episode:Int
}

struct Char: Codable {
    let characterId: Int
    let name: String
    let birthday: String
    let occupations: [String]
    let images: [URL]
    let fullName: String
    let aliases: [String]
    let status: String
    let appearance: Appearance
    let portrayedBy: String
    let productions: [String]
}

struct Appearance: Codable {
    let breakingBad: [Int]
    let betterCallSaul: [Int]
    let elCamino: [Int]
}

struct DeathRecord: Codable, Identifiable {
    var id:Int { return deathId }
    let deathId: Int
    let character: String
    let image: URL
    let cause: String
    let details: String
    let responsible: [String]
    let connected: [String]
    let lastWords: String
    let episode: Int
    let production: String
}
