
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
        
        setUserpickImage()
        setNameLabel()
        setNicknameLabel()
        setStatusLabel()
        setLogOutButton()
    }
    // MARK: Private methods
    
    private func setUserpickImage() {
        let userpickImage = UIImage(named: "photo")
        let imageView = UIImageView(image: userpickImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        self.userpickImage = imageView
    }
    
    private func setNameLabel() {
        guard let profileImage = self.userpickImage else { return }

        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = .boldSystemFont(ofSize: 23)
        nameLabel.textColor = .ypWhite
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        nameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8).isActive = true
        self.nameLabel = nameLabel
    }
    
    private func setNicknameLabel() {
        guard let profileImage = self.userpickImage,
        let nameLabel = self.nameLabel else { return }

        let nicknameLabel = UILabel()
        nicknameLabel.text = "@ekaterina_nov"
        nicknameLabel.font = .systemFont(ofSize: 13)
        nicknameLabel.textColor = .ypWhite
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nicknameLabel)
        
        nicknameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor).isActive = true
        nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        self.nicknameLabel = nicknameLabel
        
    }
    private func setStatusLabel() {
        guard let profileImage = self.userpickImage,
        let nickNameLabel = self.nicknameLabel else { return }
        
        let statusLabel = UILabel()
        statusLabel.text = "Hello, world!"
        statusLabel.font = .systemFont(ofSize: 13)
        statusLabel.textColor = .ypWhite
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        statusLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor).isActive = true
        statusLabel.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 8).isActive = true
        self.statusLabel = statusLabel
    }
    
    private func setLogOutButton() {
        guard let exitImage = UIImage(named: "logOut"),
              let profileView = self.userpickImage else { return }
        
        let logoutButton = UIButton.systemButton(
            with: exitImage,
            target: self,
            action: #selector(Self.didTapButton)
        )
        logoutButton.tintColor = .red
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        logoutButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: profileView.centerYAnchor).isActive = true
        
        self.logoutButton = logoutButton
    }
    @objc
    private func didTapButton() {}
}

