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

class HomeViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .default }
    
    var songPlayer: AVAudioPlayer?
    var metronome: MetronomePlayer?
    var currentMetronomeTask: DispatchWorkItem?
    
    var songs: [Song] = []
    var currentSelectedSongIndex: Int = -1
    var currentSelectedCheckpointIndex: Int = -1
    
    var popupPlayerViewBottomConstraint: NSLayoutConstraint?
    var popupPlayerViewTopConstraint: NSLayoutConstraint?
    var popupPlayerViewHeightConstraint: NSLayoutConstraint?
    
    lazy var songsTableView: UITableView = {
        let songsTableView = UITableView()
        songsTableView.translatesAutoresizingMaskIntoConstraints = false
        return songsTableView
    }()
    
    lazy var popupPlayerView: PopupPlayerView = {
        let popupPlayer = PopupPlayerView(delegate: self,
                                          pickerViewDelegate: self,
                                          pickerViewDataSource: self)
        popupPlayer.translatesAutoresizingMaskIntoConstraints = false
        return popupPlayer
    }()
    
    lazy var menuView: MenuView = {
        let view = MenuView(delegate: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var menuNavigationButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(menuNavigationButtonDidReceiveTouchUpInside))
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
        setupView()
        initializeRepository()
        initializeMetronome()
    }
    
    override var canBecomeFirstResponder: Bool {        
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .light_green
        navigationItem.backBarButtonItem?.title = "Back"
        navigationItem.hidesBackButton = true

        navigationItem.setRightBarButton(menuNavigationButton, animated: true)
        
        if popupPlayerView.isExpanded {
            navigationItem.setRightBarButton(nil, animated: true)
        } else {
            self.navigationItem.setRightBarButton(self.menuNavigationButton, animated: true)
        }
    }
    
    @objc func menuNavigationButtonDidReceiveTouchUpInside() {
        menuView.isHidden = !menuView.isHidden
    }
    
    private func setupView() {
        title = "Drums Practice Player"
        view.backgroundColor = .dark_green
        setupTableView()
        setupMenuView()
        setupPopupPlayerView()
    }
    
    private func setupPlayer() {
        setupRemoteTransportControls()
    }
    
    private func setupTableView() {
        view.addSubview(songsTableView)
        songsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        songsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        songsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        songsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        songsTableView.backgroundColor = .dark_green
        songsTableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        songsTableView.separatorStyle = .none
//        songsTableView.isEditing = true
        songsTableView.delegate = self
        songsTableView.dataSource = self
        songsTableView.register(SongTableViewCell.self, forCellReuseIdentifier: "SongTableViewCell")
    }
    
    private func setupMenuView() {
        view.addSubview(menuView)
        menuView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        menuView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        menuView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        menuView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        menuView.isHidden = true
    }
    
    private func setupPopupPlayerView() {
        view.addSubview(popupPlayerView)
        popupPlayerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        popupPlayerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        popupPlayerViewBottomConstraint = popupPlayerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: PopupPlayerView.minHeight + 50)
        popupPlayerViewBottomConstraint?.isActive = true
        popupPlayerViewTopConstraint = popupPlayerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        popupPlayerViewTopConstraint?.isActive = false
        popupPlayerViewHeightConstraint = popupPlayerView.heightAnchor.constraint(equalToConstant: PopupPlayerView.minHeight)
        popupPlayerViewHeightConstraint?.isActive = true
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
    
    private func initializeMetronome() {
        metronome = MetronomePlayer()
        guard let pathForSound = Bundle.main.path(forResource: "snizzap1", ofType: "wav"),
            let pathForAccent = Bundle.main.path(forResource: "snizzap2", ofType: "wav") else { return }
        
        let metronomeSoundURL = NSURL(fileURLWithPath: pathForSound)
        let metronomeAccentURL = NSURL(fileURLWithPath: pathForAccent)
        
        metronome?.metronomeSoundPlayer = try? AVAudioPlayer(contentsOf: metronomeSoundURL as URL)
        metronome?.metronomeAccentPlayer = try? AVAudioPlayer(contentsOf: metronomeAccentURL as URL)
        
        metronome?.metronomeSoundPlayer.prepareToPlay()
        metronome?.metronomeAccentPlayer.prepareToPlay()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedSong = songs[sourceIndexPath.row]
        songs.remove(at: sourceIndexPath.row)
        songs.insert(movedSong, at: destinationIndexPath.row)
    }
}

