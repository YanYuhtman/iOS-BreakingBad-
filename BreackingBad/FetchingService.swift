//
//  FetchingService.swift
//  BreackingBad
//
//  Created by Yan  on 21/12/2025.
//
import Foundation

enum Production : String {
    case BreakingBad = "Breaking+Bad"
    case BetterCallSaul = "Better+Call+Saul"
    case ElCamino = "El+Camino"
    
    var imageName:String{
        return switch(self){
        case .BreakingBad:
            "breakingbad"
        case .BetterCallSaul:
            "bettercallsaul"
        case .ElCamino:
            "elcamino"
        }
    }
    var label:String{
        return switch(self){
        case .BreakingBad:
            "Breaking Bad"
        case .BetterCallSaul:
            "Better Call Saul"
        case .ElCamino:
            "El Camino"
        }
    }
}

enum FetchException:Error{
    case UrlFrpmatException(String)
    case ConnectivityException(String)
}

class FetchingServise{
    private let apiUri = "https://breaking-bad-api-six.vercel.app/api/"
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    
    init(){
        jsonDecoder.keyDecodingStrategy = JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
    }
    
    private func fetchData<T:Decodable>(subPath:String, queryItems:[URLQueryItem])async throws -> T {
        if let url =  URL(string: apiUri)?.appending(path:subPath).appending(queryItems: queryItems){
            let (data,responce) = try await URLSession.shared.data(from: url)
            guard let r = responce as? HTTPURLResponse else{
                throw FetchException.ConnectivityException("Invalid response")
            }
            guard r.statusCode >= 200 && r.statusCode < 300  else{
                throw FetchException.ConnectivityException("Invalid response code: \(r)")
            }
            print("Data:\(String(data: data, encoding: String.Encoding.utf8))")
            return try jsonDecoder.decode(T.self, from: data)
        }
        throw FetchException.ConnectivityException("Unexpected exception")
        
    }
   
    func fetchRandomQuote(production:Production)async throws -> Quote {
        return try await fetchData(subPath: "quotes/random",queryItems: [URLQueryItem(name: "production",value: production.rawValue)])
    }
    func fetchCharacter(name:String)async throws ->Char{
        let ch:[Char] = try await fetchData(subPath: "characters",queryItems: [URLQueryItem(name: "name",value: name)])
        return ch[0]
    }
    func fetchCharacter(id:Int)async throws ->Char{
        let ch:[Char] = try await fetchData(subPath: "characters",queryItems: [URLQueryItem(name: "id",value:String(format: "%d", id))])
        return ch[0]
    }
    func fetchDeath(name:String)async throws -> DeathRecord?{
        let deaths:[DeathRecord] = try await fetchData(subPath: "deaths",queryItems: [])

        if let death = deaths.first(where: {deathRecord in
            name.compare(deathRecord.character, options: .caseInsensitive) == .orderedSame
        }){ return death}
        return nil
    }
}
