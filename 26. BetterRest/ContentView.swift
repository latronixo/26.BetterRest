//
//  ContentView.swift
//  26. BetterRest
//
//  Created by Валентин on 21.05.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var sleepAmount = 8.0    //всего сна, часов
    
    var body: some View {
        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
    }
}

#Preview {
    ContentView()
}
