//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let service = RecipesServiceMock() //RecipesService(network: NetworkHelper()) //RecipesServiceMock()
        let vm = RecipesViewModel(recipesService: service)
        let vc = RecipesListViewController(viewModel: vm)
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
    }
}

