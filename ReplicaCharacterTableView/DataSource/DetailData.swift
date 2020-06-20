//
//  DetailData.swift
//  ReplicaCharacterTableView
//
//  Created by JFC on 08/06/20.
//  Copyright © 2020 JFC. All rights reserved.
//

import Foundation


struct DetailData {
    var comics = GenericData([Comic]())
    var events = GenericData([Event]())
    var series = GenericData([Serie]())
    var stories = GenericData([Story]())
    var characters = GenericData([Character]())
    var creators = GenericData([Creator]())
    var summaryText = GenericData("")
    var image = GenericData(Data())
    var title = GenericData("")
    var issueNumber = GenericData(0)
    var pageTotal = GenericData(0)
    var hardCopyPrice = GenericData(Float(0))
    var upc = GenericData("")
    var diamondCode = GenericData("")
    var isbn = GenericData("")
    var issn = GenericData("")
    var format = GenericData("")
    var startDate = GenericData("")
    var endDate = GenericData("")
    var startYear = GenericData(0)
    var endYear = GenericData(0)
    var rating = GenericData("")
}
