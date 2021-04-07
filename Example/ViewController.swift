//
//  ViewController.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 17.02.2021.
//

import UIKit
import InfiniteCollectionViewFlowLayout

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private lazy var layout: InfiniteCollectionViewFlowLayout = {
        let layout = InfiniteCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        return layout
    }()
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: layout
    )
    
    var items: [(String, CGFloat)] = (0..<100).map({ i in ("\(i)", randomBool() ? 70 : 150) })
    
    let batchCount = 30

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        view.backgroundColor = .white
    }
    
    private func setupCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
                
        view.addSubview(collectionView)
        
        if #available(iOS 13.0, *) {
            collectionView.backgroundColor = .systemBackground
        } else {
            collectionView.backgroundColor = .white
        }

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        let top = collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let bottom = collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let leading = collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        let trailing = collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        NSLayoutConstraint.activate([top, bottom, trailing, leading])
        
        collectionView.registerCell(of: DemoCollectionViewCell.self)
    }
    
    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let item = items[indexPath.row]

        let cell = collectionView.dequeueReusableCell(DemoCollectionViewCell.self, for: indexPath)
        cell.textLabel.text = item.0
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        let item = items[indexPath.row]
        if flowLayout.scrollDirection == .vertical {
            return CGSize(width: collectionView.frame.width/3 - 10, height: item.1)
        } else {
            return CGSize(width: item.1, height: collectionView.frame.height/3 - 10)
        }
    }
    
    private static func randomBool() -> Bool {
        return arc4random_uniform(2) == 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let inset = CGFloat(100)
        
        if layout.scrollDirection == .vertical {
            if scrollView.contentOffset.y < inset {
                self.moveUp()
            } else if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height - inset {
                self.moveDown()
            }
        } else {
            if scrollView.contentOffset.x < inset {
                self.moveUp()
            } else if scrollView.contentOffset.x + scrollView.frame.width > scrollView.contentSize.width - inset {
                self.moveDown()
            }
        }
    }

    private func moveUp() {
        let tail = items.suffix(batchCount)

        let indexPaths = (0..<batchCount).map({ IndexPath(row: $0, section: 0) })
        let deleteIndexPaths = (items.count - batchCount..<items.count).map({ IndexPath(row: $0, section: 0) })

        items.removeLast(batchCount)
        items.insert(contentsOf: tail, at: 0)
        UIView.performWithoutAnimation {
            self.collectionView.performBatchUpdates({
                self.collectionView.deleteItems(at: deleteIndexPaths)
                self.collectionView.insertItems(at: indexPaths)
            }, completion: nil)
        }
    }
    
    private func moveDown() {
        let head = items.prefix(batchCount)

        let indexPaths = (items.count - batchCount..<items.count).map({ IndexPath(row: $0, section: 0) })
        let deleteIndexPaths = (0..<batchCount).map({ IndexPath(row: $0, section: 0) })
        items.removeFirst(batchCount)
        UIView.performWithoutAnimation {
            self.collectionView.deleteItems(at: deleteIndexPaths)
        }

        items.append(contentsOf: head)
        UIView.performWithoutAnimation {
            self.collectionView.insertItems(at: indexPaths)
        }
    }
}

extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(of type: T.Type) {
        register(type, forCellWithReuseIdentifier: NSStringFromClass(type))
    }

    func dequeueReusableCell<T: UICollectionViewCell>(
        _ type: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: NSStringFromClass(type), for: indexPath) as? T else {
            fatalError("No cell for given type registered, did you do it via: `registerCell`")
        }
        return cell
    }
}

