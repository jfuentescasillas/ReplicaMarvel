//
//  Service.swift
//  ReplicaCharacterTableView
//
//  Created by JFC on 04/06/20.
//  Copyright © 2020 JFC. All rights reserved.
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
	
	
	// Comics
	private static func processComics(data: Data, from id: Int?, completion: @escaping ([Comic]?) -> Void) {
        do {
            let group = DispatchGroup()
            let model = Model()
            let json = try JSON(data: data)
            let results = json["data"]["results"].array ?? []
            var imageLinks = [String]()
            var comicIds = [Int]()
            var idsToAdd = [Int]()
            var comicsToAdd = [Comic]()

            if results.isEmpty {
                DispatchQueue.main.async {
                    completion([Comic]())
                }
                return
            }

            for result in results {
                let comicId = result["id"].int ?? 0
                let comic = Comic(comicId)
                let imagePath = result["thumbnail"]["path"].string ?? ""
                let imageExt = result["thumbnail"]["extension"].string ?? ""
                let imageLink = imagePath + "/portrait_fantastic" + ".\(imageExt)"

                comic.digitalId = result["digitalId"].int ?? 0
                comic.title = result["title"].string
                comic.issueNumber = result["issueNumber"].int ?? 0
                comic.desc = result["description"].string
                comic.isbn = result["isbn"].string
                comic.upc = result["upc"].string
                comic.diamondCode = result["diamondCode"].string
                comic.ean = result["ean"].string
                comic.issn = result["issn"].string
                comic.format = result["format"].string
                comic.pageCount = result["pageCount"].int ?? 0
                comic.hardCopyPrice = result["prices"].array?.first?["price"].float ?? 0

                idsToAdd.append(comicId)

                if !model.doesComicExist(with: comicId) {
                    imageLinks.append(imageLink)
                    comicsToAdd.append(comic)
                    comicIds.append(comicId)
                }
            }
            
            
            model.save(comicsToAdd)
            
            for idToAdd in idsToAdd {
                guard let id = id else {
                    break
                }
                if model.doesCharacterExist(with: id) {
                    model.save(comicId: idToAdd, toCharacter: id)
                } else if model.doesEventExist(with: id) {
                    model.save(comicId: idToAdd, toEvent: id)
                } else if model.doesSerieExist(with: id) {
                    model.save(comicId: idToAdd, toSerie: id)
                } else if model.doesStoryExist(with: id) {
                    model.save(comicId: idToAdd, toStory: id)
                } else if model.doesCreatorExist(with: id) {
                    model.save(comicId: idToAdd, toCreator: id)
                }
            }
            
            for (index, link) in imageLinks.enumerated() {
                group.enter()
                downloadImage(from: link) { data in
                    Model().save(imageData: data, toComic: comicIds[index])
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                Model().realm?.refresh()
                DispatchQueue.main.async {
                    let model = Model()
                    var comicsToPresent = [Comic]()
                    for id in idsToAdd {
                        if let comic = model.getComicBy(id: id) {
                            comicsToPresent.append(comic)
                        }
                    }
                    completion(comicsToPresent)
                }
            }
        } catch let error {
            debugPrint(error)
        }
    }
	
	
	static func getComicsWith(characterId: Int, config: CharacterComicConfig = CharacterComicConfig(), completion: @escaping ([Comic]?) -> Void) {
        apiWrapper.getComicsWith(characterId: characterId, config: config) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil)
                }
            } else if let data = data {
                processComics(data: data, from: characterId, completion: completion)
            }
        }
    }
	
	
	// Series
	static func getSeriesWith(characterId: Int, config: CharacterSerieConfig = CharacterSerieConfig(), completion: @escaping ([Serie]?) -> Void) {
        apiWrapper.getSeriesWith(characterId: characterId, config: config) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil)
                }
            } else if let data = data {
                processSeries(data: data, from: characterId, completion: completion)
            }
        }
    }
	
	
	private static func processSeries(data: Data, from id: Int?, completion: @escaping ([Serie]?) -> Void) {
        do {
            let group = DispatchGroup()
            let model = Model()
            let json = try JSON(data: data)
            let results = json["data"]["results"].array ?? []
            var imageLinks = [String]()
            var serieIds = [Int]()
            var idsToAdd = [Int]()
            var seriesToAdd = [Serie]()

            if results.isEmpty {
                DispatchQueue.main.async {
                    completion([Serie]())
                }
                return
            }

            for result in results {
                let serieId = result["id"].int ?? 0
                let serie = Serie(serieId)
                let imagePath = result["thumbnail"]["path"].string ?? ""
                let imageExt = result["thumbnail"]["extension"].string ?? ""
                let imageLink = imagePath + "/portrait_fantastic" + ".\(imageExt)"

                serie.desc = result["description"].string
                serie.title = result["title"].string
                serie.startYear = result["startYear"].int
                serie.endYear = result["endYear"].int
                serie.rating = result["rating"].string

                idsToAdd.append(serieId)

                if !model.doesSerieExist(with: serieId) {
                    imageLinks.append(imageLink)
                    seriesToAdd.append(serie)
                    serieIds.append(serieId)
                }
            }

            model.save(seriesToAdd)

            for idToAdd in idsToAdd {
                guard let id = id else {
                    break
                }
                if model.doesCharacterExist(with: id) {
                    model.save(serieId: idToAdd, toCharacter: id)
                } else if model.doesEventExist(with: id) {
                    model.save(serieId: idToAdd, toEvent: id)
                } else if model.doesStoryExist(with: id) {
                    model.save(serieId: idToAdd, toStory: id)
                } else if model.doesCreatorExist(with: id) {
                    model.save(serieId: idToAdd, toCreator: id)
                }
            }

            for (index, link) in imageLinks.enumerated() {
                group.enter()
                downloadImage(from: link) { data in
                    Model().save(imageData: data, toSerie: serieIds[index])
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                Model().realm?.refresh()
                DispatchQueue.main.async {
                    let model = Model()
                    var seriesToPresent = [Serie]()
                    for id in idsToAdd {
                        if let serie = model.getSerieBy(id: id) {
                            seriesToPresent.append(serie)
                        }
                    }
                    completion(seriesToPresent)
                }
            }
        } catch let error {
            debugPrint(error)
        }
    }
	
	
	// Story
	static func getStoriesWith(characterId: Int, config: CharacterStoryConfig = CharacterStoryConfig(), completion: @escaping ([Story]?) -> Void) {
        apiWrapper.getStoriesWith(characterId: characterId, config: config) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil)
                }
            } else if let data = data {
                processStories(data: data, from: characterId, completion: completion)
            }
        }
    }
	
	
	private static func processStories(data: Data, from id: Int, completion: @escaping ([Story]?) -> Void) {
        do {
            let model = Model()
            let json = try JSON(data: data)
            let results = json["data"]["results"].array ?? []
            var idsToAdd = [Int]()
            
            if results.isEmpty {
                DispatchQueue.main.async {
                    completion([Story]())
                }
                return
            }

            for result in results {
                let storyId = result["id"].int ?? 0
                let story = Story(storyId)

                story.desc = result["description"].string
                story.title = result["title"].string == "" ? "N/A" : result["title"].string

                idsToAdd.append(storyId)

                if !model.doesStoryExist(with: storyId) {
                    model.save(story)
                }
            }

            for idToAdd in idsToAdd {
                if model.doesComicExist(with: id) {
                    model.save(storyId: idToAdd, toComic: id)
                } else if model.doesCharacterExist(with: id) {
                    model.save(storyId: idToAdd, toCharacter: id)
                } else if model.doesEventExist(with: id) {
                    model.save(storyId: idToAdd, toEvent: id)
                } else if model.doesSerieExist(with: id) {
                    model.save(storyId: idToAdd, toSerie: id)
                } else if model.doesCreatorExist(with: id) {
                    model.save(storyId: idToAdd, toCreator: id)
                }
            }

            DispatchQueue.main.async {
                let model = Model()
                model.realm?.refresh()
                
                var storiesToPresent = [Story]()
                for id in idsToAdd {
                    if let story = model.getStoryBy(id: id) {
                        storiesToPresent.append(story)
                    }
                }
                completion(storiesToPresent)
            }
        } catch let error {
            debugPrint(error)
        }
    }
	
	
	// Events
	static func getEventsWith(characterId: Int, config: CharacterEventConfig = CharacterEventConfig(), completion: @escaping ([Event]?) -> Void) {
        apiWrapper.getEventsWith(characterId: characterId, config: config) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil)
                }
            } else if let data = data {
                processEvents(data: data, from: characterId, completion: completion)
            }
        }
    }
	
	
	private static func processEvents(data: Data, from id: Int?, completion: @escaping ([Event]?) -> Void) {
        do {
            let group = DispatchGroup()
            let model = Model()
            let json = try JSON(data: data)
            let results = json["data"]["results"].array ?? []
            var imageLinks = [String]()
            var eventIds = [Int]()
            var idsToAdd = [Int]()
            var eventsToAdd = [Event]()

            if results.isEmpty {
                DispatchQueue.main.async {
                    completion([Event]())
                }
                return
            }

            for result in results {
                let id = result["id"].int ?? 0
                let event = Event(id)
                let imagePath = result["thumbnail"]["path"].string ?? ""
                let imageExt = result["thumbnail"]["extension"].string ?? ""
                let imageLink = imagePath + "/portrait_fantastic" + ".\(imageExt)"

                event.desc = result["description"].string
                event.title = result["title"].string
                event.start = result["start"].string
                event.end = result["end"].string

                idsToAdd.append(id)

                if !model.doesEventExist(with: id) {
                    imageLinks.append(imageLink)
                    eventsToAdd.append(event)
                    eventIds.append(id)
                }
            }

            model.save(eventsToAdd)

            for eventId in idsToAdd {
                guard let id = id else {
                    break
                }
                if model.doesCharacterExist(with: id) {
                    model.save(eventId: eventId, toCharacter: id)
                } else if model.doesComicExist(with: id) {
                    model.save(eventId: eventId, toComic: id)
                } else if model.doesSerieExist(with: id) {
                    model.save(eventId: eventId, toSerie: id)
                } else if model.doesStoryExist(with: id) {
                    model.save(eventId: eventId, toStory: id)
                } else if model.doesCreatorExist(with: id) {
                    model.save(eventId: eventId, toCreator: id)
                }
            }

            for (index, link) in imageLinks.enumerated() {
                group.enter()
                downloadImage(from: link) { data in
                    Model().save(imageData: data, toEvent: eventIds[index])
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                Model().realm?.refresh()
                DispatchQueue.main.async {
                    let model = Model()
                    var eventsToPresent = [Event]()
                    for id in idsToAdd {
                        if let event = model.getEventBy(id: id) {
                            eventsToPresent.append(event)
                        }
                    }
                    completion(eventsToPresent)
                }
            }
        } catch let error {
            debugPrint(error)
        }
    }
	// En el archivo original, faltan aún como 800 líneas de código. Por el momento vamos paso a paso.
	
}
