//
//  ContentView.swift
//  FreshDesserts
//
//  Created by htetkaungkyaw on 10/11/2023.
//

import SwiftUI

struct Response: Codable {
    var meals: [Dessert]
}

struct Dessert: Codable {
    let idMeal: String
    var strMeal: String
    var strMealThumb: String
    var strInstructions: String?
    var strCategory: String?
    var ingredients: [Ingredient]?
    
    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strMealThumb, strInstructions, strCategory
        case ingredients = "meals"
    }
}

struct Ingredient: Codable {
    let name: String
    let measurement: String
}


struct ContentView: View {
    @State private var desserts = [Dessert]()
    var body: some View {
        NavigationView {
            List(desserts, id: \.idMeal) { dessert in
                NavigationLink {
                    DessertDetailView(dessert: dessert)
                } label: {
                    VStack {
                        Text("\(dessert.strMeal)")
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("FreshDessert")
        }.task {
            if let incomingDesserts = try? await JsonDessertService().getDesserts() {
                desserts = incomingDesserts
            }
            //await loadData()
        }
    }
//    func loadData() async {
//        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
//            print("Incorrect URL. Please try a different link!")
//            return
//        }
//        
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            
//            if data.isEmpty {
//                print("Error: Data is empty")
//                return
//            }
//        
//            if let decoded = try?  JSONDecoder().decode(Response.self, from: data) {
//                // Sets desserts in sorted order
//                withAnimation(.easeIn) {
//                    desserts = decoded.meals.sorted { $0.strMeal < $1.strMeal }
//                }
//                print("desserts JSON: \(desserts)")
//            }
//        } catch {
//            print("Error getting dessert data: \(error.localizedDescription)")
//        }
//    }
}

#Preview {
    ContentView()
}
