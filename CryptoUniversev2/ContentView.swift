import Combine
import Network
import SwiftUI

class NetworkMonitor: ObservableObject {
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private var isConnectedPending: Bool = false
    private var delayWorkItem: DispatchWorkItem?

    @Published var isConnected: Bool = true

    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
    
    private func updateConnectionStatus(_ isConnected: Bool) {
            if isConnected {
                isConnectedPending = true
                delayWorkItem?.cancel()

                // Delay for 5 seconds before notifying the view
                delayWorkItem = DispatchWorkItem { [weak self] in
                    self?.notifyConnected()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: delayWorkItem!)
            } else {
                isConnectedPending = false
                delayWorkItem?.cancel()
                notifyDisconnected()
            }
        }

        private func notifyConnected() {
            isConnected = isConnectedPending
        }

        private func notifyDisconnected() {
            isConnected = false
        }
    
}

struct ContentView: View {
    @StateObject var networkMonitor = NetworkMonitor()

    var body: some View {
        if networkMonitor.isConnected {
            ZStack {
                Color("BackgroundColor").ignoresSafeArea()
                MainView()
            }
        } else {
            ZStack {
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                    
                    Text("No Internet Connection")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
