//
//  Model.swift
//  ReplicaCharacterTableView
//
//  Created by Jorge Fuentes Casillas on 03/06/20.
//  Copyright © 2020 Jorge Fuentes Casillas. All rights reserved.
//

import Foundation
import RealmSwift


class Model {
	let realm = try? Realm()
	
	// MARK: - Get Character
	func getAllCharacters() -> [Character]? {
        return Array((realm?.objects(Character.self))!)
    }
	
	
	func save(_ characters: [Character]) {
		do {
            try realm?.write {
                realm?.add(characters)
            }
        } catch let error {
            debugPrint("\(error) saving character")
        }		
    }
	
	
	func getCharactersWith(eventId: Int) -> [Character] {
		var characters = [Character]()
		let ids = realm?.object(ofType: Event.self, forPrimaryKey: eventId)?.characters ?? List<Int>()
		
		for id in ids {
			if let character = getCharacterBy(id: id) {
				characters.append(character)
			}
		}
		
		return characters
	}
	
	
	func doesCharacterExist(with id: Int) -> Bool {
        return realm?.object(ofType: Character.self, forPrimaryKey: id) != nil
    }
	
	
	func save(imageData: Data?, toCharacterId: Int) {
        do {
            try realm?.write {
                realm?.object(ofType: Character.self, forPrimaryKey: toCharacterId)?.imageData = imageData
            }
        } catch let error {
            debugPrint("\(error) saving image to character")
        }
    }
	
	
	func getCharacterBy(id: Int) -> Character? {
        return realm?.object(ofType: Character.self, forPrimaryKey: id)
    }
	
	
	func saveCharacterPage(offset: Int, limit: Int, totalCharacter: Int) {
        do {
            try realm?.write {
                if realm?.objects(CharacterPage.self).first == nil, limit != 0 {
                    let characterPage = CharacterPage(offset: offset, limit: limit, totalCharacter: totalCharacter)
                    let mod = totalCharacter % limit
                    characterPage.totalPage = mod + (totalCharacter - mod) / limit
                    realm?.add(characterPage)
                }
            }
        } catch let error {
            debugPrint("\(error) saving character page")
        }
    }
	
	
	func getCharacterPage() -> CharacterPage? {
        return realm?.objects(CharacterPage.self).first
    }
	
	
	func incrementCharacterPage() {
		do {
			try realm?.write {
				
				if let characterPage = realm?.objects(CharacterPage.self).first {
					let newPage = characterPage.currentPage + 1
					let newOffset = characterPage.limit * characterPage.currentPage
					
					if characterPage.currentPage <= characterPage.totalPage {
						characterPage.currentPage = newPage
						characterPage.offset = newOffset
					}
				}
			}
			
		} catch let error {
			debugPrint("\(error) saving character page")
		}
	}
	
	
	func decrementCharacterPage() {
        do {
            try realm?.write {
                
				if let characterPage = realm?.objects(CharacterPage.self).first {
                    characterPage.currentPage -= 1
                }
            }
			
        } catch let error {
            debugPrint("\(error) saving character page")
        }
    }
	
	
	// MARK: - Get Comic
	func doesComicExist(with id: Int) -> Bool {
        return realm?.object(ofType: Comic.self, forPrimaryKey: id) != nil
    }
	
	
	func save(creatorId: Int, toComic id: Int) {
        do {
            try realm?.write {
                realm?.object(ofType: Comic.self, forPrimaryKey: id)?.creators.append(creatorId)
            }
        } catch let error {
            debugPrint("\(error) saving creator id")
        }
    }
	
	
	// MARK: - Get Serie
	func doesSerieExist(with id: Int) -> Bool {
        return realm?.object(ofType: Serie.self, forPrimaryKey: id) != nil
    }

	func save(creatorId: Int, toSerie id: Int) {
        do {
            try realm?.write {
                realm?.object(ofType: Serie.self, forPrimaryKey: id)?.creators.append(creatorId)
            }
        } catch let error {
            debugPrint("\(error) saving character id")
        }
    }
	
	
	// MARK: Get Story
    func doesStoryExist(with id: Int) -> Bool {
        return realm?.object(ofType: Story.self, forPrimaryKey: id) != nil
    }

