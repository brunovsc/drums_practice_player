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
//        let songsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(songs_folder_name)
//        do {
//            let files = try FileManager.default.contentsOfDirectory(at: songsDirectory!, includingPropertiesForKeys: nil, options: [FileManager.DirectoryEnumerationOptions.skipsHiddenFiles])
//            var songs = [Song]()
//            for fileURL in files {
//                if fileURL.lastPathComponent.contains(".mp3") {
//                    let songTitle: String = fileURL.lastPathComponent.replacingOccurrences(of: ".mp3", with: "")
//                    let song = Song(title: songTitle, url: fileURL)
//                    print(fileURL)
//                    songs.append(song)
//                }
//            }
//            success(songs)
//        }
//        catch {
//            failure(.repository_folder_read)
//        }
//        return
        
        
        if let path = Bundle.main.path(forResource: "mockedSongs", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let songList = try JSONDecoder().decode(SongList.self, from: data)
                guard let songsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(songs_folder_name) else {
                    failure(.repository_folder_read)
                    return
                }
                if var songs = songList.songs {
                    for i in 0...songs.count - 1 {
                        let urlString = songsDirectory.absoluteString.replacingOccurrences(of: "///var", with: "///private/var").appending("\(songs[i].title?.replacingOccurrences(of: " ", with: "%20") ?? "-").mp3")
                        songs[i].url = URL(string: urlString)
                    }
                    success(songs.sorted(by: { (songA, songB) -> Bool in
                        return (songA.title ?? "-") < (songB.title ?? "-")
                    }))
                    return
                }
                success([])
                return
            } catch {
                failure(.repository_folder_read)
            }
        }
    }
}
