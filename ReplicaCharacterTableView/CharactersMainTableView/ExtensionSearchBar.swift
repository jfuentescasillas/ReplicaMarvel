//
//  ExtensionSearchBar.swift
//  ReplicaCharacterTableView
//
//  Created by JFC on 13/06/20.
//  Copyright © 2020 JFC. All rights reserved.
//

import UIKit


// MARK: - Extension. SearchBarDelegate
extension CharacterViewController {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		let characterSearched: String = searchCharacterSearchBar.text ?? ""
		guard let characterSearchViewController = storyboard?.instantiateViewController(identifier: "CharacterSearch") as? CharacterSeachTableViewController else { return }
		navigationController?.pushViewController(characterSearchViewController, animated: true)
		navigationController?.navigationBar.prefersLargeTitles = false
		
		// Delete all the previous searched content
		deleteGlobalContent()
		
		// We assign the name to search to the characterSearchViewController
		characterSearchViewController.searchedCharacterName = characterSearched
	}
	
	
	func deleteGlobalContent() {
		GlobalData.results.removeAll()
		GlobalData.characterComics.removeAll()
		GlobalData.characterDescription.removeAll()
		GlobalData.characterEvents.removeAll()
		GlobalData.characterImageURL.removeAll()
		GlobalData.characterName.removeAll()
		GlobalData.characterSeries.removeAll()
		GlobalData.characterStories.removeAll()
	}
}



/*https://gateway.marvel.com/v1/public/characters?name=blink&ts=1&apikey=b5a004aac50e22dbccea83b58947bf97&hash=cf8530437ab0e239d120f70010f33a34

 https://gateway.marvel.com/v1/public/characters/BLob?&ts=1&apikey=b5a004aac50e22dbccea83b58947bf97&hash=cf8530437ab0e239d120f70010f33a34
*/