extension HomeViewController: CheckpointsViewDelegate {
    func previousCheckpointButtonDidReceiveTouchUpInside() {
        selectCheckpoint(currentSelectedCheckpointIndex - 1)
    }
    
    func nextCheckpointButtonDidReceiveTouchUpInside() {
        selectCheckpoint(currentSelectedCheckpointIndex + 1)
    }
}

extension HomeViewController: PopupPlayerViewDelegate {
    func playPauseButtonDidReceiveTouchUpInside() {
        guard let player = songPlayer else { return }
        if player.isPlaying {
            player.pause()
            popupPlayerView.pauseSong()
        } else {
            showPlayer()
            player.play()
            popupPlayerView.playSong(title: songs[currentSelectedSongIndex].title ?? "-", hasCheckpoints: currentSongHasCheckpoints())
        }
    }
    
    func stopButtonDidReceiveTouchUpInside() {
        songPlayer?.stop()
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
    
    func repeatButtonDidReceiveTouchUpInside() {
        
    }
    
    func shuffleButtonDidReceiveTouchUpInside() {
        
    }
    
    func editButtonDidReceiveTouchUpInside() {
        songPlayer?.pause()
        popupPlayerView.pauseSong()
        if currentSelectedSongIndex != -1 {
            navigationController?.pushViewController(SongInformationViewController(song: songs[currentSelectedSongIndex]), animated: true)
        }
    }
    
    func selectCheckpoint(_ checkpointIndex: Int) {
        currentMetronomeTask?.cancel()
        currentSelectedCheckpointIndex = checkpointIndex
        let song = songs[currentSelectedSongIndex]
        guard let checkpoint = song.checkpoints?[checkpointIndex] else { return }
        songPlayer?.pause()
        songPlayer?.setVolume(0, fadeDuration: 0)
        songPlayer?.currentTime = checkpoint.time ?? 0
        if let tempo = song.metronome?.tempo {
            metronome?.tempo = tempo
        } else {
            metronome?.tempo = checkpoint.metronome?.tempo ?? 0
        }
        if metronome?.metronomeIsOn ?? false {
            metronome?.restartMetronome()
        } else {
            metronome?.startMetronome()
        }
        currentMetronomeTask = DispatchWorkItem {
            self.songPlayer?.play()
            self.songPlayer?.setVolume(1.0, fadeDuration: 0)
            self.metronome?.stopMetronome()
        }
        guard let task = currentMetronomeTask else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + (metronome?.timeToWait() ?? 0), execute: task)
    }
    
    func expandToFullPlayer(animations: (()->())?, completion: (()->())?) {
        navigationItem.setRightBarButton(nil, animated: true)
        popupPlayerViewHeightConstraint?.isActive = false
        popupPlayerViewTopConstraint?.isActive = true
        UIView.animate(withDuration: 0.5, delay: 0/0, options: .curveEaseInOut, animations: {
            animations?()
            self.view.layoutIfNeeded()
        }) { (finised) in
            UIView.animate(withDuration: 0.2, animations: {
                completion?()
            })
        }
    }
    
    func reduceToSmallPlayer(animations: (()->())?, completion: (()->())?) {
        popupPlayerViewTopConstraint?.isActive = false
        popupPlayerViewHeightConstraint?.isActive = true
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            animations?()
            self.view.layoutIfNeeded()
        }) { (finished) in
            completion?()
            self.navigationItem.setRightBarButton(self.menuNavigationButton, animated: true)
        }
    }
}

