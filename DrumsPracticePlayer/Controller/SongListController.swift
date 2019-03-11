//
//  SongListTableViewController.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 04/03/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MediaPlayer

class SongListController: UIViewController {
    
    var player: AVAudioPlayer?
    
    var songs: [Song] = []
    var currentSelectedSongIndex: Int = -1
    
    var popupPlayerViewBottomConstraint: NSLayoutConstraint?
    
    lazy var songsTableView: UITableView = {
        let songsTableView = UITableView()
        songsTableView.translatesAutoresizingMaskIntoConstraints = false
        return songsTableView
    }()
    
    lazy var popupPlayerView: PopupPlayerView = {
        let popupPlayer = PopupPlayerView()
        popupPlayer.translatesAutoresizingMaskIntoConstraints = false
        return popupPlayer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
        setupView()
        initializeRepository()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }
    
    private func setupView() {
        title = "Drums Practice Player"
        setupTableView()
        setupPopupPlayerView()
    }
    
    private func setupPlayer() {
        setupRemoteTransportControls()
    }
    
    private func setupTableView() {
        view.addSubview(songsTableView)
        songsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        songsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        songsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        songsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        songsTableView.backgroundColor = .dark_green
        songsTableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        songsTableView.separatorStyle = .none
        songsTableView.delegate = self
        songsTableView.dataSource = self
        songsTableView.register(SongTableViewCell.self, forCellReuseIdentifier: "SongTableViewCell")
    }
    
    private func setupPopupPlayerView() {
        view.addSubview(popupPlayerView)
        popupPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        popupPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        popupPlayerViewBottomConstraint = popupPlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: PopupPlayerView.height)
        popupPlayerViewBottomConstraint?.isActive = true
        popupPlayerView.delegate = self
    }
    
    private func initializeRepository() {
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
    
    
}

extension SongListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell", for: indexPath) as? SongTableViewCell {
            cell.model = songs[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playSong(at: indexPath.row)
    }
}

extension SongListController: PopupPlayerViewDelegate {
    func playPauseButtonDidReceiveTouchUpInside() {
        guard let player = player else { return }
        if player.isPlaying {
            player.pause()
            popupPlayerView.pauseSong()
        } else {
            showPlayer()
            player.play()
            popupPlayerView.playSong(title: songs[currentSelectedSongIndex].title)
        }
    }
    
    func stopButtonDidReceiveTouchUpInside() {
        player?.stop()
        hidePlayer()
        songsTableView.deselectRow(at: IndexPath(row: currentSelectedSongIndex, section: 0), animated: false)
    }
    
    func previousSongButtonDidReceiveTouchUpInside() {
        if currentSelectedSongIndex - 1 < 0 || currentSelectedSongIndex - 1 >= songs.count { return }
        songsTableView.selectRow(at: IndexPath(row: currentSelectedSongIndex - 1, section: 0), animated: true, scrollPosition: .middle)
        playSong(at: currentSelectedSongIndex - 1)
    }
    
    func nextSongButtonDidReceiveTouchUpInside() {
        if currentSelectedSongIndex + 1 < 0 || currentSelectedSongIndex + 1 >= songs.count { return }
        songsTableView.selectRow(at: IndexPath(row: currentSelectedSongIndex + 1, section: 0), animated: true, scrollPosition: .middle)
        playSong(at: currentSelectedSongIndex + 1)
    }
}

extension SongListController {
    func setupRemoteTransportControls() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            guard let player = self.player else { return .commandFailed }
            if player.rate == 1.0 {
                player.pause()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            guard let player = self.player else { return .commandFailed }
            player.play()
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            guard let _ = self.player else { return .commandFailed }
            self.nextSongButtonDidReceiveTouchUpInside()
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            guard let _ = self.player else { return .commandFailed }
            self.previousSongButtonDidReceiveTouchUpInside()
            return .success
        }
    }
    
    func setupNowPlaying() {
        guard let player = player else { return }
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = songs[currentSelectedSongIndex].title
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}

extension SongListController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if !flag {
            return
        }
        if currentSelectedSongIndex < songs.count - 1 {
            playSong(at: currentSelectedSongIndex + 1)
        }
    }
}

extension SongListController {
    func playSong(at index: Int) {
        if index < 0 || index >= songs.count { return }
        currentSelectedSongIndex = index
        songsTableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .middle)
        showPlayer()
        let url = songs[currentSelectedSongIndex].url
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.delegate = self
            player.play()
            popupPlayerView.playSong(title: songs[currentSelectedSongIndex].title)
            setupNowPlaying()
        } catch _ {
            UIAlertController.showErrorDialog(title: "Error", message: "Failed to play selected song.", buttonTitle: "OK", buttonAction: nil, onController: self)
            stopButtonDidReceiveTouchUpInside()
        }
    }
    
    func showPlayer() {
        self.popupPlayerViewBottomConstraint?.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.songsTableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: PopupPlayerView.height, right: 0)
        })
    }
    
    func hidePlayer() {
        self.popupPlayerViewBottomConstraint?.constant = PopupPlayerView.height
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.songsTableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        })
    }
}
