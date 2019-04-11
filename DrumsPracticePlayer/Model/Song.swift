//
//  Song.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 04/03/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import Foundation

struct Song: Decodable, Encodable {
    var id: Int?
    let title: String?
    let artist: String?
    var url: URL?
    var metronome: Metronome?
    var checkpoints: [Checkpoint]?
}

struct Checkpoint: Decodable, Encodable {
    let name: String?
    let time: Double?
}

struct SongList: Decodable, Encodable {
    var songs: [Song]?
}

struct Metronome: Decodable, Encodable {
    var tempo: Int?
    var timeSignatureUpper: Int?
    var timeSignatureLower: Int?
}
