//
//  ActivityRowView.swift
//  travelize
//
//  Created by Kavya Subramanian on 11/18/24.
//

import SwiftUI

struct Activity: Identifiable {
    let id = UUID()
    let time: String
    let title: String
    let description: String?
}

struct ActivityRowView: View {
    let activity: Activity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                // Time
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                    Text(activity.time)
                }
                .font(.subheadline)
                .foregroundColor(Color(UIColor.secondaryLabel))
                .frame(width: 100, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 4) {
                    // Title
                    Text(activity.title)
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(Color(UIColor.label))
                        .fontWeight(.medium)
                    
                    // Description
                    if let description = activity.description {
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                            .padding(.top, 2)
                    }
                }
            }
            
            Divider()
        }
    }
}
