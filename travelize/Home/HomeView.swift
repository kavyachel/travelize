//
//  HomeView.swift
//  travelize
//
//  Created by Kavya Subramanian on 11/12/24.
//

import SwiftUI

struct HomeView: View {
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var selectedCity: String = ""
        
    let cities = [
        "New York",
        "London",
        "Tokyo",
        "Paris",
        "Dubai",
        "Singapore",
        "Sydney"
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("✈️")
                    .font(.system(size: 60))
                    .padding(.top, 40)
                
                Text("Plan Your Trip")
                    .font(.title)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Destination")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Picker("Select a city", selection: $selectedCity) {
                        Text("Choose a city").tag("")
                        ForEach(cities, id: \.self) { city in
                            Text(city).tag(city)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 1)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Dates")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    VStack(spacing: 16) {
                        DatePicker(
                            "Departure",
                            selection: $startDate,
                            displayedComponents: [.date]
                        )
                        
                        DatePicker(
                            "Return",
                            selection: $endDate,
                            in: startDate...,
                            displayedComponents: [.date]
                        )
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 1)
                }
                .padding(.horizontal)
                
                NavigationLink(destination: ItineraryView(city: selectedCity,
                                                          startDate: startDate,
                                                          endDate: endDate)) {
                    Text("Generate Itinerary")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            selectedCity.isEmpty ? Color.gray : Color.blue
                        )
                        .cornerRadius(10)
                        .shadow(radius: 2)
                }
                .disabled(selectedCity.isEmpty)
                .padding(.horizontal)
                .padding(.top, 20)
                
                Spacer()
            }
            .background(Color(.systemGroupedBackground))
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
