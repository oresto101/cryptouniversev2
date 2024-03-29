import SwiftUI

struct ACCYView: View {
    @State var showMenu = false

    var body: some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        showMenu = false
                    }
                }
            }

        return ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            NavigationView {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        AddCryptoCurrencyView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .offset(x: showMenu ? geometry.size.width * 3 / 4 : 0)
                            .disabled(showMenu ? true : false)
                            .onAppear {
                                showMenu = false
                            }
                        if showMenu {
                            MenuView()
                                .frame(width: geometry.size.width * 3 / 4)
                                .transition(.move(edge: .leading))
                        }
                    }
                    .gesture(drag)
                }
                .navigationBarTitle("Crypto Universe", displayMode: .inline)
                .navigationBarItems(leading: (
                    Button(action: {
                        // Wrap the state update in a DispatchQueue.main.async block
                        DispatchQueue.main.async {
                            withAnimation {
                                showMenu.toggle()
                            }
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                    }
                ))
            }
        }
    }
}
