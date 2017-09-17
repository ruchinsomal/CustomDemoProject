//
//  DetailsVC.swift
//  CustomDemo
//
//  Created by Ruchin Somal on 17/09/17.
//  Copyright © 2017 Ruchin Somal. All rights reserved.
//

import UIKit

class DetailsVC: BaseVC {
    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var lblSongSingerName: UILabel!
    @IBOutlet weak var imgSong: UIImageView!
    var trackDetails: RSResults!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundedView(anyView: imgSong, width: 5.0,mastkBound: true)
        let urlStr = trackDetails.artworkUrl100
        if urlStr != nil {
            let url = URL(string: urlStr!)
            setImageFromURLonImageView(url: url!, imageView: imgSong)
        }
        lblSongName.text = trackDetails.trackCensoredName
        lblSongSingerName.text = trackDetails.collectionName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
