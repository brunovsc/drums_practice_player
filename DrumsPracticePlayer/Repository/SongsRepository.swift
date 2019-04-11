//
//  SongsRepository.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 04/03/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import Foundation

class SongsRepository {
    
    private static let songs_folder_name = "Songs"
    
    enum RepositoryError {
        case repository_folder_creation
        case repository_folder_read
    }
    
    static func initializeRepository() -> RepositoryError? {
        if let error = createFolder() {
            return error
        }
        return nil
    }
    
    private static func createFolder() -> RepositoryError? {
        let fileManager = FileManager.default
        if let appDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath =  appDirectory.appendingPathComponent(songs_folder_name)
            if !fileManager.fileExists(atPath: filePath.path) {
                do {
                    try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    return .repository_folder_creation
                }
            }
        }
        return nil
    }
    
    static func getSongs(success: @escaping (([Song]) -> Void),
                         failure: @escaping ((RepositoryError?) -> Void)) {
        var songs = [Song]()
        var repositoryError: RepositoryError?
        if let path = Bundle.main.path(forResource: "mockedSongs", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let songList = try JSONDecoder().decode(SongList.self, from: data)
                guard let songsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(songs_folder_name) else {
                    failure(.repository_folder_read)
                    return
                }
                if var serviceSongs = songList.songs {
                    for i in 0...serviceSongs.count - 1 {
                        let urlString = songsDirectory.absoluteString.replacingOccurrences(of: "///var", with: "///private/var").appending("\(serviceSongs[i].title?.replacingOccurrences(of: " ", with: "%20") ?? "-").mp3")
                        serviceSongs[i].url = URL(string: urlString)
                    }
                    songs.append(contentsOf: serviceSongs)
                }
            } catch {
                repositoryError = .repository_folder_read
            }
        }
        
        let songsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(songs_folder_name)
        do {
            let files = try FileManager.default.contentsOfDirectory(at: songsDirectory!, includingPropertiesForKeys: nil, options: [FileManager.DirectoryEnumerationOptions.skipsHiddenFiles])
            for fileURL in files {
                if fileURL.lastPathComponent.contains(".mp3") {
                    let songTitle: String = fileURL.lastPathComponent.replacingOccurrences(of: ".mp3", with: "")
                    let songUploaded = songs.contains { (song) -> Bool in
                        return song.title == songTitle
                    }
                    if !songUploaded {
                        let song = Song(id: nil, title: songTitle, artist: nil, url: fileURL, metronome: nil, checkpoints: nil)
                        songs.append(song)
                    }
                }
            }
        } catch {
            repositoryError = .repository_folder_read
        }
        
        if let repositoryError = repositoryError {
            failure(repositoryError)
        } else {
            success(songs.sorted(by: { (songA, songB) -> Bool in
                return (songA.title ?? "-") < (songB.title ?? "-")
            }))
        }
    }
    
    static func saveSongs(_ songs: [Song]) {
        var songList = SongList()
        songList.songs = songs
        
        do {
            let songListData = try JSONEncoder().encode(songList)
            guard let songsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(songs_folder_name) else {
                print("asdsa")
                return
            }
            let urlString = songsDirectory.absoluteString.replacingOccurrences(of: "///var", with: "///private/var").appending("songList.txt")
            let url = URL(string: urlString)
            try songListData.write(to: url!)
        } catch {
            print("asdsa")
        }
    }
}
