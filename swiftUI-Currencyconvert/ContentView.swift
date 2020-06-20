//
//  ContentView.swift
//  swiftUI-Currencyconvert
//
//  Created by Daniel Bernal on 6/20/20.
//  Copyright © 2020 Daniel Bernal. All rights reserved.
//

import SwiftUI
import TinyNetworking
import Combine

struct FixerData: Codable {
    var rates: [String:Double]
}

let latest = Endpoint<FixerData>(json: .get, url: URL(string: "http://data.fixer.io/api/latest?access_key=7a72246dd8a08d23271b1b46979732d7&format=1")!)

final class Resource<A>: ObservableObject {
        
    let endpoint: Endpoint<A>
    var value: A?
    
    init(endpoint: Endpoint<A>) {
        self.endpoint = endpoint
        reload()
    }
    
    func reload() {
        URLSession.shared.load(endpoint) { result in
            self.value = try? result.get()
        }
    }
}

struct Converter: View {
    let rates: [String: Double]
    
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

struct ProgressIndicator: NSViewRepresentable {
    
    func makeNSView(context: NSViewRepresentableContext<ProgressIndicator>) -> NSProgressIndicator {
        let progressIndicator = NSProgressIndicator()
        progressIndicator.startAnimation(nil)
        progressIndicator.style = .spinning
        return progressIndicator
    }
    
    func updateNSView(_ nsView: NSProgressIndicator, context: Context) {
        
    }
  
}

struct ContentView: View {
    @ObservedObject var resource = Resource(endpoint: latest)
    var body: some View {
        Group {
            if resource.value == nil {
                VStack {
                    Text("Loading...")
                    ProgressIndicator()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Converter(rates: resource.value!.rates)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
