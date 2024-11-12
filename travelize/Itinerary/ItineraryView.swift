//
//  ItineraryView.swift
//  travelize_gemini
//
//  Created by Kavya Subramanian on 11/12/24.
//

import SwiftUI
import GoogleGenerativeAI

struct ItineraryDay: Identifiable {
    let id = UUID()
    let date: Date
    var activities: [String] = []
}

struct ItineraryView: View {
    @State private var textInput = ""
    @State private var response: String = "Hello! How can I help you today?"
    @State private var isThinking: Bool = false
    @State var itineraryDays: [ItineraryDay] = []
    
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    
    let city: String
    let startDate: Date
    let endDate: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                VStack {
                    Text(response)
                        .font(.system(.body, design: .rounded, weight: .medium))
                        .opacity(isThinking ? 0.2 : 1.0)
                }
            }
        }
        .onAppear{
            generateItinerary()
        }
    }
    
    func generateItinerary() {
        response = "Thinking..."
        
        let numberOfDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        textInput = createPrompt(city: city, numberOfDays: numberOfDays + 1)

        withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
            isThinking.toggle()
        }
        
        Task {
            do {
                let generatedResponse = try await model.generateContent(textInput)

                guard let text = generatedResponse.text else  {
                    textInput = "Sorry, Gemini got some problems.\nPlease try again later."
                    return
                }

                textInput = ""
                
                response = text
                
                isThinking.toggle()
            } catch {
                response = "Something went wrong!\n\(error.localizedDescription)"
            }
        }
        
        parseAndUpdateItinerary(response: response, startDate: startDate, numberOfDays: numberOfDays)
    }
    
    private func createPrompt(city: String, numberOfDays: Int) -> String {
        """
        Create a detailed \(numberOfDays)-day itinerary for \(city). For each day, provide 4-5 activities or attractions, including:
        - Morning activity
        - Lunch recommendation
        - Afternoon activity
        - Evening activity or dinner recommendation
        
        Format the response as Day 1: followed by activities, Day 2: etc.
        Include specific attraction names and approximate time durations.
        Consider logical geographical flow of activities within the city.
        """
    }
    
    private func parseAndUpdateItinerary(response: String, startDate: Date, numberOfDays: Int) {
       var newItineraryDays: [ItineraryDay] = []

       let dayStrings = response.components(separatedBy: "Day")
           .filter { !$0.isEmpty }

       for (index, dayString) in dayStrings.enumerated() {
           guard index < numberOfDays else { break }

           let currentDate = Calendar.current.date(byAdding: .day, value: index, to: startDate) ?? startDate
           var day = ItineraryDay(date: currentDate)

           // Split activities by newlines and clean up
           let activities = dayString
               .components(separatedBy: .newlines)
               .map { $0.trimmingCharacters(in: .whitespaces) }
               .filter { !$0.isEmpty && !$0.hasPrefix("Day") }

           day.activities = activities
           newItineraryDays.append(day)
       }

       itineraryDays = newItineraryDays
   }
   
}


