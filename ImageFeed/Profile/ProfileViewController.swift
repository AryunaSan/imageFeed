
import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: Private properties
    private var nameLabel: UILabel?
    private var nicknameLabel: UILabel?
    private var statusLabel: UILabel?
    private var userpickImage: UIImageView?
    private var logoutButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var userpickImage = UIImage(systemName: "photo")
        var imageView = UIImageView(image: userpickImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        var nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont(name: "SF Pro-Bold", size: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        self.nameLabel = nameLabel
        
        var nicknameLabel = UILabel()
        nicknameLabel.text = "@ekaterina_nov"
        nicknameLabel.font = UIFont(name: "SF Pro", size: 13)
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nicknameLabel)
        nicknameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        self.nicknameLabel = nicknameLabel
        
        var statusLabel = UILabel()
        statusLabel.text = "Hello, world!"
        statusLabel.font = UIFont(name: "SF Pro", size: 13)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        statusLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        statusLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8).isActive = true
        self.statusLabel = statusLabel
        
        let button = UIButton.systemButton(
            with: UIImage(systemName: "logOut")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 24).isActive = true
        button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    @objc
    private func didTapButton() {}
}

