import SafariServices
import SwiftUI

struct SafariView: UIViewControllerRepresentable {
    let url: URL?

    func makeUIViewController(context _: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        let safariViewController = SFSafariViewController(url: url ?? URL(string: "https://example.com")!)
        return safariViewController
    }

    func updateUIViewController(_: SFSafariViewController, context _: UIViewControllerRepresentableContext<SafariView>) {}
}

struct NewsItemView: View {
    let news: News
    @State private var image: UIImage? = nil
    @State private var showSafariView = false

    var body: some View {
        ZStack {
            Color("MainColor")
                .cornerRadius(10)

            VStack(alignment: .leading) {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .padding(.bottom, 10)
                }
                Text(news.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                Text(truncatedBody(from: news.body))
                    .font(.body)
                Text(Helper.format(timeInterval: news.timePublished))
                    .font(.footnote)
                    .foregroundColor(.white)
                    .padding(.top, 2)
            }
            .padding()
            .onAppear {
                fetchImage()
            }
            .onTapGesture {
                showSafariView = true
            }
        }
        .sheet(isPresented: $showSafariView) {
            SafariView(url: URL(string: news.sourceURL))
        }
    }

    private func truncatedBody(from body: String) -> String {
        if body.count > 300 {
            let index = body.index(body.startIndex, offsetBy: 300)
            return String(body[..<index]) + "..."
        } else {
            return body
        }
    }

    private func fetchImage() {
        guard let url = URL(string: news.imageURL) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    image = uiImage
                }
            }
        }.resume()
    }
}
