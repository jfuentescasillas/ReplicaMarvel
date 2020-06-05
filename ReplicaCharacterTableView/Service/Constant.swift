//
//  Constant.swift
//  ReplicaCharacterTableView
//
//  Created by Jorge Fuentes Casillas on 04/06/20.
//  Copyright © 2020 Jorge Fuentes Casillas. All rights reserved.
//

import Foundation


struct Constant {
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
}
