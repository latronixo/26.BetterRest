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
        DatePicker("Please enter a date", selection: $wakeUp, in: Date.now...)
            .labelsHidden()
    }
    
    func exampleDates() {
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        let date = Calendar.current.date(from: components) ?? .now 
    }
}

#Preview {
    ContentView()
}
