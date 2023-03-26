//
//  NetworkService.swift
//  Weather
//
//  Created by Zaur on 07.12.2022.
//

import Foundation


class NetworkService {
    
    func request(city: String, completion: @escaping (Data?, Error?) -> Void ) {
        let parametr = self.prepareParametrs(city: city)
        let url = self.url(params: parametr)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "get"
        let task = self.createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func prepareHeader() -> [String: String]? {
        var header = [String: String]()
        header["key"] = ServiceConstants.api_key
        return header
    }
    
    private func prepareParametrs(city: String?) -> [String: String] {
        var parametrs = [String: String]()
        parametrs["q"] = city
        parametrs["aqi"] = "no"
        return parametrs
    }
    
    private func url(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "http"
        components.host = ServiceConstants.baseUrl
        components.path = ServiceConstants.path
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}


