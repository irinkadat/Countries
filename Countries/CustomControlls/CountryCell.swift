
import UIKit

class CountryCell: UITableViewCell {
    var country: Country?
    var chevronTapHandler: (() -> Void)?
    
    let flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFPro-Regular", size: 14)
        return label
    }()
    
    let chevronImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(flagImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(chevronImageView)
        
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            flagImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            flagImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            flagImageView.widthAnchor.constraint(equalToConstant: 30),
            flagImageView.heightAnchor.constraint(equalToConstant: 30),
            
            nameLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -4),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -19),
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 18),
            chevronImageView.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        selectionStyle = .none
        contentView.layer.cornerRadius = 24
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleChevronTap))
        chevronImageView.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleChevronTap() {
        chevronTapHandler?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let cellSpacing: CGFloat = 10
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: cellSpacing / 2, left: 0, bottom: cellSpacing / 2, right: 0))
    }
    
    func setFlagImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        ImageDownloader.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.flagImageView.image = image
            }
        }
    }
    
    func configure(with country: Country) {
        nameLabel.text = country.name.common
        
        if let flagURL = country.flags["png"] {
            setFlagImage(from: flagURL)
        } else {
            print("url is missing")
        }
        
    }
}
