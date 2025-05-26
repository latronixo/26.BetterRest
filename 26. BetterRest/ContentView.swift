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
    
    private var goingToBed: Date {
        get {
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
                
                return sleepTime
            } catch {
                // Логирование ошибки
                print("⚠️ Ошибка при расчете времени сна: \(error.localizedDescription)")
                
                // Отладочная информация
                #if DEBUG
                print("""
                Детали ошибки:
                - Время пробуждения: \(wakeUp)
                - Продолжительность сна: \(sleepAmount) часов
                - Чашек кофе: \(coffeeAmount)
                """)
                #endif
                
                // Возвращаем fallback-значение с предупреждением
                let fallbackTime = wakeUp - sleepAmount
                print("⚠️ Используется fallback время: \(fallbackTime)")
                
                return fallbackTime
            }
        }
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
                    Picker("Кофе выпито в течение дня", selection: $coffeeAmount) {
                        ForEach(0...20, id: \.self) {
                            Text("^[\($0) cup](inflect: true)")
                        }
                    }
                }
                
                Section {
                    Text(goingToBed.formatted(date: .omitted, time: .shortened))
                        .font(.largeTitle)
                } header: {
                    Text("Твое идеальное время отхода ко сну:")
                        .font(.headline)
                }
            }
            .navigationTitle("Лучший отдых")
        }
    }
}

#Preview {
    ContentView()
}
