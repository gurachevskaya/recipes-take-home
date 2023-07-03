import UIKit
import Combine

extension RecipesListViewController {
    enum ViewConstants {
        static let collectionHeight: CGFloat = 250
    }
}

class RecipesListViewController: UIViewController {
    private var viewModel: RecipesViewModel
    
    init(viewModel: RecipesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: RecipeCollectionViewCell.reuseID)
        
        return collectionView
    }()
    
    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        return loader
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        setupBindings()
        viewModel.loadRecipes()
    }
    
    private func config() {
        view.addSubview(collectionView)
        view.addSubview(loader)
        
        collectionView.clipToEdges(to: view)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.$recipes
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .sink { [weak self] isLoading in
                isLoading ? self?.loader.startAnimating() : self?.loader.stopAnimating()
            }
            .store(in: &cancellables)
    }
}

extension RecipesListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.reuseID, for: indexPath) as? RecipeCollectionViewCell else {
            return UICollectionViewCell()
        }
        let model = viewModel.recipes[indexPath.item]
        cell.setUp(with: model)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let contentSize = scrollView.contentSize.height
        let viewHeight = scrollView.frame.height
        
        if offset > (contentSize - viewHeight) {
            viewModel.loadRecipes()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = ViewConstants.collectionHeight
        let width = view.frame.width
        return CGSize(width: width, height: height)
    }
}
