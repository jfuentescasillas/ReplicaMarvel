//
//  File.swift
//  MarvelApiWrapper
//
//  Created by Tuyen Le on 11/24/19.
//
import Foundation

/// GET /v1/public/stories configuration. Provide optional filter.
public struct StoryConfig {

    public var modifiedSince: String?
    
    public var comics: Int?
    
    public var series: String?
    
    public var events: Int?
    
    public var creators: Int?
    
    public var characters: Int?
    
    public var orderBy: String?
    
    public var limit: Int?
    
    public var offset: Int?
    
    public init() {}
}

/// GET /v1/public/stories/{storyId}/characters configuration. Provide optional filter.
public struct StoryCharacterConfig {
    public var name: String?
    
    public var nameStartsWith: String?
    
    public var modifiedSince: String?
    
    public var comics: Int?
    
    public var series: Int?
    
    public var events: Int?
    
    public var orderBy: String?
    
    public var limit: Int?
    
    public var offset: Int?
    
    public init() {}
}

/// GET /v1/public/stories/{storiesId}/comics configuration. Provide optional filter.
public struct StoryComicConfig {
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
    
    public var sharedAppearances: Int?
    
    public var collaborators: Int?
    
    public var orderBy: String?
    
    public var limit: Int?
    
    public var offset: Int?
    
    public init() {}
}

/// GET /v1/public/stories/{storyId}/creators configuration. Provide optional filter.
public struct StoryCreatorConfig {
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
    
    public var events: Int?
    
    public var orderBy: String?
    
    public var limit: Int?
    
    public var offset: Int?
    
    public init() {}
}

/// GET /v1/public/stories/{storyId}/events configuration. Provide optional filter.
public struct StoryEventConfig {
    public var name: String?
    
    public var nameStartsWith: String?
    
    public var modifiedSince: String?
    
    public var creators: Int?
    
    public var characters: Int?
    
    public var series: Int?
    
    public var comics: Int?
    
    public var orderBy: String?
    
    public var limit: Int?
    
    public var offset: Int?
    
    public init() {}
}

/// GET /v1/public/stories/{storyId}/series configuration. Provide optional filter.
public struct StorySerieConfig {
    public var events: Int?
    
    public var title: String?
    
    public var titleStartsWith: String?
    
    public var startYear: Int?
    
    public var modifiedSince: String?
    
    public var comics: Int?
    
    public var creators: Int?
    
    public var characters: Int?
    
    public var seriesType: String?
    
    public var contains: String?
    
    public var orderBy: String?
    
    public var limit: Int?
    
    public var offset: Int?
    
    public init() {}
}
