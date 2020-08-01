//
//  Model.swift
//  GIF Preview - Test task
//
//  Created by Dmitry Likhaletov on 09.07.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation

// MARK: - API model
struct GifObjectResponse: Decodable {
    let results: [GifData]
    let next: String
}

struct GifData: Decodable {
    let media: [GifMedia]
    let id: String
}

struct GifMedia: Decodable {
    let tinygif: GifTiny
    let gif: Gif
}

struct GifTiny: Decodable {
    let url: URL
    let preview: URL
}

struct Gif: Decodable {
    let url: URL
}


// MARK: - App Model
struct Model {
    var previewImageURL: URL
    var imageURL: URL
    var imageID: String
}
