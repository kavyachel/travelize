//
//  DayCardView.swift
//  travelize
//
//  Created by Kavya Subramanian on 11/17/24.
//

import SwiftUI

struct ItineraryDay: Identifiable {
    let id = UUID()
    let date: Date
    var activities: [Activity] = []
}

struct DayCardView: View {
    let day: ItineraryDay
    let dateFormatter: DateFormatter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Day Header
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.blue)
                Text(dateFormatter.string(from: day.date))
                    .font(.headline)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            
            // Activities
            VStack(alignment: .leading, spacing: 15) {
                ForEach(day.activities) { activity in
                    ActivityRowView(activity: activity)
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 2)
    }
}
