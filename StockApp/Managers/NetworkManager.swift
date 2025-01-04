//
//  NetworkManager.swift
//  StockApp
//
//  Created by Mine Rala on 21.09.2024.
//

import Foundation

protocol NetworkManagerProtocol {
    func makeRequest<T: Decodable>(endpoint: Endpoint, type: T.Type, completed: @escaping (Result<T, SAError>) -> Void)
}

// MARK: - Class Bone
final class NetworkManager: NetworkManagerProtocol {
    //Applied Singleton
    static let shared = NetworkManager()

    func makeRequest<T: Decodable>(endpoint: Endpoint, type: T.Type, completed: @escaping (Result<T, SAError>) -> Void) {
        guard let url = endpoint.url else {
            completed(.failure(.invalidKeyword))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let decodedObject = try decoder.decode(T.self, from: data)
                completed(.success(decodedObject))
            } catch {
                completed(.failure(.invalidData))
            }
        }.resume()
    }


    var mockStackDataModelIndex = 0

    let urlArray: [String] = [
        "https://run.mocky.io/v3/3074f599-e0c5-47cd-9219-113230a32acb",
        "https://run.mocky.io/v3/b98a1dea-99e2-4005-863c-58c0beeb2873",
        "https://run.mocky.io/v3/4c91bd00-9702-476e-b962-dd5923ae517b",
        "https://run.mocky.io/v3/897139fd-749f-4d8a-98a0-a5aea98e01c6",
        "https://run.mocky.io/v3/6e294026-ef86-4907-93de-47354ad077a7",
        "https://run.mocky.io/v3/2be95926-5735-43af-be46-2ee2bd136d95",
        "https://run.mocky.io/v3/dcb55abc-7e07-4a2b-a90c-d6979af6db60",
        "https://run.mocky.io/v3/ce934f7a-d27b-4931-9b63-70026e10b7d3",
        "https://run.mocky.io/v3/1fb59630-b299-4124-bc2a-835f23eca0e6",
        "https://run.mocky.io/v3/9d21dde4-b0a6-4eb0-b08e-d538ec0d800e",
        "https://run.mocky.io/v3/a6d359d4-8da2-4de2-8d94-1567fc7be4b3",
        "https://run.mocky.io/v3/fb7c4e35-3b56-465b-acad-10747975d4e2",
        "https://run.mocky.io/v3/8a77cdb5-b89d-467e-b5d6-5355d93401d9",
        "https://run.mocky.io/v3/3c183b1f-0911-42bf-8bc2-1c93adcdc979",
        "https://run.mocky.io/v3/8e9813dc-c8ff-4c20-80d4-e61a882895bb",
        "https://run.mocky.io/v3/93f68872-eaec-4c41-8a88-726b10393a39",
        "https://run.mocky.io/v3/56477022-fbed-4e1e-a051-bae3d50fd668",
        "https://run.mocky.io/v3/cf8b0e35-5b6a-4e47-9d2d-254c556fcccc",
        "https://run.mocky.io/v3/305945ab-5339-4ba4-bd70-4b7999bb5b34",
        "https://run.mocky.io/v3/3b4f0007-89e1-41cb-bd68-8cf51b5cb59b",
        "https://run.mocky.io/v3/1627f186-67cf-4d2b-ae79-60a8b6caf453",
        "https://run.mocky.io/v3/3014a675-2f9a-48a2-bc56-a1990065e956",
        "https://run.mocky.io/v3/852dd00e-06ba-44eb-bf46-f680eb23f868",
        "https://run.mocky.io/v3/7e4bdaba-8665-4fec-8865-bbcb0d26e103",
        "https://run.mocky.io/v3/b74e3771-c395-485b-8f52-71bc3a185a7e",
        "https://run.mocky.io/v3/e26040a4-2ec2-442e-93ee-a10236d7f420",
        "https://run.mocky.io/v3/1cd88bb8-c138-4d4c-9f54-5d7d8664b08b",
        "https://run.mocky.io/v3/cd0232f8-8152-4e33-bae4-ac96a65ca193",
        "https://run.mocky.io/v3/466281a5-e3c6-4d72-9cf6-6b3df4bf45ef",
        "https://run.mocky.io/v3/2200cb8e-5be2-4cf8-90f6-2b14d51900c2",
        "https://run.mocky.io/v3/8bb38844-98e5-4ba4-a6bc-6ff15521bfb9",
        "https://run.mocky.io/v3/ae19a2a7-cab3-4f8b-84b7-dc5ebf2573c5",
        "https://run.mocky.io/v3/26939928-5927-4df0-9514-6c378a2516ba",
        "https://run.mocky.io/v3/80985d9f-1870-425b-9a2f-bfb35f533607",
        "https://run.mocky.io/v3/c8924714-b734-4f79-82c1-6d62d7cc9865",
        "https://run.mocky.io/v3/9ecd6104-a05c-4448-9ec8-065f9eb98b1b"
    ]

}
