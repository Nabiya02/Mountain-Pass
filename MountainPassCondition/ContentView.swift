//
//  ContentView.swift
//  MountainPassCondition
//
//  Created by Nabiya Alam on 1/22/25.
//

// Access code: 2c9055a7-2f71-4fd0-b8e5-3113304a2ebc

import SwiftUI
import UIKit

let apiCall = MountainPassService()

struct Restriction: Codable {
    let RestrictionText: String
    let TravelDirection: String
}

struct MountainPass: Codable {
    let RestrictionTwo: Restriction
    let MountainPassName: String
    let RestrictionOne: Restriction
    let Longitude: Double
    let ElevationInFeet: Int
    let MountainPassId: Int
    let DateUpdated: String
    let WeatherCondition: String
    let TravelAdvisoryActive: Bool
    let RoadCondition: String
    let Latitude: Double
    let TemperatureInFahrenheit: Int?
}

struct ContentView: View {
    @State private var jsonArray: [MountainPass] = []
    @State private var mountainPasses: [(id: Int, name: String)] = [
        (1, "Blewett Pass US 97"),
        (2, "Cayuse Pass SR 123"),
        (3, "Chinook Pass SR 410"),
        (5, "Crystal to Greenwater SR 410"),
        (6, "Mt. Baker Hwy SR 542"),
        (7, "North Cascade Hwy SR 20"),
        (8, "Satus Pass US 97"),
        (9, "Sherman Pass SR 20"),
        (11, "Snoqualmie Pass I-90"),
        (10, "Stevens Pass US 2"),
        (12, "White Pass  US 12"),
        (13, "Manastash Ridge I-82"),
        (14, "Loup Loup Pass SR 20"),
        (15, "Disautel Pass SR 155"),
        (16, "Wauconda Pass SR 20"),
        (17, "Tiger Mountain SR18"),

    ]
    
    @State private var selectedPassId: Int? = nil

    var body: some View {
        VStack {

            Image(systemName: "cloud.snow.fill")
                .imageScale(.large)
                .foregroundStyle(.gray)
            Text("Mountain Pass Conditions")
                .font(.custom("Cochin-Bold", size: 25))
                .fontWeight(.bold)

            Picker("Select mountain pass", selection: $selectedPassId) {
                Text("Select a pass").tag(nil as Int?)
                ForEach(mountainPasses, id: \.id) { mountainPass in
                    Text(mountainPass.name).tag(mountainPass.id)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            Button(action: {
                if let id = selectedPassId {
                    apiCall.getData(id: id) { response in
                        if let responseData = response.data(using: .utf8) {
                            do {
                                let decodedData = try JSONDecoder().decode(
                                    [MountainPass].self, from: responseData)
                                self.jsonArray = decodedData
                                print(self.jsonArray)
                            } catch {
                                print("error:\(error)")
                            }
                        } else {
                            print("Error converting response to Data")
                        }
                    }
                }
            }) {
                Text("Check Conditions")
                    .frame(width: 200, height: 50)
                    .background(Color.button)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            .disabled(selectedPassId == nil)
            .padding(.bottom, 30)

            List(jsonArray, id: \.MountainPassId) { pass in
                Section(header: Text("\(pass.MountainPassName)")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Weather condition: \(pass.WeatherCondition)")
                            .font(.subheadline)
                    
                        Text(
                            "Temperature: \(pass.TemperatureInFahrenheit)°F"
                        )
                        .font(.subheadline)

                        Text("Road Condition: \(pass.RoadCondition)")
                            .font(.subheadline)
                        Text(
                            "Restriction One: \(pass.RestrictionOne.RestrictionText) (\(pass.RestrictionOne.TravelDirection))"
                        )
                        .font(.subheadline)
                        Text(
                            "Restriction Two: \(pass.RestrictionTwo.RestrictionText) (\(pass.RestrictionTwo.TravelDirection))"
                        )
                        .font(.subheadline)
                    }
                }
            }
        }
        .padding(50)
    }
}

#Preview {
    ContentView()
}
