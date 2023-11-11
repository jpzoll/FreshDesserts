//
//  JsonDessertService.swift
//  FreshDesserts
//
//  Created by jpzoll on 10/11/2023.
//

import Foundation
import SwiftUI

// 🍽 Response Model
struct Response: Codable {
    var meals: [Dessert]
}

// MARK: - 🌐 Service that delivers our data from our API Endpoints
struct JSONDessertService {
    
    // 🚨 ServiceError Enum
    enum ServiceError: Error {
        case badURL
        case emptyData
        case decodingError
    }
    
    // 🍨 Fetch Desserts
    func getDesserts() async throws -> [Dessert]? {
        
        // 🔄 Validate URL
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
            print("Incorrect URL. Please try a different link!")
            throw ServiceError.badURL
        }
        
        do {
            // 🔄 Fetch data
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // 🚨 Check for empty data
            if data.isEmpty {
                print("Data is empty!")
                throw ServiceError.emptyData
            }
            
            // 🔄 Decode and sort desserts
            if let decoded = try? JSONDecoder().decode(Response.self, from: data) {
                let desserts = decoded.meals.sorted { $0.strMeal < $1.strMeal }
                return desserts
            }
        } catch {
            print("Error when decoding data for getting all desserts.")
            throw ServiceError.decodingError
        }
        return nil
    }
    
    // 🍧 Fetch Dessert Details
    func getDessertDetails(for dessert: Dessert) async throws -> Dessert {
        
        // 🔄 Validate URL
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(dessert.idMeal)") else {
            throw URLError(.badURL)
        }
        
        do {
            // 🔄 Fetch data
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // 🔄 Decode data and return the first dessert or the original dessert if decoding fails
            let decoded = try JSONDecoder().decode(Response.self, from: data)
            return decoded.meals.first ?? dessert
        }
        catch {
            print("Error when decoding data for dessert details.")
            throw ServiceError.decodingError
        }
    }
}
