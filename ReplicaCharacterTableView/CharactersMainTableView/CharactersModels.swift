//
//  CharactersModels.swift
//  ReplicaCharacterTableView
//
//  Created by JFC on 03/06/20.
//  Copyright © 2020 JFC. All rights reserved.
//

import UIKit


enum Characters {
	// MARK: Use cases
	struct Request {
		var offset: Int = 0
		var nameStartsWith: String?
	}
	
	struct Response {
		var data: Data?
	}
	
	struct ViewModel {
		var characterId: Int?
	}
}
