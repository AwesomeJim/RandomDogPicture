//
//  ViewController.swift
//  RandDog
//
//  Created by James Mbugua on 09/01/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var pickerViewController: UIPickerView!
    
    var breeds:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        pickerViewController.delegate = self
        DogAPI.requestBreedsList(completionHandler: handleBreedsListResponse(breeds:error:))
        //DogAPI.requestRandomImage(completionHandler: self.handleRandomImageResponse(data:error:))
//        let task = URLSession.shared.dataTask(with: randomEndpoint) { (data, response, error) in
//            guard let safeData = data else {
//                return
//            }
//            print(safeData)
//            let decoder = JSONDecoder()
//            do {
//                let imageData = try decoder.decode(DogImage.self, from: safeData)
//                print(imageData.message)
//                guard let url = URL(string: imageData.message) else {
//                    return
//                }
////                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
////                    guard let safeData = data else {
////                        return
////                    }
////                    print(safeData)
////                    let image = UIImage(data: safeData)
////                    DispatchQueue.main.async {
////                        self.imageView.image = image
////                    }
////                }
////                task.resume()
//                DogAPI.requestImageFile(with: url, completionHandler: self.handleImageFileResponse(image: error:))
//
//
//            }catch{
//                print(error)
//            }
//        }
//        task.resume()
    }


    func downloadImage(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let safeData = data else {
                return
            }
            print(safeData)
            let image = UIImage(data: safeData)
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        task.resume()
//            let decoder = JSONDecoder()
//            do {
//                let imageData = try decoder.decode(DogImage.self, from: safeData)
//                print(imageData.message)
////                let json = try JSONSerialization.jsonObject(with: safeData, options: []) as! [String: Any]
////                let url = json["message"] as! String
////                print(url)
//            }catch{
//                print(error)
//            }
    
        
    }
    func handleBreedsListResponse(breeds: [String], error: Error?) {
        self.breeds = breeds
        DispatchQueue.main.async {
            self.pickerViewController.reloadAllComponents()
        }
    }
    
    func handleImageFileResponse(image: UIImage?, error: Error?)  {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
    
    func handleRandomImageResponse(data: DogImage?, error:Error?) {
        guard let dogimage = data else {
            return
        }
        guard let url = URL(string: dogimage.message) else {
            return
        }
        DogAPI.requestImageFile(with: url, completionHandler: self.handleImageFileResponse(image: error:))
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedBreed = breeds[row]
        imageView.image = nil
        DogAPI.requestRandomImage(breed: selectedBreed,completionHandler: self.handleRandomImageResponse(data:error:))
    }
    
}

