//
//  ViewController.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 13.09.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    var collectionView: UICollectionView!
    var director: CollectionDirector!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = .lightGray
        collectionView.alwaysBounceVertical = true
        
        director = CollectionDirector(colletionView: collectionView)
        collectionView.registerClass(CollectionCell.self)
        let section = CollectionSection()
        section.minimumInterItemSpacing = 2
        section.instetForSection = UIEdgeInsetsMake(0, 8, 0, 8)
        section.lineSpacing = 2
        for _ in 0..<20 {
            let row = CollectionItem<CollectionCell>(item: "text")
                .onSelect({ (ip) in
                    let safariViewController = SFSafariViewController(url: URL(string: "https://ya.ru")!)
                    self.present(safariViewController, animated: true, completion: nil)
                }).onDisplay({ (ip) in
                    print("will display")
                })
            section += row
        }
        
        director += section
    }
    
    
    @IBAction func action(_ sender: Any) {
        director.sections.first?.items.remove(at: 0)
        director.sections.first?.reload()
    }
    
    
}

