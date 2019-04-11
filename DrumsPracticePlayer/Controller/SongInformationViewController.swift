//
//  SongInformationViewController.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 03/04/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import UIKit
import AVFoundation

class SongInformationViewController: UIViewController {
    
    var songPlayer: AVAudioPlayer?
    var updateViewTimer: Timer?
    var song: Song? = nil
    
    lazy var songInformationView = SongInformationView(delegate: self,
                                                       textFieldDelegate: self,
                                                       tableViewDelegate: self,
                                                       tableViewDataSource: self)
    
    lazy var scrollView: UIKeyboardScrollView = {
        let sv = UIKeyboardScrollView()
        sv.backgroundColor = .dark_green
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    convenience init(song: Song) {
        self.init()
        self.song = song
        
        songInformationView.songTitleTextField.text = song.title ?? ""
        songInformationView.songArtistTextField.text = song.artist ?? ""
        let tempo = song.metronome?.tempo ?? 120
        let tsUpper = song.metronome?.timeSignatureUpper ?? 4
        let tsLower = song.metronome?.timeSignatureLower ?? 4
        self.song?.metronome = Metronome(tempo: tempo, timeSignatureUpper: tsUpper, timeSignatureLower: tsLower)
        songInformationView.setMetronome(tempo: tempo, timeSignatureUpper: tsUpper, timeSignatureLower: tsLower)
        
        
        guard let url = song.url else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            songPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = songPlayer else { return }
            player.delegate = self
            player.enableRate = true
            songInformationView.maxTimeLabel.text = player.duration.asMinutesAndSeconds()
        } catch _ {
            UIAlertController.showErrorDialog(title: "Error", message: "Failed to play selected song.", buttonTitle: "OK", buttonAction: {
//                self.popupPlayerView.stopPlayer()
            }, onController: self)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Song Details"
        navigationItem.setLeftBarButton(UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonDidReceiveTouchUpInside)), animated: false)
        view.backgroundColor = .dark_green
        view.addSubview(scrollView)
        
        initializePlayer()
        
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        scrollView.addSubview(songInformationView)
        songInformationView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        songInformationView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        songInformationView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        songInformationView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        songInformationView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor).isActive = true
        songInformationView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let songPlayer = songPlayer, songPlayer.isPlaying {
            songPlayer.stop()
        }
    }
    
    func initializePlayer() {
        
    }
    
    @objc func backButtonDidReceiveTouchUpInside() {
        if let songPlayer = songPlayer, songPlayer.isPlaying {
            songPlayer.stop()
        }
        navigationController?.popViewController(animated: true)
    }
}

extension SongInformationViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        songInformationView.pause()
        songPlayer?.stop()
    }
    
    func getSongProgress() -> Float {
        guard let currentTime = songPlayer?.currentTime, let duration = songPlayer?.duration else { return 0.0 }
        return Float(currentTime / duration)
    }
}

