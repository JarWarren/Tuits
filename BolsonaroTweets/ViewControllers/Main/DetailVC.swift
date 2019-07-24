//
//  DetailVC.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 7/20/19.
//  Copyright © 2019 Warren. All rights reserved.
//  swiftlint:disable line_length

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
    
    var tweetID: String?
    
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
        self.tweetID = String(tweet.id)
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
        if tweet.mediaType == "photo" || tweet.mediaType == "animated_gif" {
            var fetchedPhotos = [UIImage]()
            let finalPhotoIndex = tweet.type != .quote ? tweet.mediaURLs.count - 1 : tweet.quote!.mediaURLs.count - 1
            guard let urls = tweet.type != .quote ? tweet.mediaURLs : tweet.quote?.mediaURLs else { return }
            for string in urls {
                let tweetIndex = tweet.mediaURLs.firstIndex(of: string)
                TweetController.fetchImageAt(url: string) { (result) in
                    switch result {
                    case .success(let image):
                        fetchedPhotos.append(image)
                    case .failure(let error):
                        print(error)
                        print(error.localizedDescription)
                    }
                    if tweetIndex == finalPhotoIndex {
                        DispatchQueue.main.async {
                            self.photos = fetchedPhotos
                            self.mediaCollectionView.isHidden = false
                        }
                    }
                }
            }
        } else if tweet.mediaType == "video" {
            guard let urlString = tweet.type != .quote ? tweet.mediaURLs.first : tweet.quote?.mediaURLs.first,
                let url = URL(string: urlString) else { return }
            let player = AVPlayer(url: url)
            let controller = AVPlayerViewController()
            controller.player = player
            addChild(controller)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            controller.view.layer.cornerRadius = 6
            view.addSubview(controller.view)
            NSLayoutConstraint.activate([
                controller.view.topAnchor.constraint(equalTo: tweetView.bottomAnchor, constant: 12),
                controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
                controller.view.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24),
                controller.view.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        }
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: false)
    }
    
    @IBAction func goToTwitterButtonTapped(_ sender: Any) {
        
        guard let tweetID = tweetID else { return }
        // TOOD: Test appURL on live device.
        let appURL = NSURL(string: "twitter://jairbolsonaro/status?id=\(tweetID)")!
        let webURL = NSURL(string: "https://twitter.com/jairbolsonaro/status/\(tweetID)")!
        
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
            print(appURL)
        } else {
            application.open(webURL as URL)
            print(webURL)
        }
    }
}

extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photos.count == 1 { collectionView.backgroundColor = .clear }
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath) as? MediaCell
        cell?.mediaImageView.image = photos[indexPath.row]
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var divisor: CGFloat = 1
        if photos.count == 3 || photos.count == 4 {
            divisor = 2
        }
        return CGSize(width: (collectionView.bounds.width / divisor) - 5, height: (collectionView.bounds.height / divisor) - 5)
    }
}
