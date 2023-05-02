import Foundation

struct News: Codable, Identifiable {
    let id: String
    let imageURL: String
    let title: String
    let body: String
    let timePublished: TimeInterval
    let sourceURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "imageurl"
        case title
        case body
        case timePublished = "published_on"
        case sourceURL = "url"
    }
}

struct NewsApiResponse: Codable {
    let Data: [News]
}
