import SwiftUI

struct RunView: View {
    var algorithm: Algorithm
    @State var sample1 = sampleInt
    @State var sample2 = sampleString
    @State var result: [Event]? = nil
    @State private var loading = false
    
    var duration: TimeInterval {
        (sample1 + sample2 + (result ?? [])).lazy.map { $0.time }.max() ?? 1
    }
    
    var body: some View {
        VStack {
            TimelineView(events: $sample1, duration: duration)
            TimelineView(events: $sample2, duration: duration)
            TimelineView(events: .constant(result ?? []), duration: duration)
                .drawingGroup()
                .opacity(loading ? 0.5 : 1)
                .animation(.default, value: result)
        }
        .padding(20)
        .task(id: sample1 + sample2) {
            loading = true
            result = await run(algorithm: algorithm, sample1, sample2)
            loading = false
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            List(Algorithm.allCases) { algo in
                NavigationLink(algo.rawValue) {
                    RunView(algorithm: algo)
                }
            }
            .listStyle(.sidebar)
        }
    }
}
