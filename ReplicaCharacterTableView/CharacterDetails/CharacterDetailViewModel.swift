//
//  CharacterDetailViewModel.swift
//  ReplicaCharacterTableView
//
//  Created by JFC on 08/06/20.
//  Copyright © 2020 JFC. All rights reserved.
//

import UIKit


struct CharacterDetailViewModel {
	let model = Model()
	let dataSource: DetailData


    func setTitle(character id: Int) {
        guard let character = model.getCharacterBy(id: id) else {
            return
        }

        dataSource.title.data = character.name
    }


	func setSummary(characterId: Int) {
        guard let character = model.getCharacterBy(id: characterId) else {
            return
        }
        dataSource.summaryText.data = character.desc
    }


    func setImageView(characterId: Int) {
        guard let character = model.getCharacterBy(id: characterId), let data = character.imageData else {
            return
        }
        dataSource.image.data = data
    }


	func setComicPager(characterId: Int) {
        guard let character = model.getCharacterBy(id: characterId), character.comics.isEmpty else {
            dataSource.comics.data = model.getComicsWith(characterId: characterId)
            return
        }

        Service.getComicsWith(characterId: characterId) { comics in
            self.dataSource.comics.data = comics
        }
    }

    func setEventPager(characterId: Int) {
        guard let character = model.getCharacterBy(id: characterId), character.events.isEmpty else {
            dataSource.events.data = model.getEventsWith(characterId: characterId)
            return
        }

        Service.getEventsWith(characterId: characterId) { events in
            self.dataSource.events.data = events
        }
    }

    func setSeriePager(characterId: Int) {
        guard let character = model.getCharacterBy(id: characterId), character.series.isEmpty else {
            dataSource.series.data = model.getSeriesWith(characterId: characterId)
            return
        }

        Service.getSeriesWith(characterId: characterId) { series in
            self.dataSource.series.data = series
        }
    }

    func setStoryCollectionView(characterId: Int) {
        guard let character = model.getCharacterBy(id: characterId), character.stories.isEmpty else {
            dataSource.stories.data = model.getStoriesWith(characterId: characterId)
            return
        }

        Service.getStoriesWith(characterId: characterId) { stories in
            self.dataSource.stories.data = stories
        }
    }
}
