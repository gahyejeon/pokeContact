//
//  NetworkManager.swift
//  pokeContact
//
//  Created by 내꺼다 on 7/16/24.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchRandomPokemon(completion: @escaping (Pokemon?) -> Void) {
        let randomId = Int.random(in: 1...1000)
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(randomId)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        // 서버로부터 데이터를 받아오기 위한 GET요청 수행
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch data: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let pokemon = try decoder.decode(Pokemon.self, from: data)
                completion(pokemon)
            } catch {
                print("Failed to decode JSON: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
}

