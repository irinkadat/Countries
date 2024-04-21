//
//  DetailsVC.swift
//  Countries
//
//  Created by Irinka Datoshvili on 21.04.24.
//

import UIKit

class DetailsVC: UIViewController {
    
    var country: Country?
    
    // MARK: - UI Elements
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let googleMapsIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "googlemap")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let openStreetMapsIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "streetmap")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var flagDetailsLabel = UILabel()
    var timezoneLabel = UILabel();
    var spellingLabel = UILabel();
    var capitalLabel = UILabel();
    var regionLabel = UILabel();
    var neighborsLabel = UILabel();
    var populationLabel = UILabel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = country?.name.common
        setupScrollView()
        setupViews()
        displayCountryDetails()
        displayBasicInfo()
        
        let googleMapsTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openGoogleMaps))
        googleMapsIcon.addGestureRecognizer(googleMapsTapGestureRecognizer)
        googleMapsIcon.isUserInteractionEnabled = true
        
        let openStreetMapsTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openOpenStreetMaps))
        openStreetMapsIcon.addGestureRecognizer(openStreetMapsTapGestureRecognizer)
        openStreetMapsIcon.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    
    @objc private func openGoogleMaps() {
        if let googleMapsURLString = country?.maps.googleMaps, let googleMapsURL = URL(string: googleMapsURLString) {
            openURL(googleMapsURL)
        }
    }
    
    @objc private func openOpenStreetMaps() {
        if let openStreetMapsURLString = country?.maps.openStreetMaps, let openStreetMapsURL = URL(string: openStreetMapsURLString) {
            openURL(openStreetMapsURL)
        }
    }
    
    // MARK: - Helper Methods
    
    private func openURL(_ url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // MARK: - Setup
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupViews() {
        flagDetailsLabel.numberOfLines = 0
        contentView.addSubview(flagImageView)
        
        let aboutFlagStackView = UIStackView()
        aboutFlagStackView.axis = .vertical
        aboutFlagStackView.spacing = 8
        aboutFlagStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let aboutFlagTitleLabel = UILabel()
        aboutFlagTitleLabel.text = "About the Flag"
        aboutFlagTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        aboutFlagStackView.addArrangedSubview(aboutFlagTitleLabel)
        aboutFlagStackView.addArrangedSubview(flagDetailsLabel)
        
        contentView.addSubview(aboutFlagStackView)
        
        let basicInfoStackView = UIStackView()
        basicInfoStackView.axis = .vertical
        basicInfoStackView.spacing = 20
        basicInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let basicInfoTitleLabel = UILabel()
        basicInfoTitleLabel.text = "Basic Information"
        basicInfoTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        basicInfoStackView.addArrangedSubview(basicInfoTitleLabel)
        basicInfoStackView.addArrangedSubview(createInfoLabel(title: "Time Zone", value: timezoneLabel))
        basicInfoStackView.addArrangedSubview(createInfoLabel(title: "Spelling", value: spellingLabel))
        basicInfoStackView.addArrangedSubview(createInfoLabel(title: "Capital", value: capitalLabel))
        basicInfoStackView.addArrangedSubview(createInfoLabel(title: "Region", value: regionLabel))
        basicInfoStackView.addArrangedSubview(createInfoLabel(title: "Neighbors", value: neighborsLabel))
        basicInfoStackView.addArrangedSubview(createInfoLabel(title: "Population", value: populationLabel))
        
        contentView.addSubview(basicInfoStackView)
        
        let usefulLinksStackView = UIStackView()
        usefulLinksStackView.axis = .horizontal
        usefulLinksStackView.spacing = 40
        usefulLinksStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let usefulLinksTitleLabel = UILabel()
        usefulLinksTitleLabel.text = "Useful Links"
        usefulLinksTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        usefulLinksTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(usefulLinksTitleLabel)
        
        usefulLinksStackView.addArrangedSubview(googleMapsIcon)
        usefulLinksStackView.addArrangedSubview(openStreetMapsIcon)
        
        contentView.addSubview(usefulLinksStackView)
        
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        flagImageView.layer.cornerRadius = 87
        flagImageView.layer.shadowColor = UIColor.black.cgColor
        flagImageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        flagImageView.layer.shadowOpacity = 0.5
        flagImageView.layer.shadowRadius = 4
        flagImageView.layer.masksToBounds = false
        flagImageView.layer.cornerRadius = 30
        flagImageView.layer.masksToBounds = true
        
        let lineSeparator = UIView()
        lineSeparator.translatesAutoresizingMaskIntoConstraints = false
        lineSeparator.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
        contentView.addSubview(lineSeparator)
        
        let lineSeparator2 = UIView()
        lineSeparator2.translatesAutoresizingMaskIntoConstraints = false
        lineSeparator2.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
        contentView.addSubview(lineSeparator2)
        
        
        NSLayoutConstraint.activate([
            
            flagImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            flagImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            flagImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            flagImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            aboutFlagStackView.topAnchor.constraint(equalTo: flagImageView.bottomAnchor, constant: 20),
            aboutFlagStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            aboutFlagStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            lineSeparator.heightAnchor.constraint(equalToConstant: 1),
            lineSeparator.topAnchor.constraint(equalTo: aboutFlagStackView.bottomAnchor, constant: 24),
            lineSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            lineSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            basicInfoStackView.topAnchor.constraint(equalTo: lineSeparator.bottomAnchor, constant: 24),
            basicInfoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            basicInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            lineSeparator2.heightAnchor.constraint(equalToConstant: 1),
            lineSeparator2.topAnchor.constraint(equalTo: basicInfoStackView.bottomAnchor, constant: 24),
            lineSeparator2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            lineSeparator2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            usefulLinksTitleLabel.topAnchor.constraint(equalTo: lineSeparator2.bottomAnchor, constant: 20),
            usefulLinksTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            usefulLinksTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            usefulLinksStackView.topAnchor.constraint(equalTo: usefulLinksTitleLabel.bottomAnchor, constant: 15),
            usefulLinksStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            usefulLinksStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            
        ])
    }
    
    private func createInfoLabel(title: String, value: UILabel) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 80
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        value.numberOfLines = 0
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(value)
        
        return stackView
    }
    
    // MARK: - Display Data
    
    private func displayCountryDetails() {
        guard let country = country else {
            return
        }
        
        if let flagURL = country.flags["png"], let flagURL = URL(string: flagURL) {
            ImageDownloader.shared.downloadImage(from: flagURL) { [weak self] image in
                DispatchQueue.main.async {
                    self?.flagImageView.image = image
                }
            }
        } else {
            print("Flag image URL is missing")
        }
        
    }
    
    private func displayBasicInfo() {
        guard let country = country else {
            return
        }
        
        if let flagDetails = country.flags["alt"] {
            flagDetailsLabel.text = flagDetails
        } else {
            flagDetailsLabel.text = "No description for this specific flag!"
        }
        
        let timezone = country.timezones.first
        timezoneLabel.text = timezone
        
        let spelling = country.altSpellings.last
        spellingLabel.text = spelling
        
        if let capital = country.capital {
            capitalLabel.text = capital.joined(separator: ", ")
        } else {
            capitalLabel.text = "Capital not available"
        }
        
        if let borders = country.borders {
            neighborsLabel.text = borders.joined(separator: ", ")
        } else {
            neighborsLabel.text = "Borders not available"
        }
        
        let population = String(country.population)
        populationLabel.text = population
        
        let region = country.region
        regionLabel.text = region
    }
}

