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
                                   method: HttpMehtods = .get,
                                   body: HttpBodyType = .urlEncoded,
                                   medias: [Media] = []) async -> Result<Model, Error> {
        
        guard let baseURL = baseURL(), !baseURL.isEmpty
        else { return .failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)) }
        var completeURL = "\(baseURL)/\(endpoint.rawValue)"
        if let tail { completeURL = "\(completeURL)/\(tail)" }
        guard let url = URL(string: completeURL)
        else { return .failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)) }
        var urlRequest = URLRequest(url: url)
        var headers = ["Content-Type": "application/json", "Accept": "application/json"]
        if let accessToken = UserDefaults.standard[.accessToken] {
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = nil
        
        switch method {
        case .get: break
        case .post, .put:
            switch body {
            case .rawJSON:
                if let params {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                        urlRequest.httpBody = jsonData
                    }
                    catch(let error) { return .failure(error) }
                }
                
            case .formData:
                var body = Data()
                let boundary = UUID().uuidString
                if let params {
                    for(key, value) in params {
                        body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                        body.append("\(value)".data(using: .utf8)!)
                    }
                }
                
                if !medias.isEmpty {
                    for media in medias {
                        body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                        body.append("Content-Disposition: form-data; name=\"\(media.keyname)\"; filename=\"\(media.filename)\"\r\n".data(using: .utf8)!)
                        body.append("Content-Type: \(media.contentType)\r\n\r\n".data(using: .utf8)!)
                        body.append(media.data)
                    }
                }
                
                body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
                
                urlRequest.httpBody = body
                
            default: if let params { urlRequest.httpBody = params.percentEncoding() }
            }
            
        case .delete:
            if let params { urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params) }
        }
        
        LogHandler.requestLog(urlRequest)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            LogHandler.responseLog(data, response)
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            switch status {
            case 200...209:
                let decodedData = try JSONDecoder().decode(Model.self, from: data)
                return .success(decodedData)
                
            default:
                let resp = try JSONDecoder().decode(RequestResponse.self, from: data)
                if status == 401 {
                    UserDefaults.standard.clearAllLocallySavedData()
                }
                return .failure(formattedErrorMessage(status: status,msg: resp.message ?? ""))
            }
        }
        catch(let error) {
            return .failure(error)
        }
    }
    
    func uploadTask<Model: Codable> (endpoint: Endpoints,
                                     tail: String? = nil,
                                     model: Model.Type,
                                     params: [String: Any]? = nil,
                                     method: HttpMehtods = .get,
                                     medias: [Media] = []) async -> Result<Model, Error> {
        
        guard let baseURL = baseURL(), !baseURL.isEmpty
        else { return .failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)) }
        var completeURL = "\(baseURL)/\(endpoint.rawValue)"
        if let tail { completeURL = "\(completeURL)/\(tail)" }
        guard let url = URL(string: completeURL)
        else { return .failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)) }
        var urlRequest = URLRequest(url: url)
        var headers = ["Accept": "application/json"]
        
        if let accessToken = UserDefaults.standard[.accessToken] {
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = nil
        var formData = Data()
        
        let boundary = UUID().uuidString
        
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if let params {
            for(key, value) in params {
                formData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                formData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                formData.append("\(value)".data(using: .utf8)!)
            }
        }
        
        if !medias.isEmpty {
            for media in medias {
                formData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                formData.append("Content-Disposition: form-data; name=\"\(media.keyname)\"; filename=\"\(media.filename)\"\r\n".data(using: .utf8)!)
                formData.append("Content-Type: \(media.contentType)\r\n\r\n".data(using: .utf8)!)
                formData.append(media.data)
            }
        }
        
        formData.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        LogHandler.requestLog(urlRequest)
        
        do {
            let (data, response) = try await URLSession.shared.upload(for: urlRequest, from: formData)
            LogHandler.responseLog(data, response)
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            switch status {
            case 200...209:
                let decodedData = try JSONDecoder().decode(Model.self, from: data)
                return .success(decodedData)
                
            default:
                let resp = try JSONDecoder().decode(RequestResponse.self, from: data)
                if status == 401 {
                    UserDefaults.standard.clearAllLocallySavedData()
                }
                return .failure(formattedErrorMessage(status: status,msg: resp.message ?? ""))
            }
        }
        catch(let error) {
            return .failure(error)
        }
    }
    
    fileprivate func baseURL() -> String? {
        let info = VaultInfo.shared.getKeyValue(by: "App_Environment")
        guard
            let dict = info.0,
            let keyValue = info.1 as? [String: Bool],
            let env = keyValue.first(where: { $0.value })?.key
        else {
            LogHandler.reportLogOnConsole("empty_app_environment_err_msg")
            return nil
        }
        
        let key = "\(env)_Base_URL"
        var baseURL = ""
        
        guard let url = dict[key] as? String, !url.isEmpty
        else {
            LogHandler.reportLogOnConsole(String(format: "empty_base_url_err_msg", [key]))
            return nil
        }
        
        baseURL = url
        return baseURL
    }
    
    fileprivate func formattedErrorMessage(status: Int, msg: String) -> Error {
        return NSError(domain: "",
                       code: status,
                       userInfo: [NSLocalizedDescriptionKey: msg]
        )
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

struct RequestResponse: Codable {
    var status: Int?
    var isSuccess: Bool?
    var error: String?
    var message: String?
}

struct Media {
    var filename: String
    var data: Data
    var keyname: Keyname
    var contentType: ContentType
    
    enum ContentType: String {
        case imageJPEG = "image/jpeg"
        case imagePNG = "image/png"
        case videoMP4 = "video/mp4"
        case videoMOV = "video/quicktime"
        case audio = "audio/mp3"
    }
    
    enum Keyname: String {
        case document = "document"
        case backgroundCheckCertificate = "backgroundCheckCertificate"
        case profileImage = "profileImage"
    }
}
