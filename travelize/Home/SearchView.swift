//
//  SearchView.swift
//  travelize
//
//  Created by Kavya Subramanian on 11/18/24.
//

import SwiftUI

struct SearchView: View {
    let didSelectCity: (String) -> Void
    @State private var searchText = ""
    @FocusState private var isFocused: Bool
    
    var filteredCities: [String] {
        if searchText.isEmpty {
            return []
        } else {
            return cities
                .filter { $0.localizedCaseInsensitiveContains(searchText) }
                .prefix(3)
                .map { $0 }
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Choose your location")
                    .font(.body)
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .bold()
                
                //Search bar
                HStack(spacing: 8) {
                    TextField("Search a City", text: $searchText)
                        .textFieldStyle(.plain)
                        .focused($isFocused)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            isFocused = true // Keep focus after clearing
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color(.systemGray3))
                                .font(.system(size: 16))
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray5).opacity(0.2))
                )
                
                if !filteredCities.isEmpty && isFocused {
                    VStack(spacing: 0) {
                        ForEach(filteredCities, id: \.self) { city in
                            Button(action: {
                                searchText = city
                                isFocused = false
                                didSelectCity(city)
                            }) {
                                HStack {
                                    Text(city)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 12)
                                .background(Color(.systemGray5).opacity(0.6))
                            }
                            
                            if city != filteredCities.last {
                                Divider()
                                    .padding(.horizontal, 12)
                            }
                        }
                    }
                    .background(Color(.systemGray5).opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: Color(.systemGray5).opacity(0.1), radius: 5, x: 0, y: 5)
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
        .animation(.linear, value: filteredCities)
    }
    
}
