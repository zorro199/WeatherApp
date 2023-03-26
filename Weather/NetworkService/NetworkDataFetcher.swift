//
//  NetworkDataFetcher.swift
//  Weather
//
//  Created by Zaur on 08.12.2022.
//

import Foundation

class NetworkDataFetcher {
    
    var networkService = NetworkService()
    
    func fetchCity(searchCity: String, completion: @escaping(WeatherModel?) -> Void ) {
        networkService.request(city: searchCity) { data, error in
            if let error = error {
                print("Error request search city: \(error.localizedDescription)")
                completion(nil)
            }
            let decoding = self.decodeJson(type: WeatherModel.self, from: data)
            completion(decoding)
        }
    }
    
    private func decodeJson<T: Decodable>(type: T.Type, from data: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = data else {
            return nil
        }
        do {
            let object = try decoder.decode(type.self, from: data)
            return object
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
    
}
