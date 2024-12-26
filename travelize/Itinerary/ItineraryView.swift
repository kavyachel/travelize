import SwiftUI
import GoogleGenerativeAI


struct ItineraryView: View {
    @State private var textInput = ""
    @State private var response: String = ""
    @State private var isThinking: Bool = false
    @State var itineraryDays: [ItineraryDay] = []
    
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    let city: String
    let startDate: Date
    let endDate: Date
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter
    }()
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)

            LinearGradient(gradient: Gradient(colors: [Color.clear, Color.cyan.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            if itineraryDays.isEmpty {
                LoadingView()
            } else {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(itineraryDays) { day in
                            DayCardView(day: day, dateFormatter: dateFormatter)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            generateItinerary()
        }
    }

    func generateItinerary() {
        
        let numberOfDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        textInput = createPrompt(city: city, numberOfDays: numberOfDays + 1, startDate: startDate, endDate: endDate)
        
        Task {
            do {
                let generatedResponse = try await model.generateContent(textInput)

                guard let text = generatedResponse.text else {
                    textInput = "Sorry, Gemini got some problems.\nPlease try again later."
                    return
                }

                response = text
                parseAndUpdateItinerary(response: text, startDate: startDate, numberOfDays: numberOfDays)
                isThinking.toggle()
            } catch {
                response = "Something went wrong!\n\(error.localizedDescription)"
            }
        }
    }
    
    private func createPrompt(city: String, numberOfDays: Int, startDate: Date, endDate: Date) -> String {
        """
        Create a detailed \(numberOfDays)-day itinerary for \(city) from \(startDate) to \(endDate). Take the season into consideration. Format each activity exactly like this, with no asterisks or special characters:
        
        Day 1:
        9:00 AM - Central Park Walking Tour
        Explore the iconic park's main attractions including Bethesda Fountain and Bow Bridge.
        
        12:00 PM - Lunch at Local Cafe
        Enjoy fresh local cuisine in a cozy atmosphere.
        
        2:00 PM - Museum Visit
        Discover world-class exhibits and artifacts.
        
        7:00 PM - Dinner at Famous Restaurant
        Experience local flavors in an elegant setting.
        
        [Continue with remaining days in exactly the same format]
        
        Important:
        - Use exact times (like 9:00 AM)
        - Include a simple description on the next line
        - No asterisks or special characters
        - Keep activities in chronological order
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
            
            let activityStrings = dayString
                .components(separatedBy: "\n\n")
                .filter { !$0.isEmpty && !$0.contains("Day") }
            
            let activities = activityStrings.compactMap { activityString -> Activity? in
                
                let lines = activityString
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .components(separatedBy: .newlines)
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
                
                guard let firstLine = lines.first else { return nil }
                
                let components = firstLine.components(separatedBy: " - ")
                guard components.count >= 2 else { return nil }
                
                let time = components[0]
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: "*", with: "")
                
                let title = components[1]
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: "*", with: "")
                
                let description = lines.count > 1 ? lines[1]
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: "*", with: "") : nil
                
                return Activity(time: time, title: title, description: description)
            }
            
            day.activities = activities
            newItineraryDays.append(day)
        }
        
        DispatchQueue.main.async {
            self.itineraryDays = newItineraryDays
        }
    }
}

struct ItineraryView_Previews: PreviewProvider {
    static var previews: some View {
        ItineraryView(city: "New York City",
                      startDate: Date.now,
                      endDate: Date.now.addingTimeInterval(86400))
    }
}