extension HomeViewController {
    func setupRemoteTransportControls() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            guard let player = self.songPlayer else { return .commandFailed }
            if player.rate == 1.0 {
                player.pause()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            guard let player = self.songPlayer else { return .commandFailed }
            player.play()
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            guard let _ = self.songPlayer else { return .commandFailed }
            self.nextSongButtonDidReceiveTouchUpInside()
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            guard let _ = self.songPlayer else { return .commandFailed }
            self.previousSongButtonDidReceiveTouchUpInside()
            return .success
        }
    }
    
    func setupNowPlaying() {
        guard let player = songPlayer else { return }
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = songs[currentSelectedSongIndex].title
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}

extension HomeViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if !flag {
            currentSelectedSongIndex = -1
            return
        }
        if currentSelectedSongIndex < songs.count - 1 {
            playSong(at: currentSelectedSongIndex + 1)
        }
    }
}

extension HomeViewController {
    func playSong(at index: Int) {
        if index < 0 || index >= songs.count { return }
        currentSelectedSongIndex = index
        currentSelectedCheckpointIndex = 0
        popupPlayerView.checkpointsStackView.pickerView.selectRow(0, inComponent: 0, animated: false)
        popupPlayerView.playSong(title: songs[currentSelectedSongIndex].title ?? "-", hasCheckpoints: currentSongHasCheckpoints())
        showPlayer()
        songsTableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .middle)
        guard let url = songs[currentSelectedSongIndex].url else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            songPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = songPlayer else { return }
            player.delegate = self
            player.enableRate = true
            player.play()
            setupNowPlaying()
        } catch _ {
            songPlayer?.stop()
            UIAlertController.showErrorDialog(title: "Error", message: "Failed to play selected song.", buttonTitle: "OK", buttonAction: {
                self.popupPlayerView.stopPlayer()
            }, onController: self)
            
        }
    }
    
    func showPlayer() {
        self.popupPlayerViewBottomConstraint?.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.songsTableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: PopupPlayerView.minHeight + 15, right: 0)
        })
    }
    
    func hidePlayer() {
        currentSelectedCheckpointIndex = 0
        self.popupPlayerViewBottomConstraint?.constant = PopupPlayerView.minHeight + 50
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.songsTableView.deselectRow(at: IndexPath(row: self.currentSelectedSongIndex, section: 0), animated: true)
            self.currentSelectedSongIndex = 0
            self.songsTableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        })
    }
}

extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func currentSongHasCheckpoints() -> Bool {
        guard let count = songs[currentSelectedSongIndex].checkpoints?.count else { return false }
        return count > 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return songs[currentSelectedSongIndex].checkpoints?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let count = songs[currentSelectedSongIndex].checkpoints?.count else { return "-" }
        if row < count {
            return songs[currentSelectedSongIndex].checkpoints?[row].name ?? "-"
        }
        return "-"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectCheckpoint(row)
    }
}

extension HomeViewController: MenuViewDelegate {
    func metronomeButtonDidReceiveTouchUpInside() {
        menuView.isHidden = true
        songPlayer?.pause()
        popupPlayerView.pauseSong()
        if currentSelectedSongIndex == -1 {
            navigationController?.pushViewController(MetronomeViewController(), animated: true)
        } else {
            navigationController?.pushViewController(MetronomeViewController(song: songs[currentSelectedSongIndex]), animated: true)
        }
    }
    
    func playlistButtonDidReceiveTouchUpInside() {
        menuView.isHidden = true
        
    }
    
    func refreshButtonDidReceiveTouchUpInside() {
        menuView.isHidden = true
        
    }
    
    func settingsButtonDidReceiveTouchUpInside() {
        menuView.isHidden = true
        
    }
}
