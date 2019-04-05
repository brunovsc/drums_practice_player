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
        
        guard let url = song.url else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            songPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = songPlayer else { return }
            player.delegate = self
            player.enableRate = true
//            player.play()
        } catch _ {
//            songPlayer?.stop()
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
        songInformationView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        songInformationView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
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
    
}

extension SongInformationViewController: SongInformationViewDelegate {
    func lessLowerTimeSignatureButtonDidReceiveTouchUpInside() {
        
    }
    
    func moreLowerTimeSignatureButtonDidReceiveTouchUpInside() {
        
    }
    
    func lessUpperTimeSignatureButtonDidReceiveTouchUpInside() {
        
    }
    
    func moreUpperTimeSignatureButtonDidReceiveTouchUpInside() {
        
    }
    
    func saveButtonDidReceiveTouchUpInside() {
        
    }
    
    func cancelButtonDidReceiveTouchUpInside() {
        
    }
    
    func markCheckpointButtonDidReceiveTouchUpInside() {
        
    }
    
    func editCheckpointsButtonDidReceiveTouchUpInside() {
        
    }
}

extension SongInformationViewController: UITableViewDelegate {
    
}

extension SongInformationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension SongInformationViewController: UITextFieldDelegate {
    
}
