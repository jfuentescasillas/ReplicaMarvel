//
//  Service.swift
//  ReplicaCharacterTableView
//
//  Created by Jorge Fuentes Casillas on 04/06/20.
//  Copyright © 2020 Jorge Fuentes Casillas. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift
import MarvelApiWrapper


struct Service {
	static var apiWrapper: MarvelApiWrapper {
        return MarvelApiWrapper(publicKey: Constant.publicKey, privateKey: Constant.privateKey)
    }
	
	
	static func downloadImage(from link: String, completion: @escaping (Data?) -> Void) {
		guard let url = URL(string: link) else { return }
		
		let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 12.0)
        request.httpMethod = "GET"
		
		let dataTask = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, error == nil
                else {
                    completion(nil)
                    return
                }

            completion(data)
        }
		
		dataTask.resume()
	}
	
	
	static func getCharacters(config: CharacterConfig = CharacterConfig(), completion: @escaping (Data?, Error?) -> Void) {
        apiWrapper.getAllCharacterWith(config: config) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode == 200, error == nil {
                completion(data, nil) // no error
            } else {
                completion(data, error)
            }
        }
    }
	
	
	static func getCreators(config: CreatorConfig = CreatorConfig(), completion: @escaping ([Creator]?) -> Void) {
        apiWrapper.getAllCreatorWith(config: config) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil)
                }
            } else if let data = data {
                processCreators(data: data, from: nil, completion: completion)
            }
        }
    }
	
	
	private static func processCreators(data: Data, from id: Int?, completion: @escaping ([Creator]?) -> Void) {
        do {
            let group = DispatchGroup()
            let model = Model()
            let jsonData = try JSON(data: data)["data"]
            let results = jsonData["results"].array
            var imageLinks = [String]()
            var creatorIds = [Int]()
            var idsToAdd = [Int]()
            var creatorsToAdd = [Creator]()
            
            if results?.isEmpty ?? true {
                DispatchQueue.main.async {
                    completion([Creator]())
                }
                return
            }
            
            for result in results ?? [] {
                let creatorId = result["id"].int ?? 0
                let fullName = result["fullName"].string
                let firstName = result["firstName"].string
                let lastName = result["lastName"].string
                let imagePath = result["thumbnail"]["path"].string ?? ""
                let imageExt = result["thumbnail"]["extension"].string ?? ""
                let imageLink = imagePath + "/portrait_incredible" + ".\(imageExt)"
                let creator = Creator(creatorId)
                
                creator.fullName = fullName
                creator.firstName = firstName
                creator.lastName = lastName

                idsToAdd.append(creatorId)
                
                if !model.doesCreatorExist(with: creatorId) {
                    imageLinks.append(imageLink)
                    creatorsToAdd.append(creator)
                    creatorIds.append(creatorId)
                }
            }

            model.save(creatorsToAdd)

            for idToAdd in idsToAdd {
                guard let id = id else {
                    break
                }
                if model.doesComicExist(with: id) {
                    model.save(creatorId: idToAdd, toComic: id)
                } else if model.doesEventExist(with: id) {
                    model.save(creatorId: idToAdd, toEvent: id)
                } else if model.doesSerieExist(with: id) {
                    model.save(creatorId: idToAdd, toSerie: id)
                } else if model.doesStoryExist(with: id) {
                    model.save(creatorId: idToAdd, toStory: id)
                }
            }

            for (index, link) in imageLinks.enumerated() {
                    group.enter()
                    downloadImage(from: link) { data in
                        Model().save(imageData: data, toCreator: creatorIds[index])
                        group.leave()
                    }
            }

            group.notify(queue: .main) {
                Model().realm?.refresh()
                DispatchQueue.main.async {
                    let model = Model()
                    var creatorsToPresent = [Creator]()
                    for id in idsToAdd {
                        if let creator = model.getCreatorBy(id: id) {
                            creatorsToPresent.append(creator)
                        }
                    }
                    completion(creatorsToPresent)
                }
            }

        } catch let error {
            debugPrint("\(error) parsing characters")
        }
    }
	
	// En el archivo original, faltan aún como 800 líneas de código. Por el momento vamos paso a paso.
}
