
import UIKit

final class ImagesListCell: UITableViewCell {
    // MARK: - Static properties
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - @IBOutlet properties
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
}
