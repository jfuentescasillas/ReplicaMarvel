//
//  MarvelCharactersAPIStruct.swift
//  ReplicaCharacterTableView
//
//  Created by JFC on 10/06/20.
//  Copyright © 2020 JFC. All rights reserved.
//

import Foundation


struct MarvelCharactersAPIStruct: Codable {
	//var code: Int
	var data: MarvelData
}

struct MarvelData: Codable {
	var total: Int
	var results: [MarvelResults]
}

struct MarvelResults: Codable {
	var id: Int
	var name: String
	var description: String
	var thumbnail: MarvelThumbnail
	var comics: MarvelComics
	var series: MarvelSeries
	var stories: MarvelStories
	var events: MarvelEvents
}

struct MarvelThumbnail: Codable {
	var path: String
	var imageExtension: String
	
	// Renaming the image extension property since it has name conflict with reserved word "extension"
	private enum CodingKeys: String, CodingKey {
		case path
		case imageExtension = "extension"
	}
}

struct MarvelComics: Codable {
	var items: [MarvelItems]
}

struct MarvelSeries: Codable {
	var items: [MarvelItems]
}

struct MarvelStories: Codable {
	var items: [MarvelItems]
}

struct MarvelEvents: Codable {
	var items: [MarvelItems]
}

struct MarvelItems: Codable {
	var name: String
}

