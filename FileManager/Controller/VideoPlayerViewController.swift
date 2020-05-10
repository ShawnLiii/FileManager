//
//  VideoPlayerViewController.swift
//  FileManager
//
//  Created by Shawn Li on 5/9/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayerViewController: UIViewController, UITextFieldDelegate
{
    
    var fileManager = FileManager.default

    @IBOutlet weak var videoName: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    //MARK: - Text Field Setting
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        videoName.resignFirstResponder()
        return true
    }
    
    // MARK: - AVPlayer Setting
    
    @IBAction func videoPlayerBtn(_ sender: UIButton)
    {
        videoSetup()
    }
    
    func videoSetup()
    {
        if let name = videoName.text, let pathUrl = Bundle.main.path(forResource: name, ofType: "mp4"),!name.isEmpty, fileManager.fileExists(atPath: pathUrl)
        {
            let video = AVPlayer(url: URL(fileURLWithPath: pathUrl))
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video
            present(videoPlayer, animated: true, completion:  {video.play()})
        }
        else
        {
            alert()
        }
    }

    //MARK: - Alert
    func alert ()
    {
        let alertCtl = UIAlertController(title: "Warning!", message: "File Not Exit or File Name is Empty.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Ok", style: .default)
        alertCtl.addAction(confirmAction)
        self.present(alertCtl, animated: true, completion: nil)
    }
}
