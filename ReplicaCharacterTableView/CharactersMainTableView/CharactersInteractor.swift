//
//  CharactersInteractor.swift
//  ReplicaCharacterTableView
//
//  Created by JFC on 04/06/20.
//  Copyright © 2020 JFC. All rights reserved.
//

import UIKit


protocol CharactersBusinessLogic {
	func getCharacters()
	func getCacheCharacters()
}


class CharactersInteractor: CharactersBusinessLogic {
	var presenter: CharactersPresentationLogic?
	var worker: CharactersWorker = CharactersWorker()
	
	// MARK: Get cache characters
	func getCacheCharacters() {
		let model = Model()
		
		if let characters = model.getAllCharacters(), !characters.isEmpty {
			presenter?.present(characters) // get character from local cache
		} else {
			getCharacters() // if there's none in local cache, make API request
		}
	}
	
	
	func getCharacters() {
		let model = Model()
		var offset = 0
		
		model.incrementCharacterPage()
		
		if let characterPage = model.getCharacterPage() {
			if characterPage.currentPage <= characterPage.totalPage {
				offset = characterPage.offset
			} else if characterPage.currentPage > characterPage.totalPage {
				return
			}
		}
		
		worker.getCharacters(request: Characters.Request(offset: offset)) { data, error in
			guard error == nil else {
				Model().decrementCharacterPage()
				self.presenter?.present(error!)
				return
			}
			
			if let data = data {
				self.presenter?.presentCharacters(response: Characters.Response(data: data))
			}
		}
	}
}
