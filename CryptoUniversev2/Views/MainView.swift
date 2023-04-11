import SwiftUI

struct MainView: View {
    @State var showMenu = false

    var body: some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        self.showMenu = false
                    }
                }
            }

        return ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            NavigationView {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        HomeView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .offset(x: self.showMenu ? geometry.size.width * 3 / 4 : 0)
                            .disabled(self.showMenu ? true : false)
                            .onAppear {
                                self.showMenu = false
                            }
                        if self.showMenu {
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
                        withAnimation {
                            self.showMenu.toggle()
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
