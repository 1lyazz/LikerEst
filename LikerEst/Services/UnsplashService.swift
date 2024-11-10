//
//  UnsplashService.swift
//  LikerEst
//
//  Created by Ilya Zablotski on 8.11.24.
//

import Alamofire

final class UnsplashService {
    private let accessKey = "63BzS4PNefl8F0J7_SMGRvG4tzw0pjGuzLc7K3DIsYs"
    private let baseURL = "https://api.unsplash.com"
    private let randomPhotosEndpoint = "/photos/random"
    private let searchPhotosEndpoint = "/search/photos"
    private let defaultPhotoCount = 30

    // Fetch random photos from Unsplash API
    func fetchRandomPhotos(completion: @escaping ([Photo]?) -> Void) {
        let url = "\(baseURL)\(randomPhotosEndpoint)"
        let parameters: [String: Any] = ["client_id": accessKey, "count": defaultPhotoCount]

        AF.request(url, parameters: parameters).responseDecodable(of: [Photo].self) { response in
            switch response.result {
            case .success(let photos):
                print("Fetched \(photos.count) random photos")
                completion(photos)
            case .failure(let error):
                self.handleError(response: response, error: error)
                completion(nil)
            }
        }
    }

    // Search photos from Unsplash API by query
    func searchPhotos(query: String, page: Int = 1, perPage: Int = 30, completion: @escaping ([Photo]?) -> Void) {
        let url = "\(baseURL)\(searchPhotosEndpoint)"
        let parameters: [String: Any] = ["client_id": accessKey, "query": query, "page": page, "per_page": perPage]

        AF.request(url, parameters: parameters).responseDecodable(of: PhotoSearchResult.self) { response in
            switch response.result {
            case .success(let result):
                print("Search results: \(result.results.count)")
                completion(result.results)
            case .failure(let error):
                self.handleError(response: response, error: error)
                completion(nil)
            }
        }
    }

    // Handle error responses from Unsplash API
    private func handleError<T: Decodable>(response: AFDataResponse<T>, error: AFError) {
        if let data = response.data,
           let json = try? JSONSerialization.jsonObject(with: data, options: [])
        {
            print("Response data: \(json)")
        } else {
            print("Error: \(error.localizedDescription)")
        }
    }
}
