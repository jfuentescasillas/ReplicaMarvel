//
//  Constant.swift
//  ReplicaCharacterTableView
//
//  Created by JFC on 04/06/20.
//  Copyright © 2020 JFC. All rights reserved.
//

import Foundation


struct Constant {
	public static let marvelBaseURL: String = "https://gateway.marvel.com/v1/public/characters/"
	public static let marvelSearchBaseURL: String = "https://gateway.marvel.com/v1/public/characters?"
    public static let publicKey = "b5a004aac50e22dbccea83b58947bf97" //"05b154e4641c958256743a9fa74bd16a"
    public static let privateKey = "81fd988cd9aaf76776187e1c6973b0291d794e8e"  //"8bd96a0e83daff033aa0e1aaf3fd1644aece99fe"
    
    enum Segue: String {
        case EventDetail
        case CharacterDetail
        case ComicDetail
        case SerieDetail
        case StoryDetail
        case CreatorDetail
        case ViewAll
    }
	
	// ** Key strings used in CharacterDetailsViewController ** //
	let kMainTableViewTitle: String = "Marvel Comics Characters"
	let kScrollDown: String = "Scroll down for more"
	
	// ** Key strings used in CharacterDetailsViewController ** //
	let kCharacterDetailsSectionTitles: [String] = ["Image", "Description", " Comics", " Series", " Stories", " Events"]
	let kNoCharacterDescription: String = "Description Not Available"
	let kNoCharacterComics: String = "No Comics Available"
	let kNoCharacterSeries: String = "No Series Available"
	let kNoCharacterStories: String = "No Stories Available"
	let kNoCharacterEvents: String = "No Events Available"	
	
	// ** Key strings used in the showError() method ** //
	let kShowErrorTitle: String = "Error loading feed"
	let kShowErrorMsg: String = "There was a problem loading the feed; please check your internet connection and try again later."
	let kShowErrorRetry: String = "Retry"
	
	// ** Key strings used in the CharacterSeachTableViewController ** //
	let kSearchCharactersTitle: String = "Character Search"
	let kNonExistentCharacter: String = "This character does not exist"
}
