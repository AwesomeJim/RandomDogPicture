//
//  DogApi.swift
//  RandDog
//
//  Created by James Mbugua on 09/01/2021.
//

import Foundation
import UIKit

class DogAPI {
    enum EndPoint {
        case randomImageFromAllDogsCollection
        case randomImageBreed(String)
        case listAllBreeds
        
        var url: URL{
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String{
            switch self {
            case .randomImageFromAllDogsCollection:
                return "https://dog.ceo/api/breeds/image/random"
            case .randomImageBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
            }
            
        }
    }
    
    class func requestBreedsList(completionHandler: @escaping ([String], Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: EndPoint.listAllBreeds.url) { (data, response, error) in
            guard let data = data else {
                completionHandler([], error)
                return
            }
            let decoder = JSONDecoder()
            let breedsResponse = try! decoder.decode(BreedsListResponse.self, from: data)
            let breeds = breedsResponse.message.keys.map({$0})
            completionHandler(breeds, nil)
            
        }
        task.resume()
    }
    
    
    
    class func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void) {
        let randomEndpoint = EndPoint.randomImageBreed(breed).url
        print(randomEndpoint)
        let task = URLSession.shared.dataTask(with: randomEndpoint) { (data, response, error) in
            guard let safeData = data else {
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let imageData = try decoder.decode(DogImage.self, from: safeData)
                completionHandler(imageData, nil)
            }catch{
                completionHandler(nil, error)
                print(error)
            }
        }
        task.resume()
    }
    class func requestImageFile(with url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let safeData = data else {
                completionHandler(nil, error)
                return
            }
            let image = UIImage(data: safeData)
            completionHandler(image, nil)
        }
        task.resume()
    }
}
