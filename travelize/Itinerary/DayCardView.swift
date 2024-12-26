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
            HStack {
                Image(systemName: "calendar")
                Text(dateFormatter.string(from: day.date))
                    .font(.headline)
                    .foregroundColor(Color(UIColor.label))
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.cyan.opacity(0.75))
            
            // Activities
            VStack(alignment: .leading, spacing: 15) {
                ForEach(day.activities) { activity in
                    ActivityRowView(activity: activity)
                }
            }
            .padding()
        }
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color(UIColor.tertiarySystemFill), radius: 8)
    }
}
