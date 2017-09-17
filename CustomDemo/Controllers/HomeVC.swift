//
//  HomeVC.swift
//  CustomDemo
//
//  Created by Ruchin Somal on 17/09/17.
//  Copyright © 2017 Ruchin Somal. All rights reserved.
//

import UIKit

class HomeVC: BaseVC {
    
    @IBOutlet weak var tblSongList: UITableView!
    var arySongList = [RSResults]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblSongList.tableFooterView = UIView()
        getListFromServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getListFromServer() {
        let params = "term=Michael jackson"
        MyLoader.showLoadingView()
        getRequest(kSearch_url + params) { (response, error, statusCode) in
            MyLoader.hideLoadingView()
            if error == nil {
                if statusCode == 200 {
                let responseObj = RSSongsData.init(json: response!)
                self.arySongList = responseObj.results!
                self.tblSongList.reloadData()
                } else {
                    showAlertView(title: "Error", message: "Something went wrong. We are Working on it.", ref: self)
                }
            } else {
                showAlertView(title: "Error", message: "Something went wrong. We are Working on it.", ref: self)
            }
        }
    }

}
extension HomeVC: UITableViewDelegate {
}
extension HomeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arySongList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.selectionStyle = .none
        roundedView(anyView: cell.imgSong, width: 30.0,mastkBound: true)
        let urlStr = self.arySongList[indexPath.row].artworkUrl100
        if urlStr != nil {
            let url = URL(string: urlStr!)
            setImageFromURLonImageView(url: url!, imageView: cell.imgSong)
        }
        cell.lblSongName.text = self.arySongList[indexPath.row].trackName
        cell.lblSongSingerName.text = self.arySongList[indexPath.row].artistName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewOBJ = storyBoard.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
        viewOBJ.trackDetails = self.arySongList[indexPath.row]
        self.navigationController?.pushViewController(viewOBJ, animated: true)
        self.navigationController?.isNavigationBarHidden = false
    }
}
