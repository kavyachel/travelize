//
//  SearchView.swift
//  travelize
//
//  Created by Kavya Subramanian on 11/18/24.
//

import SwiftUI

struct SearchView: View {
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
            VStack(spacing: 0) {
                TextField("Search cities...", text: $searchText)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                    )
                    .focused($isFocused)
                
                if !filteredCities.isEmpty && isFocused {
                    VStack(spacing: 0) {
                        ForEach(filteredCities, id: \.self) { city in
                            Button(action: {
                                searchText = city
                                isFocused = false
                            }) {
                                HStack {
                                    Text(city)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 12)
                                .background(Color(.systemBackground))
                            }
                            
                            if city != filteredCities.last {
                                Divider()
                                    .padding(.horizontal, 12)
                            }
                        }
                    }
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .transition(.opacity)
                }
            }
        }
        .padding(.horizontal)
        .animation(.easeInOut(duration: 0.2), value: filteredCities)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
