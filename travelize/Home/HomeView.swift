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
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)

                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.cyan.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("✈️")
                        .font(.system(size: 60))
                        .padding(.top)
                    //Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Plan Your Trip")
                            .font(.title)
                            .bold()
                            .foregroundColor(Color(UIColor.label))
                            .padding(.horizontal)
                            .padding(.top)
                        
                        //Search bar
                        SearchView(){ city in
                            self.selectedCity = city
                        }
                        
                        //Datepickers
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Choose your dates")
                                .font(.body)
                                .foregroundColor(Color(UIColor.secondaryLabel))
                                .bold()
                            
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
                        .padding(.horizontal)
                        
                        //Button
                        NavigationLink(destination: ItineraryView(city: selectedCity,
                                                                  startDate: startDate,
                                                                  endDate: endDate)) {
                            Text("Generate Itinerary")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    selectedCity.isEmpty ? Color.gray.gradient : Color.blue.opacity(0.8).gradient
                                )
                                .cornerRadius(10)
                                .shadow(radius: 2)
                            
                        }
                          .disabled(selectedCity.isEmpty)
                          .padding(.all)
                          .navigationBarHidden(true)
                    }
                    .background(Color.cyan.opacity(0.75))
                    .cornerRadius(20)
                    .shadow(color: Color(UIColor.tertiarySystemFill), radius: 8)
                }
                .padding(.all)
            }
        }
    }
    
    var results: [String] {
      selectedCity.isEmpty ? cities : cities.filter { $0.contains(selectedCity) }
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
