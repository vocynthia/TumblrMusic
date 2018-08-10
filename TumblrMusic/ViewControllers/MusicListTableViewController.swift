//
//  MusicTableViewController.swift
//  TumblrMusic
//
//  Created by Macbook on 7/25/18.
//  Copyright © 2018 makeschool. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVKit
import MediaPlayer
import AVFoundation
import Kingfisher

enum State {
    case loading
    case loaded
}

class MusicListTableViewController: UITableViewController {
//    @IBOutlet weak var AutoplaySwitch: UISwitch!

    @IBOutlet weak var playPauseButton: UIBarButtonItem!
    var trackIndex: Int = 0
    var offset = 0
    var state = State.loaded
    
    var isPlaying = false
    var audioPlayer: AVPlayer! {
        didSet{
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.audioPlayer.currentItem, queue: .main) { (_) in
                self.trackIndex += 1
                self.tableView.selectRow(at: IndexPath.init(row: Int(self.trackIndex), section: 0 ), animated: true , scrollPosition: UITableViewScrollPosition.none)
                self.playSoundWith(c: self.trackIndex)
            }
        }
    }
    var username: String?
    var tag: String?
    
    var pausedTime: CMTime?
    
    var viewControllerPost = [filter](){
        didSet{
            DispatchQueue.main.async {
                 self.tableView.reloadData()
            }
        }
    }
    
    func playSoundWith(c: Int  ) -> Void {
        if viewControllerPost.isEmpty {
            print("no audio found")
        } else {
            let audioURL = URL(string: viewControllerPost[c].audioFile)
            let playerItem = AVPlayerItem.init(url: audioURL!)
            audioPlayer = AVPlayer.init(playerItem: playerItem)
            audioPlayer.automaticallyWaitsToMinimizeStalling = false
            audioPlayer.playImmediately(atRate: 1.0)
            audioPlayer.play()
            
        // audioPlayer
        }
    }
    
  
    func setNowPlayingInfo() {
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
        let title = filter.init(json:["track_name"])
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
//    @IBAction func autoPlaySwitch(_ sender: UISwitch) {
////        self.autoPlayOnOff(isON: sender.isOn)
//
//    }
    
    @IBAction func PlayPauseButton(_ sender: AnyObject) {
//     print("time is: \(audioPlayer.currentTime().seconds)")
        let playBtn = sender as! UIBarButtonItem
        if viewControllerPost.isEmpty {
            print("can't play ")
 
        } else if isPlaying == false {
            
            if audioPlayer == nil {
                tableView.selectRow(at: IndexPath.init(row: Int(trackIndex), section: 0 ), animated: true , scrollPosition: UITableViewScrollPosition.none )
                playSoundWith(c: 0)
            }
            
            // playback back to same time when audio was paused
            audioPlayer.automaticallyWaitsToMinimizeStalling = false
            audioPlayer.playImmediately(atRate: 1.0)
            isPlaying = true
            playBtn.image = UIImage(named:"pause.png")
            
            if pausedTime != nil {
               audioPlayer.seek(to: pausedTime!)
            }
            
            audioPlayer.play()
            
        } else {
            
            pausedTime = audioPlayer.currentItem?.currentTime()
            audioPlayer.pause()
            isPlaying = false
            
            playBtn.image = UIImage(named:"play.png")
        }
    }

    
    @IBAction func RewindButton(_ sender: Any) {
        if trackIndex > 0 {
        trackIndex -= 1
        tableView.selectRow(at: IndexPath.init(row: Int(trackIndex), section: 0 ), animated: true , scrollPosition: UITableViewScrollPosition.none )
        playSoundWith(c: Int(trackIndex))
        }
        // SHOW SLECTED CELL
    }
    
    @IBAction func ForwardButton(_ sender: Any) {
        if trackIndex + 1 < viewControllerPost.count {
        trackIndex += 1
        tableView.selectRow(at: IndexPath.init(row: Int(trackIndex), section: 0 ), animated: true , scrollPosition: UITableViewScrollPosition.none)
        playSoundWith(c: Int(trackIndex))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // autoPlayOnOff(isON: false)
        setNowPlayingInfo()
        self.trackIndex = 0
        self.navigationItem.title = username?.capitalized
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
        
        func playSoundWith() -> Void {

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doNetworkRequest()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        trackIndex = indexPath.row
        playSoundWith(c: Int(trackIndex))
        print("Should play")
        if isPlaying == false {
            // playback back to same time when audio was paused
            
            isPlaying = true
            playPauseButton.image = UIImage(named:"pause.png")
    }
        
//      func  autoPlayOnOff(isON: Bool){
      
        
       
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doNetworkRequest() {
        state = .loading
        let NM = NetworkManager()
        let username = self.username?.replacingOccurrences(of: " ", with: "_")
        let tag = self.tag?.replacingOccurrences(of: " ", with: "_")
        let url = NM.getAudioPosts(username: username!, tag: tag!, offset: offset)
        
        Alamofire.request(URL(string: url)!).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value as? [String: Any] {
                    
                    let response = value["response"] as? [String: Any]
                    let posts = JSON(response!["posts"]!).arrayValue
                    
                    var allAudioPosts: [filter] = []
                    for audioPosts in posts {
                        let audioObject = filter(json: audioPosts)
                        allAudioPosts.append(audioObject)
                        
                    }
                    self.viewControllerPost.append(contentsOf: allAudioPosts)
                }
            case .failure(let error):
                print(error)
            }
            self.offset += 20
            self.tableView.reloadData()
            self.state = .loaded
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == viewControllerPost.count  && state != .loading {
            doNetworkRequest()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewControllerPost.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let audio = self.viewControllerPost[indexPath.row]
        
        cell.textLabel?.text = audio.trackName
        cell.detailTextLabel?.text = audio.artist
        
        if cell.isSelected {
            cell.setHighlighted(true, animated: true)
        }
        
        if audio.albumArt.isEmpty {
            let image = UIImage(named: "album")
            cell.imageView?.image = image
        } else {
              let imageURL = URL(string: audio.albumArt)!
            cell.imageView?.kf.setImage(with: imageURL)
        
//        DispatchQueue.global().async {
//            let imageURL = URL(string: audio.albumArt)!
//            let imagedata = try! Data(contentsOf: imageURL)
//            let image = UIImage(data: imagedata)
//
//            DispatchQueue.main.async {
//                 cell.imageView?.image = image
//            }
//        }
    }
        return cell
    }

}

