//
//  CharactersWorker.swift
//  ReplicaCharacterTableView
//
//  Created by Jorge Fuentes Casillas on 04/06/20.
//  Copyright © 2020 Jorge Fuentes Casillas. All rights reserved.
//

import UIKit
import MarvelApiWrapper


class CharactersWorker {
    func getCharacters(request: Characters.Request, completion: @escaping (Data?, Error?) -> Void) {
        var config = CharacterConfig()
        config.offset = request.offset
        config.nameStartsWith = request.nameStartsWith
        Service.getCharacters(config: config, completion: completion)
    }
}
