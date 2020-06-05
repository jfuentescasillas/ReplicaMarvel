//
//  EventConfig.swift
//  MarvelApiWrapper
//
//  Created by Tuyen Le on 11/24/19.
//
import Foundation

/// GET /v1/public/events configuration. Provide optional filter
public struct EventConfig {
    public var name: String?
    
    public var nameStartsWith: String?
    
    public var modifiedSince: String?
    
    public var creators: Int?
    
    public var characters: Int?
    
    public var series: Int?
    
    public var comics: Int?
    
    public var stories: Int?
    
    public var orderBy: String?
    
    public var limit: Int?
    
    public var offset: Int?
    
    public init() {}
}

/// GET /v1/public/creators/{characters} configuration. Provide optional filter
public struct EventCharacterConfig {
    public var name: String?
    
    public var nameStartsWith: String?
    
    public var modifiedSince: String?
    
    public var comics: Int?
    
    public var series: Int?
    
    public var stories: Int?
    
    public var orderBy: String?
    
    public var limit: Int?
    
    public var offset: Int?
    
    public init() {}
}

/// GET /v1/public/creators/{comics} configuration. Provide optional filter
public struct EventComicConfig {
    public var format: Int?
    
    public var formatType: String?
    
    public var noVariants: Bool?
    
    public var dateDescriptor: String?
    
    public var dateRange: Int?
    
    public var title: String?
    
    public var titleStartsWith: String?
    
    public var startYear: Int?
    
    public var issueNumber: Int?
    
    public var diamondCode: String?
    
    public var digitalId: Int?
    
    public var upc: String?
    
    public var isbn: String?
    
    public var ean: String?
    
    public var issn: String?
    
    public var hasDigitalIssue: Bool?
    
    public var modifiedSince: String?
    
    public var creators: Int?
    
    public var characters: Int?
    
    public var series: Int?
    
    public var events: Int?
    
    public var stories: Int?
    
    public var sharedAppearances: Int?
    
    public var collaborators: Int?
    
    public var orderBy: String?
    
    public var limit: Int?
    
    public var offset: Int?
    
    public init() {}
}

/// GET /v1/public/creators/{creators} configuration. Provide optional filter
public struct EventCreatorConfig {
    public var firstName: String?
    
    public var middleName: String?
    
    public var lastName: String?
    
    public var suffix: String?
    
    public var nameStartsWith: String?
    
    public var firstNameStartsWith: String?
    
    public var middleNameStartsWith: String?
    
    public var lastNameStartsWith: String?
    
    public var modifiedSince: String?
    
    public var comics: Int?
    
    public var series: Int?
    
    public var stories: Int?
    
    public var orderBy: String?
    
    public var limit: Int?
    
    public var offset: Int?
    
    public init() {}
}

/// GET /v1/public/creators/{series} configuration. Provide optional filter
public struct EventSerieConfig {
    public var title: String?
    
    public var titleStartsWith: String?
    
    public var startYear: Int?
    
    public var modifiedSince: String?
    
    public var comics: Int?
    
    public var stories: Int?
    
    public var creators: Int?
    
    public var characters: Int?
    
    public var seriesType: String?
    
    public var contains: String?
    
    public var orderBy: String?
    
    public var limit: Int?
    
    public var offset: Int?
    
    public init() {}
}

/// GET /v1/public/creators/{stories} configuration. Provide optional filter
public struct EventStoryConfig {
    public var modifiedSince: String?
    
    public var comics: Int?
    
    public var series: Int?
    
    public var creators: Int?
    
    public var characters: Int?
    
    public var orderBy: String?
    
    public  var limit: Int?
    
    public var offset: Int?
    
    public init() {}
}
