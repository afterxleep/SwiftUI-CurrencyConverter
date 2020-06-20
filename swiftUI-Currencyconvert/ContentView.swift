//
//  ContentView.swift
//  swiftUI-Currencyconvert
//
//  Created by Daniel Bernal on 6/20/20.
//  Copyright © 2020 Daniel Bernal. All rights reserved.
//

import SwiftUI

struct Converter: View {
    let rates: [String: Double] = ["USD": 1.13, "GBP" : 0.089]
    
    @State var text: String = "100"
    @State var selection: String = "USD"
    
    var rate: Double {
        rates[selection]!
    }
    
    let formatter: NumberFormatter = {
       let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencySymbol = ""
        return f
    }()
    
    var parsedInput: Double? {
        Double(text)
    }
    
    var output: String {
        parsedInput.flatMap { formatter.string(from: NSNumber(value: $0 * self.rate)) } ?? "Parse Error"
    }
    
    
    var body: some View {
        VStack {
            HStack {
                TextField("Field", text: $text).frame(width: 100)
                Text("EUR")
                Text("=")
                Text(output)
                Text(selection)
            }
            Picker(selection: $selection, label: Text("")) {
                ForEach(self.rates.keys.sorted(), id: \.self) { key in
                    HStack {
                        Text(key)
                    }
                }
            }
        }
        
    }
}

struct ContentView: View {
    var body: some View {
        Converter()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
