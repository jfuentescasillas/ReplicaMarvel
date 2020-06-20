//
//  CharactersPresenter.swift
//  ReplicaCharacterTableView
//
//  Created by JFC on 04/06/20.
//  Copyright © 2020 JFC. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol CharactersPresentationLogic {
    func presentCharacters(response: Characters.Response)
    func present(_ characters: [Character])
    func present(_ error: Error)
}


class CharactersPresenter: CharactersPresentationLogic {
	weak var characterViewController: CharactersDisplayLogic?
	
	// MARK: - Display result or notify error to view controller
	func present(_ error: Error) {
	DispatchQueue.main.async {
		self.characterViewController?.notify(error: error.localizedDescription)
		}
	}
	
	
	func present(_ characters: [Character]) {
		DispatchQueue.main.async {
			self.characterViewController?.displayCharacters(viewModel: Characters.ViewModel())
		}
	}
	
	
	func presentCharacters(response: Characters.Response) {
		let model = Model()
		
		
        do {
            guard let data = response.data else { return }
            
            let jsonData = try JSON(data: data)["data"]
            let results = jsonData["results"].array
            let offset = jsonData["offset"].int ?? 0
            let total = jsonData["total"].int ?? 0
            let limit = jsonData["limit"].int ?? 0

            var charactersToAdd = [Character]()
            var idsForImageFetch = [Int]() // For image fetch
            var imageLinks = [String]() // For image fetch

            model.saveCharacterPage(offset: offset, limit: limit, totalCharacter: total)

            for result in results ?? [] {
                let id = result["id"].int ?? 0
                let name = result["name"].string
                let description = result["description"].string ?? ""
                let imagePath = result["thumbnail"]["path"].string ?? ""
                let imageExt = result["thumbnail"]["extension"].string ?? ""
                let imageLink = imagePath + "/portrait_incredible" + ".\(imageExt)"
                let character = Character(id)

                character.name = name
                character.desc = description

                if !model.doesCharacterExist(with: id) {
                    charactersToAdd.append(character)
                }

                // Need these to fetch images later and update CharacterTableView
                imageLinks.append(imageLink)
                idsForImageFetch.append(id)
            }

            // Save to local cache
            model.save(charactersToAdd)

            DispatchQueue.main.async {
                Model().realm?.refresh()
                self.characterViewController?.displayCharacters(viewModel: Characters.ViewModel())
            }

            // Fetch image asynchronously and update table view
            for (index, id) in idsForImageFetch.enumerated() {
                Service.downloadImage(from: imageLinks[index]) { data in
                    Model().save(imageData: data, toCharacterId: id)
                    if data != nil {
                        DispatchQueue.main.async {
                            Model().realm?.refresh()
                            self.characterViewController?.displayImage(viewModel: Characters.ViewModel(characterId: id))
                        }
                    }
                }
            }
        } catch let error {
            debugPrint("\(error) parsing characters")
        }
	}
}
