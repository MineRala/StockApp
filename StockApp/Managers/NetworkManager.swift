//
//  NetworkManager.swift
//  StockApp
//
//  Created by Mine Rala on 21.09.2024.
//

import Foundation

class NetworkManager {

    static let shared = NetworkManager() // Singleton
    private init() {} // Tekil nesne için initializer'ı gizle
    func fetchData<T: Decodable>(from urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Geçersiz URL", code: 0, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Hata kontrolü
            if let error = error {
                completion(.failure(error))
                return
            }

            // Yanıt kontrolü
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCodeError = NSError(domain: "Geçersiz yanıt", code: 1, userInfo: nil)
                completion(.failure(statusCodeError))
                return
            }

            // Veri kontrolü
            guard let data = data else {
                completion(.failure(NSError(domain: "Veri alınamadı", code: 2, userInfo: nil)))
                return
            }

            // Veriyi işleme
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(T.self, from: data) // Generic model kullanımı
                completion(.success(model))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume() // Görevi başlat
    }

  

}
