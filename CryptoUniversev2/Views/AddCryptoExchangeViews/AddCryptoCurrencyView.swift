import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


import SwiftUI



struct AddCryptoCurrencyView: View {
    var loginService = LoginService.shared
    @State private var cryptoCode: String = ""
    @State private var quantity: String = "0"
    @State private var loading = false;
    @State private var loaded = false;
    @State private var loadedWithError = false;

    var body: some View {
        if loaded{
            MainView().navigationBarBackButtonHidden(true)
        }
        else{
            ZStack (){
                Color("BackgroundColor").ignoresSafeArea()
                List {
                    Section{
                        TextField(
                            "Cryptocurrency code",
                            text: $cryptoCode)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        TextField(
                            "Quantity",
                            text: $quantity)
                        .keyboardType(.decimalPad)
                    }
                    Button ("Add cryptocurrency"){
                        addCryptocurrency(cryptoCode: cryptoCode, quantity: quantity)
                    }
                    
                    .disabled(quantity.isEmpty || cryptoCode.isEmpty)
                }
                .scrollContentBackground(.hidden)
            }
            .alert("Fake credentials", isPresented: self.$loadedWithError) {
                Button("Dismiss"){
                }
            }
        }
    }
    
    func addCryptocurrency(cryptoCode: String, quantity: String) -> Void {let
        parameters = [
            [
                "key": "coin",
                "value": cryptoCode,
                "type": "text"
            ],
            [
                "key": "quantity",
                "value": quantity,
                "type": "text"
            ]] as [[String : Any]]
        
        print(parameters)
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var _: Error? = nil
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
                    let fileData = try! NSData(contentsOfFile:paramSrc, options:[]) as Data
                    let fileContent = String(data: fileData, encoding: .utf8)!
                    body += "; filename=\"\(paramSrc)\"\r\n"
                    + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
                }
            }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/api/v1/wallet/")!,timeoutInterval: Double.infinity)
        request.addValue("Token 6e0e21a9458e2f24028797f2dcbe45b3bfa59447", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let _: Void = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                if let error = error {
                    print("Request error: ", error)
                    return
                }
                loading = false
                loaded=true
            }else{
                loadedWithError = true
                loading=false
            }
        }.resume()
    }
}
struct AddCryptoCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        AddCryptoCurrencyView()
    }
}
