//
//  Song.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 04/03/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import Foundation

struct Song: Decodable {
//    let id: Int?
    let title: String?
//    let number: Int?
    var url: URL?
//    var uploaded: Bool?
    let metronome: Metronome?
    let checkpoints: [Checkpoint]?
}

struct Checkpoint: Decodable {
    let name: String?
    let time: Double?
    let metronome: Metronome?
}

struct SongList: Decodable {
    var songs: [Song]?
}

struct Metronome: Decodable {
    let tempo: Double?
    let timeSignatureUpper: Int?
    let timeSignatureLower: Int?
}
