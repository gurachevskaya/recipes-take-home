import UIKit
import Combine

extension RecipeCollectionViewCell {
    enum ViewConstants {
        static let contentInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}

class RecipeCollectionViewCell: UICollectionViewCell {
    static let reuseID = "RecipeCollectionViewCell"
    
    private var cancellable: AnyCancellable?
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(with model: RecipeModel) {
        nameLabel.text = model.name
        cancellable = ImageLoadingService.shared.downloadImage(from: model.imageURL ?? "")
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] image in
                self?.imageView.image = image
            })
    }
    
    // MARK: Private
    
    private func config() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        
        let imageViewConstraints = [
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewConstants.contentInsets.left),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ViewConstants.contentInsets.right),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ViewConstants.contentInsets.top)
        ]
        
        let nameLabelConstraints = [
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewConstants.contentInsets.left),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ViewConstants.contentInsets.right),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: ViewConstants.contentInsets.top),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ViewConstants.contentInsets.bottom)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints + nameLabelConstraints)
    }
}
