//
//  DetailVC.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 7/20/19.
//  Copyright © 2019 Warren. All rights reserved.
// 

import UIKit
import AVKit

class DetailVC: UIViewController {
    
    @IBOutlet var tweetView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetStackView: UIStackView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var mediaCollectionView: UICollectionView!
    @IBOutlet weak var mediaContainerView: UIView!
    
    var photos = [UIImage]() {
        didSet {
            mediaCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "tableViewBG"))
        tweetView.layer.cornerRadius = 6
        tweetView.layer.borderColor = UIColor.black.cgColor
        tweetView.layer.borderWidth = 1
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
    }
    
    func updateView(with tweet: Tweet, profilePic: UIImage) {
        loadViewIfNeeded()
        if tweet.type != .quote {
            nameLabel.text = tweet.name
            handleLabel.text = "@" + tweet.handle
            dateLabel.text = tweet.date.asLocalizedDate
            tweetTextLabel.attributedText = tweet.text.tweetFormatted
            profileImageView.image = profilePic
        } else if let name = tweet.quote?.name,
            let handle = tweet.quote?.handle,
            let date = tweet.quote?.date?.asLocalizedDate,
            let text = tweet.quote?.text?.tweetFormatted {
            nameLabel.text = name
            handleLabel.text = "@" + handle
            dateLabel.text = date
            tweetTextLabel.attributedText = text
            profileImageView.image = profilePic
        }
        retweetStackView.isHidden = tweet.type != .retweet
        retweetLabel.text = "Retweeted".localize
        handleMedia(for: tweet)
    }
    
    func handleMedia(for tweet: Tweet) {
        if tweet.mediaType == "photo" {
            var fetchedPhotos = [UIImage]()
            for string in tweet.mediaURLs {
                
                TweetController.fetchImageAt(url: string) { (result) in
                    switch result {
                    case .success(let image):
                        fetchedPhotos.append(image)
                    case .failure(let error):
                        print(error)
                        print(error.localizedDescription)
                    }
                    DispatchQueue.main.async {
                        self.photos = fetchedPhotos
                        self.mediaCollectionView.isHidden = false
                    }
                }
            }
//        } else if tweet.mediaType == "video" {
//            let player = AVPlayer(url: URL(string: tweet.mediaURLs.first!)!)
//            let controller = AVPlayerViewController()
//            controller.player = player
//            present(controller, animated: true)
        }
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: false)
    }
    
    @IBAction func goToTwitterButtonTapped(_ sender: Any) {
    }
}

extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath) as? MediaCell
        cell?.mediaImageView.image = photos[indexPath.row]
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / CGFloat(photos.count), height: collectionView.bounds.height / CGFloat(photos.count))
    }
}
