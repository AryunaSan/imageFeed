
import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: Private properties
    private var nameLabel: UILabel!
    private var nicknameLabel: UILabel!
    private var statusLabel: UILabel!
    private var userpickImage: UIImageView!
    private var logoutButton: UIButton!
    
    // MARK: Private methods
    private func logoutButtonPressed(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userpickImage = UIImage(systemName: "photo")
        let imageView = UIImageView(image: userpickImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
}
 
