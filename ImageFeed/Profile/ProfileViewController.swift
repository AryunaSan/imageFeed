
import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: Private properties
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 23)
        label.textColor = .ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .ypGrey
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .ypWhite
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var avatarImageView: UIImageView = {
        let avatarImageView = UIImage(named: "profileMockImage")
        let imageView = UIImageView(image: avatarImageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    private var logoutButton: UIButton = {
        let exitImage = UIImage(named: "logOut")
        let button = UIButton()
        button.setImage(exitImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.ypBlack
        
        nameLabel.text = "Екатерина Новикова"
        nicknameLabel.text = "@ekaterina_nov"
        statusLabel.text = "Hello, world!"
        logoutButton.addTarget(self, action: #selector(Self.didTapLogoutButton), for: .touchUpInside)

        view.addSubview(nameLabel)
        view.addSubview(nicknameLabel)
        view.addSubview(statusLabel)
        view.addSubview(avatarImageView)
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nicknameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            statusLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            logoutButton.widthAnchor.constraint(equalToConstant: 24),
            logoutButton.heightAnchor.constraint(equalToConstant: 24),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
])
    }
   
    @objc
    private func didTapLogoutButton() {}
}

