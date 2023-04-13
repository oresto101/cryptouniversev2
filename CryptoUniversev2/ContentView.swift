import Network
import SwiftUI

class NetworkMonitor {
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor")

    var isConnected: Bool {
        monitor.currentPath.status == .satisfied
    }

    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { _ in
            // add NotificationCenter
        }
        monitor.start(queue: queue)
    }
}

struct ContentView: View {
    let networkMonitor = NetworkMonitor()

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

                Text("No Internet Connection")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
