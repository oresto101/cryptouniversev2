import Combine
import Network
import SwiftUI

class NetworkMonitor: ObservableObject {
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor")

    @Published var isConnected: Bool = false

    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
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
