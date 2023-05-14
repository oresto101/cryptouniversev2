import SwiftUI

struct HView: View {
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
                        HelpView()
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
                .navigationBarTitle("Help", displayMode: .inline)
                .navigationBarItems(leading: (
                    Button(action: {
                        withAnimation {
                            showMenu.toggle()
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
