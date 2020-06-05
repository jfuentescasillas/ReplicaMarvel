//
//  Config.swift
//  MarvelApiWrapper
//
//  Created by Tuyen Le on 11/24/19.
//
import Foundation

/// GET /v1/public/characters configuration. Provide optional filter
public struct CharacterConfig {

    // MARK: - Params provide to GET /v1/public/characters
    public var name: String?

    public var nameStartsWith: String?

    public var modifiedSince: String?

    public var comics: Int?

    public var series: Int?

    public var events: Int?

    public var stories: Int?

    public var orderBy: String?

    public var limit: Int?

    public var offset: Int?

    // MARK: - initialize
    public init() {}
}

/// GET /v1/public/characters/{characterId}/comics configuration. Provide optional filter
public struct CharacterComicConfig {
    // MARK: - Params provide to GET /v1/public/characters/{characterId}/comics
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

    public var series: Int?

    public var events: Int?

    public var stories: Int?

    public var sharedAppearances: Int?

    public var collaborators: Int?

    public var orderBy: String?

    public var limit: Int?

    public var offset: Int?

    // MARK: - Initialize
    public init() {}
}

/// GET /v1/public/characters/{characterId}/events configuration. Provide optional filter
public struct CharacterEventConfig {
    // MARK: - Params provide to GET /v1/public/characters/{characterId}/events
    public var nameStartsWith: String?

    public var modifiedSince: String?

    public var creators: Int?

    public var series: Int?

    public var comics: Int?

    public var stories: Int?

    public var orderBy: String?

    public var limit: Int?

    public var offset: Int?

    // MARK: - Initialize
    public init() {}
}

/// GET /v1/public/characters/{characterId}/series configuration. Provide optional filter
public struct CharacterSerieConfig {
    // MARK: - Params provide to GET /v1/public/characters/{characterId}/series
    public var title: String?

    public var titleStartsWith: String?

    public var startYear: Int?

    public var modifiedSince: String?

    public var comics: Int?

    public var stories: Int?

    public var events: Int?

    public var creators: Int?

    public var seriesType: String?

    public var contains: String?

    public var orderBy: String?

    public var limit: Int?

    public var offset: Int?

    // MARK: - Initialize
    public init() {}
}

/// GET /v1/public/characters/{characterId}/stories configuration. Provide optional filter
public struct CharacterStoryConfig {
    // MARK: - Params provide to GET /v1/public/characters/{characterId}/stories
    public var modifiedSince: String?

    public var comics: Int?

    public var series: Int?

    public var events: Int?

    public var creators: Int?

    public var orderBy: String?

    public var limit: Int?

    public var offset: Int?
    
    // MARK: - Initialize
    public init() {}
}
