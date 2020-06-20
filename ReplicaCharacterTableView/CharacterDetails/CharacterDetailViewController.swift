//
//  CharacterDetailViewController.swift
//  ReplicaCharacterTableView
//
//  Created by JFC on 07/06/20.
//  Copyright © 2020 JFC. All rights reserved.
//

import UIKit

// URL Referencia:
// https://gateway.marvel.com/v1/public/characters/1017100?&ts=1&apikey=b5a004aac50e22dbccea83b58947bf97&hash=cf8530437ab0e239d120f70010f33a34

class CharacterDetailViewController: UITableViewController {
	// MARK: Constants and Variables
    var characterId: Int!
	let sections = Constant().kCharacterDetailsSectionTitles
	let noDataInSection = Constant()
	var characterImageViewData: Data?
	var characterDetailDescription: String?
	var characterComics = [MarvelComics]() //
	var characterSeries = [MarvelSeries]()
	var characterStories = [MarvelStories]()
	var characterEvents = [MarvelEvents]()
	
	
	// MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
		
		print("CharacterID in CharacterDetailViewController: \(characterId ?? 0)")
		
		let characterURL: String = createMarvelAPIURL()
		print("characterURL: \(characterURL)")
		
		fetchAPIData(marvelURL: characterURL)
    }

	
	override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
	
	
	// Create a valid URL in order to extract the character's data
	func createMarvelAPIURL() -> String {
		let baseURL: String = Constant.marvelBaseURL
		let apiKey: String = Constant.publicKey
		let apiPrivateKey: String = Constant.privateKey
		let timeStamp: Double = Date().timeIntervalSince1970
		let hashKey: String = ("\(timeStamp)" + apiPrivateKey + apiKey).md5
		let finalURL: String = "\(baseURL)" + "\(characterId!)" + "?&ts=\(timeStamp)" + "&apikey=\(apiKey)" + "&hash=\(hashKey)"
		
		return finalURL
	}
	
	
	// MARK: - Fetch API Data
	func fetchAPIData(marvelURL: String) {
		guard let marvelURL = URL(string: marvelURL) else {
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
					print("marvelResults: \n \(marvelResults)")
					NSLog("------\n")
					
					// Fill the character's content
					for index in 0..<marvelResults.count {
						self.characterComics.append(marvelPetitions.data.results[index].comics)
						self.characterSeries.append(marvelPetitions.data.results[index].series)
						self.characterStories.append(marvelPetitions.data.results[index].stories)
						self.characterEvents.append(marvelPetitions.data.results[index].events)
					}
					
					NSLog("------\n")
					print("characterComics: \(self.characterComics)")
					NSLog("------\n")
					
					print("characterSeries: \(self.characterSeries)")
					NSLog("------\n")
					
					print("characterStories: \(self.characterStories)")
					NSLog("------\n")
					
					print("characterEvents: \(self.characterEvents)")
					NSLog("------\n")
				
					DispatchQueue.main.async {
						self.tableView.reloadData()
						NSLog("------")
					}
					
				} catch let jsonError {
					NSLog("JSON error: \(jsonError)")
				}
				
			} else {
				self.showError()
			}
		}
		
		marvelTask.resume()
	}
	
	
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return (section == 0 || section == 1) ? 0.1 : 30  // For section 0 and 1 (where the hero's image  and hero's description are located), we use a height of 0.1 points. The other sections (which have names) have a height of 30.
	}

	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView()
		let label = UILabel()
		
		if (section == 0 || section == 1) {
			// Again, the label's color for section 0 is "clear"
			label.backgroundColor = .clear
			view.addSubview(label)
		} else {
			label.text = sections[section]
			label.backgroundColor = UIColor.lightGray
			label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
			view.addSubview(label)
		}

		return view
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0, 1:		// Image and description sections
			return 1
		
		case 2:			// Character's comics sections
			if characterComics.first?.items.count != 0 {
				return characterComics.first?.items.count ?? 1
			} else {
				return 1
			}
			
		case 3:			// Character's series sections
			if characterSeries.first?.items.count != 0 {
				return characterSeries.first?.items.count ?? 1
			} else {
				return 1
			}
			
		case 4:			// Character's stories sections
			if characterStories.first?.items.count != 0 {
				return characterStories.first?.items.count ?? 1
			} else {
				return 1
			}
			
		default:		// Character's events sections
			if characterEvents.first?.items.count != 0 {
				return characterEvents.first?.items.count ?? 1
			} else {
				return 1
			}
		}
	}
	
	
	// MARK: - Table view delegates
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterDetailsCell", for: indexPath)
		cell.textLabel?.numberOfLines = 0
		
		if indexPath.section == 0 {  // Hero's Image section
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterImageCell", for: indexPath) as? CharacterImageTableViewCell else { return UITableViewCell() }
					
			cell.characterImageView.image = UIImage(data: characterImageViewData ?? Data())
			
			return cell
		} else if indexPath.section == 1 { // Hero's description section
			
			if characterDetailDescription == "" {
				cell.textLabel?.text = noDataInSection.kNoCharacterDescription
			} else {
				cell.textLabel?.text = characterDetailDescription
			}
			
		} else if indexPath.section == 2 {  // Hero's comics section
			
			if characterComics.first?.items.count != 0 {
				cell.textLabel?.text = "\(characterComics.first?.items[indexPath.row].name ?? noDataInSection.kNoCharacterComics)"
			} else {
				cell.textLabel?.text = noDataInSection.kNoCharacterComics
			}

		} else if indexPath.section == 3 {  // Hero's series section
			
			if characterSeries.first?.items.count != 0 {
				cell.textLabel?.text = "\(characterSeries.first?.items[indexPath.row].name ?? noDataInSection.kNoCharacterSeries)"
			} else {
				cell.textLabel?.text = noDataInSection.kNoCharacterSeries
			}
				
		} else if indexPath.section == 4 {  // Hero's stories section
			
			if characterStories.first?.items.count != 0 {
				cell.textLabel?.text = "\(characterStories.first?.items[indexPath.row].name ?? noDataInSection.kNoCharacterStories)"
			} else {
				cell.textLabel?.text = noDataInSection.kNoCharacterStories
			}
			
		} else {  							// Hero's events section
			if characterEvents.first?.items.count != 0 {
				cell.textLabel?.text = "\(characterEvents.first?.items[indexPath.row].name ?? noDataInSection.kNoCharacterEvents)"
			} else {
				cell.textLabel?.text = noDataInSection.kNoCharacterEvents
			}			
		}
		
		return cell
	}
	
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
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
}
