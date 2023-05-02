import Foundation

class NewsViewModel: ObservableObject {
    @Published var newsItems: [News] = []

    func fetchNews() {
        let urlString = "https://min-api.cryptocompare.com/data/v2/news/?lang=EN"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data {
                let decoder = JSONDecoder()
                do {
                    let newsApiResponse = try decoder.decode(NewsApiResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.newsItems = newsApiResponse.Data
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            } else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        task.resume()
    }
}
