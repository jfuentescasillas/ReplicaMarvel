//
//  CharacterSeachTableViewController.swift
//  ReplicaCharacterTableView
//
//  Created by JFC on 14/06/20.
//  Copyright © 2020 JFC. All rights reserved.
//

import UIKit


class CharacterSeachTableViewController: UITableViewController {
	/* URL De referencia
	https://gateway.marvel.com/v1/public/characters?name=iron%20man&ts=1&apikey=b5a004aac50e22dbccea83b58947bf97&hash=cf8530437ab0e239d120f70010f33a34
	*/
	// MARK: Constants and Variables
	let sections = Constant().kCharacterDetailsSectionTitles
	var searchedCharacterName: String = ""
	var nameReplaced: String = ""
	
	
	// MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

		title = Constant().kSearchCharactersTitle
		checkIfNameIsEmpty()
	}

	
	// MARK: Check if name is empty
	func checkIfNameIsEmpty() {
		if !searchedCharacterName.isEmpty {
			// White spaces are replaced by %20 if the character has spaces in their names. E.g. if the user types "Iron man", the value of "nameReplaced" will be "Iron%20man"
			nameReplaced = searchedCharacterName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
		} else { return }
		
		let characterSearchedURL: String = createSearchedCharacterURL(characterName: nameReplaced)

		//		Reference API To search by character's name:   "https://gateway.marvel.com/v1/public/characters?name=\(nameReplaced)&ts=1&apikey=b5a004aac50e22dbccea83b58947bf97&hash=cf8530437ab0e239d120f70010f33a34"
		//		print("characterSearchedURL: \(characterSearchedURL)")
		fetchSearchedCharacterAPIData(characterSearchedURL: characterSearchedURL)
	}
	

	// MARK: - createSearchedCharacterURL
	func createSearchedCharacterURL(characterName: String) -> String {
		let baseURL: String = Constant.marvelSearchBaseURL
		let apiKey: String = Constant.publicKey
		let apiPrivateKey: String = Constant.privateKey
		let timeStamp = Date().timeIntervalSince1970
		let hashKey: String = ("\(timeStamp)" + apiPrivateKey + apiKey).md5
		let finalURL: String = "\(baseURL)" + "name=\(characterName)" + "&ts=\(timeStamp)" + "&apikey=\(apiKey)" + "&hash=\(hashKey)"
		
		return finalURL
	}
	
	
	// MARK: - Fetch API to get Data of searched character
	func fetchSearchedCharacterAPIData(characterSearchedURL: String) {
		guard let marvelURL = URL(string: characterSearchedURL) else {
			NSLog("Error retreiving marvelAPIURL")
			performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
			
			return
		}
		
		print("Marvel URL inside fetchAPIData: \(marvelURL)")
				
		let marvelTask = URLSession.shared.dataTask(with: marvelURL) { (marvelData, marvelResponse, marvelError) in
			let decoder = JSONDecoder()
			
			if marvelError == nil {
				guard let marvelDataContent = marvelData else { return }
				
				do {
					NSLog("------")
					let marvelPetitions = try decoder.decode(MarvelCharactersAPIStruct.self, from: marvelDataContent)
					print("MarvelPetitions: \n \(marvelPetitions)")
					NSLog("------\n")
					
					let marvelResults = marvelPetitions.data.results
					GlobalData.results = marvelResults
					print("GlobalDataResults: \n \(GlobalData.results)")
					NSLog("------\n")
					
					// Fill the heroes names and images urls in the GlobalData content
					for index in 0..<marvelResults.count {
						let characterID = marvelPetitions.data.results[index].id
						GlobalData.characterID = characterID
						
						let tempThumbnail =  marvelPetitions.data.results[index].thumbnail
						GlobalData.thumbnail.append(tempThumbnail)
						
						let tempPath = tempThumbnail.path
						let tempImageExtension = tempThumbnail.imageExtension
						GlobalData.characterImageURL.append(tempPath+"."+tempImageExtension)
						
						GlobalData.characterName.append(marvelPetitions.data.results[index].name)
						
						let newCharacter = CharacterSearch()
						newCharacter.nameOfCharacter = GlobalData.characterName[index]
						newCharacter.imageOfCharacter = GlobalData.characterImageURL[index]
						
						GlobalData.characterDescription.append(marvelPetitions.data.results[index].description)
						GlobalData.characterComics.append(marvelPetitions.data.results[index].comics)
						GlobalData.characterSeries.append(marvelPetitions.data.results[index].series)
						GlobalData.characterStories.append(marvelPetitions.data.results[index].stories)
						GlobalData.characterEvents.append(marvelPetitions.data.results[index].events)
					}
					
					print("character's name: \(GlobalData.characterName)")
					NSLog("------\n")
					
					print("GlobalData.thumbnail: \(GlobalData.thumbnail)")
					NSLog("------\n")
					
					print("GlobalData.characterImageURL: \(GlobalData.characterImageURL)")
					NSLog("------\n")
					
					print("GlobalData.characterDescription: \(GlobalData.characterDescription)")
					NSLog("------\n")
					
					print("GlobalData.characterComics: \(GlobalData.characterComics)")
					NSLog("------\n")
					
					print("GlobalData.characterSeries: \(GlobalData.characterSeries)")
					NSLog("------\n")
					
					print("GlobalData.characterStories: \(GlobalData.characterStories)")
					NSLog("------\n")
					
					print("GlobalData.characterEvents: \(GlobalData.characterEvents)")
					NSLog("------\n")
										
				} catch let jsonError {
					NSLog("JSON error: \(jsonError)")
				}
				
				DispatchQueue.main.async {
					self.tableView.reloadData()
					NSLog("------")
				}
				
			} else {
				self.showError()
			}
		}
		
		marvelTask.resume()
	}
	
	
	// MARK: - ShowError method
	@objc func showError() {
		let acStrings = Constant()
		let alertController = UIAlertController(title: acStrings.kShowErrorTitle, message: acStrings.kShowErrorMsg, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .default))
		present(alertController, animated: true)
		
		alertController.addAction(UIAlertAction(title: acStrings.kShowErrorRetry, style: .default))
		
		self.present(alertController, animated: true)
	}
	
	
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
		return 1 //sections.count
    }
	
	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

    
	// MARK: - Table View Delegates
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterSearchCell", for: indexPath) as? CharacterImageSearchTableViewCell else { return UITableViewCell() }

		DispatchQueue.main.async() { [] in
			
			if !GlobalData.results.isEmpty {
				cell.characterSearchNameLabel?.numberOfLines = 0
				cell.characterSearchNameLabel?.text = GlobalData.characterName.first						// Character's
				cell.characterSearchDescriptionLabel?.numberOfLines = 6
				cell.characterSearchDescriptionLabel?.text = GlobalData.characterDescription.first			// Character's description
				cell.characterSearchImageImageView.downloaded(from: GlobalData.characterImageURL.first ?? "")  // Character's image
				cell.characterSearchImageImageView.contentMode = .scaleAspectFill
			} else {
				cell.characterSearchNameLabel?.text = ""
				cell.characterSearchDescriptionLabel?.numberOfLines = 6
				cell.characterSearchDescriptionLabel?.text = Constant().kNonExistentCharacter
			}
			
		}
		
		return cell
	}
	
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		if !GlobalData.results.isEmpty {
			let characterId = GlobalData.characterID!
			guard let characterDetailViewController = storyboard?.instantiateViewController(identifier: "CharacterSearchDetails") as? CharacterSearchDetailsTableViewController else { return }
			characterDetailViewController.title = GlobalData.characterName.first
			characterDetailViewController.characterID = characterId
			characterDetailViewController.characterDescription = GlobalData.characterDescription.first ?? ""
			characterDetailViewController.characterImageURL = GlobalData.characterImageURL.first ?? ""
			characterDetailViewController.characterComics = GlobalData.characterComics[indexPath.row].items
			characterDetailViewController.characterSeries = GlobalData.characterSeries[indexPath.row].items
			characterDetailViewController.characterStories = GlobalData.characterStories[indexPath.row].items
			characterDetailViewController.characterEvents = GlobalData.characterEvents[indexPath.row].items
			
			navigationController?.pushViewController(characterDetailViewController, animated: true)
			navigationController?.navigationBar.prefersLargeTitles = false
		} else {
			
			return
		}
	}
}
