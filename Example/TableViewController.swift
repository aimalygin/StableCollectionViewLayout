//
//  TableViewController.swift
//  Example
//
//  Created by Anton Malygin on 14.09.2021.
//

import UIKit

class TableViewController: UITableViewController {
    private var scrollDirection: UICollectionView.ScrollDirection = .vertical
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func changeScrollDirection(_ sender: UIBarButtonItem) {
        if scrollDirection == .vertical {
            scrollDirection = .horizontal
        } else {
            scrollDirection = .vertical
        }
        
        sender.title = scrollDirection.title
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        let controller = segue.destination as? ViewController
        controller?.scrollDirection = scrollDirection
        if let rows = Int(identifier) {
            controller?.rowsPerSection = rows
        }
    }

}

extension UICollectionView.ScrollDirection {
    var title: String {
        switch self {
        case .vertical:
            return "Vertical"
        case .horizontal:
            return "Horizontal"
        @unknown default:
            fatalError()
        }
    }
}