extension SongInformationViewController: SongInformationViewDelegate {
    func playPauseSongButtonDidReceiveTouchUpInside() {
        if let songPlayer = songPlayer {
            if songPlayer.isPlaying {
                songInformationView.pause()
                songPlayer.pause()
                updateViewTimer?.invalidate()
            } else {
                songInformationView.play()
                songPlayer.play()
                updateViewTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
                    let timeString = self.songPlayer?.currentTime.asMinutesAndSeconds() ?? "-"
                    self.songInformationView.updatePlayerTime(time: timeString, percentage: self.getSongProgress())
                })
            }
        }
    }
    
    func addCheckpointButtonDidReceiveTouchUpInside() {
        if let songPlayer = songPlayer {
            songPlayer.pause()
            let currentTime = songPlayer.currentTime
            
            let alert = UIAlertController(title: "New Checkpoint", message: "", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Name"
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { [weak alert] (_) in
                self.songPlayer?.play()
                alert?.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                self.song?.checkpoints?.append(Checkpoint(name: textField?.text, time: currentTime))
                self.song?.checkpoints?.sort(by: { (checkA, checkB) -> Bool in
                    return checkA.time ?? 0 < checkB.time ?? 0
                })
                self.songPlayer?.play()
                self.songInformationView.checkpointsTableView.reloadData()
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func sliderValueChangedToPercentage(_ percentage: Float) {
        if let songPlayer = songPlayer {
            let time = songPlayer.duration * Double(percentage)
            songPlayer.currentTime = time
            songInformationView.updatePlayerTime(time: time.asMinutesAndSeconds(), percentage: percentage)
        }
    }
    
    func lessLowerTimeSignatureButtonDidReceiveTouchUpInside() {
        guard var timeSignatureLower = song?.metronome?.timeSignatureLower else { return }
        if (timeSignatureLower - 1 >= 1) {
            timeSignatureLower = timeSignatureLower - 1
            song?.metronome?.timeSignatureLower = timeSignatureLower
            songInformationView.setMetronome(tempo: song?.metronome?.tempo ?? 0,
                                             timeSignatureUpper: song?.metronome?.timeSignatureUpper ?? 0,
                                             timeSignatureLower: song?.metronome?.timeSignatureLower ?? 0)
        }
    }
    
    func moreLowerTimeSignatureButtonDidReceiveTouchUpInside() {
        guard var timeSignatureLower = song?.metronome?.timeSignatureLower else { return }
        if (timeSignatureLower + 1 <= 16) {
            timeSignatureLower = timeSignatureLower + 1
            song?.metronome?.timeSignatureLower = timeSignatureLower
            songInformationView.setMetronome(tempo: song?.metronome?.tempo ?? 0,
                                             timeSignatureUpper: song?.metronome?.timeSignatureUpper ?? 0,
                                             timeSignatureLower: song?.metronome?.timeSignatureLower ?? 0)
        }
    }
    
    func lessUpperTimeSignatureButtonDidReceiveTouchUpInside() {
        guard var timeSignatureUpper = song?.metronome?.timeSignatureUpper else { return }
        if (timeSignatureUpper - 1 >= 1) {
            timeSignatureUpper = timeSignatureUpper - 1
            song?.metronome?.timeSignatureUpper = timeSignatureUpper
            songInformationView.setMetronome(tempo: song?.metronome?.tempo ?? 0,
                                             timeSignatureUpper: song?.metronome?.timeSignatureUpper ?? 0,
                                             timeSignatureLower: song?.metronome?.timeSignatureLower ?? 0)
        }
    }
    
    func moreUpperTimeSignatureButtonDidReceiveTouchUpInside() {
        guard var timeSignatureUpper = song?.metronome?.timeSignatureUpper else { return }
        if (timeSignatureUpper + 1 <= 19) {
            timeSignatureUpper = timeSignatureUpper + 1
            song?.metronome?.timeSignatureUpper = timeSignatureUpper
            songInformationView.setMetronome(tempo: song?.metronome?.tempo ?? 0,
                                             timeSignatureUpper: song?.metronome?.timeSignatureUpper ?? 0,
                                             timeSignatureLower: song?.metronome?.timeSignatureLower ?? 0)
        }
    }
    
    func saveButtonDidReceiveTouchUpInside() {
        self.song?.id = 1041
        navigationController?.popViewController(animated: true)
    }
    
    func cancelButtonDidReceiveTouchUpInside() {
        navigationController?.popViewController(animated: true)        
    }
    
    func markCheckpointButtonDidReceiveTouchUpInside() {
        
    }
    
    func editCheckpointsButtonDidReceiveTouchUpInside() {
        
    }
}

extension SongInformationViewController: CheckpointTableViewCellDelegate {
    func deleteButtonDidReceiveTouchUpInside(in cell: CheckpointTableViewCell) {
        if let indexPath = songInformationView.checkpointsTableView.indexPath(for: cell) {
            guard let checkpoints = song?.checkpoints, checkpoints.count > indexPath.row else { return }
            song?.checkpoints?.remove(at: indexPath.row)
            songInformationView.checkpointsTableView.reloadData()
        }
    }
}

extension SongInformationViewController: UITableViewDelegate {
    
}

extension SongInformationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return song?.checkpoints?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let checkpoints = song?.checkpoints, checkpoints.count > indexPath.row {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CheckpointTableViewCell") as? CheckpointTableViewCell {
                cell.delegate = self
                cell.model = checkpoints[indexPath.row]
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let checkpoints = song?.checkpoints, checkpoints.count > indexPath.row {
            let checkpoint = checkpoints[indexPath.row]
            songPlayer?.currentTime = checkpoint.time ?? 0.0
            songInformationView.updatePlayerTime(time: checkpoint.time?.asMinutesAndSeconds() ?? "-", percentage: getSongProgress())
            if let songPlayer = songPlayer, !songPlayer.isPlaying {
                songPlayer.play()
            }
        }
    }
}

extension SongInformationViewController: UITextFieldDelegate {
    
}