    func save(creatorId: Int, toStory id: Int) {
        do {
            try realm?.write {
                realm?.object(ofType: Story.self, forPrimaryKey: id)?.creators.append(creatorId)
            }
        } catch let error {
            debugPrint("\(error) saving serie id")
        }
    }
	
	
	// MARK: Get Event
    func doesEventExist(with id: Int) -> Bool {
        return realm?.object(ofType: Event.self, forPrimaryKey: id) != nil
    }
	
	
	func save(creatorId: Int, toEvent id: Int) {
        do {
            try realm?.write {
                realm?.object(ofType: Event.self, forPrimaryKey: id)?.creators.append(creatorId)
            }
        } catch let error {
            debugPrint("\(error) saving creator id")
        }
    }
	
	// MARK: Creators
    func doesCreatorExist(with id: Int) -> Bool {
        return realm?.object(ofType: Creator.self, forPrimaryKey: id) != nil
    }
	
	
	func getCreatorBy(id: Int) -> Creator? {
        return realm?.object(ofType: Creator.self, forPrimaryKey: id)
    }
	
	
	func save(_ creators: [Creator]) {
        do {
            try realm?.write {
                realm?.add(creators)
            }
        } catch let error {
            debugPrint("\(error) saving character")
        }
    }
	
	
	func save(imageData: Data?, toCreator id: Int) {
		do {
			try realm?.write {
				realm?.object(ofType: Creator.self, forPrimaryKey: id)?.imageData = imageData
			}
		} catch let error {
			debugPrint("\(error) saving character")
		}
	}
}


// MARK: Character
class Character: Marvel {
    @objc dynamic var desc: String?
    @objc dynamic var name: String?
    @objc dynamic var modified: String?
    @objc dynamic var offset: Int = 0
    let comics = List<Int>()
    let events = List<Int>()
    let series = List<Int>()
    let stories = List<Int>()
}


class CharacterPage: Object {
    @objc dynamic var offset: Int = 0
    @objc dynamic var currentPage: Int = 1 // initially, it is always 1
    @objc dynamic var totalCharacter: Int = 0
    @objc dynamic var limit: Int = 0
    @objc dynamic var totalPage: Int = 1 // assuming total page is 1 initially
    
    convenience init(offset: Int, limit: Int, totalCharacter: Int) {
        self.init()
        self.offset = offset
        self.limit = limit
        self.totalCharacter = totalCharacter
    }
}


// MARK: Comic
class Comic: Marvel {
    @objc dynamic var digitalId: Int = 0
    @objc dynamic var issueNumber: Int = 0
    @objc dynamic var pageCount: Int = 0
    @objc dynamic var hardCopyPrice: Float = 0
    @objc dynamic var digitalPrice: Float = 0
    @objc dynamic var title: String?
    @objc dynamic var desc: String?
    @objc dynamic var isbn: String?
    @objc dynamic var upc: String?
    @objc dynamic var diamondCode: String?
    @objc dynamic var ean: String?
    @objc dynamic var issn: String?
    @objc dynamic var format: String?
    @objc dynamic var solicitText: String?
    let events = List<Int>()
    let creators = List<Int>()
    let stories = List<Int>()
    let characters = List<Int>()
}


// MARK: Serie
class Serie: Marvel {
    @objc dynamic var title: String?
    @objc dynamic var desc: String?
    @objc dynamic var rating: String?
    dynamic var startYear: Int?
    dynamic var endYear: Int?
    let characters = List<Int>()
    let comics = List<Int>()
    let creators = List<Int>()
    let events = List<Int>()
    let stories = List<Int>()
}


// MARK: Story
class Story: Marvel {
    @objc dynamic var title: String?
    @objc dynamic var desc: String?
    let characters = List<Int>()
    let comics = List<Int>()
    let creators = List<Int>()
    let events = List<Int>()
    let series = List<Int>()
}


// MARK: Event
class Event: Marvel {
    @objc dynamic var title: String?
    @objc dynamic var desc: String?
    @objc dynamic var start: String?
    @objc dynamic var end: String?
    let characters = List<Int>()
    let comics = List<Int>()
    let creators = List<Int>()
    let series = List<Int>()
    let stories = List<Int>()
}


// MARK: Creator
class Creator: Marvel {
    @objc dynamic var firstName: String?
    @objc dynamic var middleName: String?
    @objc dynamic var lastName: String?
    @objc dynamic var suffix: String?
    @objc dynamic var fullName: String?
    let series = List<Int>()
    let stories = List<Int>()
    let comics = List<Int>()
    let events = List<Int>()
}


class Marvel: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var imageData: Data?

    convenience init(_ id: Int) {
        self.init()
        self.id = id
    }

    override static func primaryKey() -> String? {
        return "id"
    }

    override static func indexedProperties() -> [String] {
        return ["id"]
    }
}