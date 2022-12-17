import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


class LoginService: ObservableObject {
    
    static let shared = LoginService()
    var token: String = ""
    func login(username: String, password: String) -> Void {
        let semaphore = DispatchSemaphore (value: 0)
        
        let parameters = [
            [
                "key": username,
                "value": "root",
                "type": "text"
            ],
            [
                "key": password,
                "value": "root",
                "type": "text"
            ]] as [[String : Any]]
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var error: Error? = nil
        for param in parameters {
            if param["disabled"] == nil {
                let paramName = param["key"]!
                body += "--\(boundary)\r\n"
                body += "Content-Disposition:form-data; name=\"\(paramName)\""
                if param["contentType"] != nil {
                    body += "\r\nContent-Type: \(param["contentType"] as! String)"
                }
                let paramType = param["type"] as! String
                if paramType == "text" {
                    let paramValue = param["value"] as! String
                    body += "\r\n\r\n\(paramValue)\r\n"
                } else {
                    let paramSrc = param["src"] as! String
                    let fileData = try? NSData(contentsOfFile:paramSrc, options:[]) as Data
                    let fileContent = String(data: fileData!, encoding: .utf8)!
                    body += "; filename=\"\(paramSrc)\"\r\n"
                    + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
                }
            }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/auth/token/login/")!,timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
            self.token = data.base64EncodedString()
            print(String(data: data, encoding: .utf8)!)
            semaphore.signal()
        }
    }
}
