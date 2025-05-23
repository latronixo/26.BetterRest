//
//  ContentView.swift
//  26. BetterRest
//
//  Created by Валентин on 21.05.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = Date.now    //даты просыпания
    @State private var sleepAmount = 8.0    //продолжительность сна
    @State private var coffeeAmount = 1     //количество выпитых чашек кофе в течение дня
    
    var body: some View {
        NavigationStack{
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Text("Desired amount of sleep")
                    .font(.headline)
                
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                
                Text("Daile coffee instake")
                    .font(.headline)
                
                Stepper("\(coffeeAmount) cup(s)", value: $coffeeAmount, in: 1...20)
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedtime)
                
            }
        }
        
    }
    
    func calculateBedtime() {
        
    }
}

#Preview {
    ContentView()
}
