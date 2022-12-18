import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


class LoginService: ObservableObject {
    
    static let shared = LoginService()
    var token: String = ""
    func login(username: String, password: String) -> Void {
        
        let json = [[
            "key": "username",
            "value": username,
            "type": "text"
        ],
        [
            "key": "password",
            "value": password,
            "type": "text"
        ]]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        guard let url = URL(string: "http://127.0.0.1:8000/auth/token/login/") else { fatalError("Missing URL") }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = jsonData
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedToken = try JSONDecoder().decode(String.self, from: data)
                        self.token = decodedToken
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }

        dataTask.resume()
    }
}
