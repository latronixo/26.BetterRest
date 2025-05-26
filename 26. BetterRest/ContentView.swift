//
//  ContentView.swift
//  26. BetterRest
//
//  Created by Валентин on 21.05.2025.
//

import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime    //дата просыпания (при открытии приложения = 7:00)
    @State private var sleepAmount = 8.0    //продолжительность сна
    @State private var coffeeAmount = 0     //количество выпитых чашек кофе в течение дня
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationStack{
            Form {
                Section {
                     DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                } header: {
                    Text("Когда ты хочешь проснуться?")
                        .font(.headline)
                }

                Section {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                } header: {
                    Text("Желаемая длительность сна")
                        .font(.headline)
                }

                Section {
                    Picker("Дневное потребление кофе", selection: $coffeeAmount) {
                        ForEach(0...20, id: \.self) {
                            Text("^[\($0) cup](inflect: true)")
                        }
                    }
                    .pickerStyle(.menu)
                } //header: {
                    //Text("Ежедневное потребление кофе")
                      //  .font(.headline)
                //}
            }
            .navigationTitle("Лучший отдых")
            .toolbar {
                Button("Рассчитать", action: calculateBedtime)
                
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
        
    }
    
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            //рассчитываем, сколько осталось времени до подъема (в часах и минутах)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            //переводим часы (составляющую от времени просыпания) в секунды
            let hour = (components.hour ?? 0) * 60 * 60
            //переводим минуты (составляющую от времени просыпания) в секунды
            let minute = (components.minute ?? 0) * 60
            
            //на основе машинного обучения ML получаем, какая длительность сна нужна для лучшего отдыха
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            //время отхода ко сну = время просыпания - нужная длительность сна
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Твое идеальное время отхода ко сну..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
             alertMessage = "Sorry, there was a problem calculating your bedtime"
        }
        showingAlert = true
    }
}

#Preview {
    ContentView()
}
