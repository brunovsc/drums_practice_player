//
//  SongListTableViewController.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 04/03/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import Foundation
import UIKit

class SongListController: UITableViewController {
    
    var songs: [Song] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let error = SongsRepository.initializeRepository() {
            switch error {
            case .repository_folder_creation:
                UIAlertController.showErrorDialog(title: "Error", message: "Failed to create songs repository.", buttonTitle: "OK", buttonAction: nil, onController: self)
                return
            default:
                return
            }
        }
        SongsRepository.getSongs(success: { [weak self] (songs) in
            self?.songs = songs
        }) { [weak self] (error) in
            guard let self = self else { return }
            UIAlertController.showErrorDialog(title: "Error", message: "Failed to load songs from repository.", buttonTitle: "OK", buttonAction: nil, onController: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
