//
//  ContentView.swift
//  FreshDesserts
//
//  Created by jpzoll on 10/11/2023.
//

import SwiftUI

struct ContentView: View {
    // * MARK: - Welcome to FreshDesserts!
    // Here is the home page for the app. You will find a list
    // of all your favorite dishes right here!
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
        }
        .task {
    // Fetch desserts from the API and update the state
            if let incomingDesserts = try? await JSONDessertService().getDesserts() {
                withAnimation {
                    desserts = incomingDesserts
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
