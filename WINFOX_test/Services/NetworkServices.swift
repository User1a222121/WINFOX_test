//
//  NetworkServices.swift
//  WINFOX_test
//
//  Created by Сергей Карпов on 09.06.2022.
//

import Foundation
import UIKit

enum ErrorInNetworkServices: Error {
    case noData
    case decodeError
}

class NetworkServices {
    
    static let shared = NetworkServices()
    
    //MARK: checkUser
    public func checkUser(phoneNumber: String, uid: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: CHECK_USER) else { return }
        let parameters = [
            "phone": phoneNumber,
            "id": uid
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("text/html", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
//            print("\n========checkUser========")
//            self.log(request: request)
//            self.log(data: data, response: response as? HTTPURLResponse, error: error)
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(true)
                }
            }
            
            guard let data = data else {
                completion(false)
                return
            }
            
            do {
                let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
                print(jsonObject ?? "json of check user fail")
            }
        }
        dataTask.resume()
    }
    
    //MARK: sendCoords
    public func sendCoords(latitude: Double?, longitude: Double?, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: COORDS_USER) else { return }
        let parameters = [
            "latitude": latitude,
            "longitude": longitude
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("text/html", forHTTPHeaderField: "Content-Type")

        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in

//            print("\n========sendCoords========")
//            self.log(request: request)
//            self.log(data: data, response: response as? HTTPURLResponse, error: error)
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(true)
                }
            }

            guard let data = data else {
                completion(false)
                return
            }
            do {
                let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
                print(jsonObject ?? "json of send coordinate fail")
            }
        }
        dataTask.resume()
    }
    
    //MARK: getPlace
    public func getPlace(completion: @escaping (Result<[PlacesModelData], Error>) -> Void) {
        guard let url = URL(string: GET_PLACES) else {
            completion(.failure(ErrorInNetworkServices.noData))
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: { data, response, error in
            
            DispatchQueue.main.async {
//                print("\n========getPlace========")
//                self.log(request: request)
//                self.log(data: data, response: response as? HTTPURLResponse, error: error)
                
                if (response as? HTTPURLResponse)?.statusCode != 200 {
                    completion(.failure(ErrorInNetworkServices.noData))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(ErrorInNetworkServices.noData))
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let decoderResult = try decoder.decode([PlacesModelData].self, from: data)
                    completion(.success(decoderResult))
                } catch {
                    completion(.failure(ErrorInNetworkServices.decodeError))
                    print("failed to convert \(error)")
                }
            }
            
            
        })
        dataTask.resume()
    }
    
    //MARK: getMenu
    public func getMenu(id: String, completion: @escaping (Result<[MenuModelData], Error>) -> Void) {
        guard let url = URL(string: GET_MENU) else {
            completion(.failure(ErrorInNetworkServices.noData))
            return
        }
        let parameters = ["place_id": id]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("text/html", forHTTPHeaderField: "Content-Type")

        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
//                print("\n========getMenu========")
//                self.log(request: request)
//                self.log(data: data, response: response as? HTTPURLResponse, error: error)
                
                if (response as? HTTPURLResponse)?.statusCode != 200 {
                    completion(.failure(ErrorInNetworkServices.noData))
                    return
                }

                guard let data = data else {
                    completion(.failure(ErrorInNetworkServices.noData))
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let decoderResult = try decoder.decode([MenuModelData].self, from: data)
                    completion(.success(decoderResult))
                } catch {
                    completion(.failure(ErrorInNetworkServices.decodeError))
                    print("failed to convert \(error)")
                }
            }
        })
        dataTask.resume()
    }
    
    //MARK: getImage
    public func getImage(image: String, completion: @escaping (UIImage?) -> Void) {
        guard let urlImage = URL(string: image) else {
            completion(UIImage(named: "noImage"))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: urlImage) { data, response, error in
            
            DispatchQueue.main.async {
//                print("\n========getImage========")
//                self.log(data: data, response: response as? HTTPURLResponse, error: error)
                
                guard error == nil,
                        (response as? HTTPURLResponse)?.statusCode == 200,
                        let data = data
                else {
                        print("Warning: Image not downloaded")
                        completion(UIImage(named: "noImage"))
                        return
                }
                let image = UIImage(data: data)
                completion(image)
            }
        }
        dataTask.resume()
    }
}

//MARK: -> extension NetworkServices print Request and Response
extension NetworkServices {
    
    private func log(request: URLRequest?){
        
        if let request = request {
            let urlString = request.url?.absoluteString ?? ""
            let components = NSURLComponents(string: urlString)

            let method = request.httpMethod != nil ? "\(request.httpMethod!)": ""
            let path = "\(components?.path ?? "")"
            let query = "\(components?.query ?? "")"
            let host = "\(components?.host ?? "")"

            var requestLog = "\n---------- OUT ---------->\n"
            requestLog += "\(urlString)"
            requestLog += "\n\n"
            requestLog += "\(method) \(path)?\(query) HTTP/1.1\n"
            requestLog += "Host: \(host)\n"
            for (key,value) in request.allHTTPHeaderFields ?? [:] {
                requestLog += "\(key): \(value)\n"
            }
            if let body = request.httpBody{
                let bodyString = NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "Can't render body; not utf8 encoded";
                requestLog += "\n\(bodyString)\n"
            }

            requestLog += "\n------------------------->\n";
            print(requestLog)
        }
    }

    private func log(data: Data?, response: HTTPURLResponse?, error: Error?){

        let urlString = response?.url?.absoluteString
        let components = NSURLComponents(string: urlString ?? "")

        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"

        var responseLog = "\n<---------- IN ----------\n"
        if let urlString = urlString {
            responseLog += "\(urlString)"
            responseLog += "\n\n"
        }

        if let statusCode =  response?.statusCode{
            responseLog += "HTTP \(statusCode) \(path)?\(query)\n"
        }
        if let host = components?.host{
            responseLog += "Host: \(host)\n"
        }
        for (key,value) in response?.allHeaderFields ?? [:] {
            responseLog += "\(key): \(value)\n"
        }
        if let body = data{
            let bodyString = NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "Can't render body; not utf8 encoded";
            responseLog += "\n\(bodyString)\n"
        }
        if let error = error{
            responseLog += "\nError: \(error.localizedDescription)\n"
        }

        responseLog += "<------------------------\n";
        print(responseLog)
    }
}
