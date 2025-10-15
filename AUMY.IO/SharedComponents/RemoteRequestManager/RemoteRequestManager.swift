//
//  Untitled.swift
//  AUMY.IO
//
//  Created by iOS Developer on 15/10/25.
//

import Foundation

class RemoteRequestManager {
    
    static var shared = RemoteRequestManager()
    
    func dataTask<Model: Codable> (endpoint: Endpoints,
                                   tail: String? = nil,
                                   model: Model.Type,
                                   params: [String: Any]? = nil,
                                   method: HttpMehtods = .get) async -> Result<Model, Error> {
        var completeURL = "\(baseURL())/\(endpoint.rawValue)"
        if let tail {
            completeURL = "\(completeURL)/\(tail)"
        }
        guard let url = URL(string: completeURL)
        else { return .failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)) }
        var urlRequest = URLRequest(url: url)
        var headers = ["Content-Type": "application/json", "Accept": "application/json"]
        if let accessToken = UserDefaults.standard[.accessToken] {
            headers["Bearer"] = accessToken
        }
        
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = nil

        switch method {
        case .get: break
        case .post, .put:
            if let params { urlRequest.httpBody = params.percentEncoding() }
        case .delete:
            if let params { urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params) }
        }

        LogHandler.requestLog(urlRequest)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let decodedData = try JSONDecoder().decode(Model.self, from: data)
            return .success(decodedData)
        }
        catch(let error) {
            return .failure(error)
        }
    }
    
    fileprivate func getKeyValue(by key: String) -> (NSDictionary?, Any?) {
        guard let path = Bundle.main.path(forResource: "AppVault", ofType: "plist")
        else { return (nil, nil) }
        let dict = NSDictionary(contentsOfFile: path)
        let keyValue = dict?[key] as? Any
        return (dict, keyValue)
    }
    
    fileprivate func baseURL() -> String {
        let info = getKeyValue(by: "App_Environment")
        let keyValue = info.1 as? [String: Bool]
        let env = keyValue?.first(where: { $0.value })?.key ?? ""
        let baseURL = "\(env)_Base_URL"
        return getKeyValue(by: baseURL).1 as? String ?? baseURL
    }
}

extension Dictionary {
    fileprivate func percentEncoding() -> Data {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)!
    }
}
