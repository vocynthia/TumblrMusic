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
import AVFoundation
import Kingfisher

class MusicListTableViewController: UITableViewController {

    
    var username: String?
    var tag: String?
    var viewControllerPost = [filter](){
        didSet{
            DispatchQueue.main.async {
                 self.tableView.reloadData()
            }
           
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let NM = NetworkManager()
        let url = NM.getAudioPosts(username: username!, tag: tag!)
        
        
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
                    self.viewControllerPost = allAudioPosts
                    
                    for audioPosts in allAudioPosts {
                        print("Song Title: \(audioPosts.trackName)","Artist:\(audioPosts.artist)", "Album: \(audioPosts.album)", " Album Art: \(audioPosts.albumArt)", "Audio File: \(audioPosts.audioFile)")
                    }
                    
                    
                }
            case .failure(let error):
                print(error)
                
            }
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
        
        if audio.albumArt.isEmpty{
            let image = UIImage(named: "album")
            cell.imageView?.image = image
        }
        else{
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

