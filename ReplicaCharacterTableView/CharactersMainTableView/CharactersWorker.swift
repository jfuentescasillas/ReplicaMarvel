//
//  CharactersWorker.swift
//  ReplicaCharacterTableView
//
//  Created by JFC on 04/06/20.
//  Copyright © 2020 JFC. All rights reserved.
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
