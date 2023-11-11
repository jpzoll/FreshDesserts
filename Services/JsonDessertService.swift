//
//  JsonDessertService.swift
//  FreshDesserts
//
//  Created by htetkaungkyaw on 10/11/2023.
//

import Foundation
import SwiftUI


struct JsonDessertService {
    
    enum ServiceError: Error {
        case badURL
        case emptyData
        case decodingError
    }
    
    func getDesserts() async throws -> [Dessert]? {
        
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
            print("Incorrect URL. Please try a different link!")
            throw ServiceError.badURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if data.isEmpty {
                print("Data is empty!")
                throw ServiceError.emptyData
                
            }
        
            if let decoded = try?  JSONDecoder().decode(Response.self, from: data) {
                // Sets desserts in sorted order
                let desserts = decoded.meals.sorted { $0.strMeal < $1.strMeal }
                print("desserts JSON: \(desserts)")
                return desserts
            }
        } catch {
            print("Error when decoding data.")
            throw ServiceError.decodingError
        }
        return nil
    }
    
    func getDessertDetails(for dessert: Dessert) async throws -> Dessert {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(dessert.idMeal)") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(Response.self, from: data)
        return decoded.meals.first ?? dessert
    }
}
