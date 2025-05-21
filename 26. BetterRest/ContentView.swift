//
//  ContentView.swift
//  26. BetterRest
//
//  Created by Валентин on 21.05.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = Date.now    //даты просыпания
    
    var body: some View {
        Text(Date.now, format: .dateTime.hour().minute())
    }
    func exampleDates() {
//        var components = DateComponents()
//        components.hour = 8
//        components.minute = 0
//        let date = Calendar.current.date(from: components) ?? .now
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: .now)
        let hour = components.hour ?? 0
        let minute = components.minute
    }
}

#Preview {
    ContentView()
}
