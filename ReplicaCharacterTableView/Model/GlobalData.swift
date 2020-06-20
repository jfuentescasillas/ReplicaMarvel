//
//  GlobalData.swift
//  ReplicaCharacterTableView
//
//  Created by JFC on 14/06/20.
//  Copyright © 2020 JFC. All rights reserved.
//

import Foundation


// MARK: - Global variables
struct GlobalData {
	static var results = [MarvelResults]()
	static var characterName = [String]()
	static var characterID: Int?
	static var thumbnail = [MarvelThumbnail]()
	static var characterImageURL = [String]()
	static var characterDescription = [String]()
	static var characterComics = [MarvelComics]()
	static var characterSeries = [MarvelSeries]()
	static var characterStories = [MarvelStories]()
	static var characterEvents = [MarvelEvents]()
}
