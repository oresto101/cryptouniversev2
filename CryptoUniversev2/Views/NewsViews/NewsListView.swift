import SwiftUI

struct NewsListView: View {
    @StateObject private var viewModel = NewsViewModel()

    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.newsItems) { news in
                        NewsItemView(news: news)
                            .padding()
                            .background(Color("MainColor"))
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .onAppear {
                viewModel.fetchNews()
            }
        }
    }
}
