//
//  DessertDetailView.swift
//  FreshDesserts
//
//  Created by htetkaungkyaw on 10/11/2023.
//

import SwiftUI

struct DessertDetailView: View {
    @State private var detailedDessert: Dessert?

    var dessert: Dessert

    var body: some View {
        VStack {
            // Display detailed information here using detailedDessert
            Text("Meal Name: \(detailedDessert?.strMeal ?? "")")
            Text("Instructions: \(detailedDessert?.strInstructions ?? "")")
            //Text("Ingredients: \(detailedDessert?.ingredients.joined(separator: ", ") ?? "")")
        }
        .onAppear {
            Task {
                do {
                    detailedDessert = try await JsonDessertService().getDessertDetails(for: dessert)
                } catch {
                    print("Error fetching details: \(error.localizedDescription)")
                }
            }
        }
    }

    func fetchDetails(for dessert: Dessert) async throws -> Dessert {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(dessert.idMeal)") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(Response.self, from: data)
        return decoded.meals.first ?? dessert
    }
}


//#Preview {
//    DessertDetailView(dessert: Dessert.desserts[0])
//}
