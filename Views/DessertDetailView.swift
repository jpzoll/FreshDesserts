//
//  DessertDetailView.swift
//  FreshDesserts
//
//  Created by jpzoll on 10/11/2023.
//

import SwiftUI

struct DessertDetailView: View {
    @State private var detailedDessert: Dessert?

    var dessert: Dessert

    var body: some View {
        ScrollView {
            VStack {
            // 🌄 Header Section
                VStack {
                    AsyncImage(url: URL(string: detailedDessert?.strMealThumb ?? "")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .transition(.push(from: .top))
                                .padding()
                        } else if phase.error != nil {
                            Text("[Insert Image Here]")
                        }
                    }
                    .scaledToFit()
                    
                    Divider()
                    
            // 🍨 Dessert Name Section
                    if let dessertName = detailedDessert?.strMeal {
                        Text("\(dessertName)")
                            .font(.largeTitle.bold())
                    }
                    
                    Divider()
                    
            // 📜 Instructions Section
                    VStack(alignment: .leading) {
                        if let dessertInstructions = detailedDessert?.strInstructions {
                            VStack(alignment: .leading) {
                                Text("Instructions")
                                    .font(.title2.bold().italic())
                                Text("\(dessertInstructions)")
                            }
                        }
                        Divider()
                        
            // 🥄 Ingredients Section
                        if let detailedDessert = detailedDessert {
                            VStack(alignment: .leading) {
                                Text("Ingredients")
                                    .font(.title2.bold().italic())
                                ForEach(detailedDessert.ingredientMeasurements, id: \.self) { ingredient in
                                    HStack {
                                        Image(systemName: "circle.fill")
                                        Text(ingredient)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .animation(.easeOut(duration: 1))
                
            // 📝 Additional Text Section
            }
        }
        .onAppear {
            // 🔄 Loading up Desert from API Endpoint
            Task {
                detailedDessert = try await JSONDessertService().getDessertDetails(for: dessert)
            }
        }
    }
}


//#Preview {
//    DessertDetailView(dessert: Dessert.desserts[0])
//}
