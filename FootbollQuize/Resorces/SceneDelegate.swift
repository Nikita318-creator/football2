import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        let splashVC = SplashVC()
        
        splashVC.actionOnDismiss = { [weak self] in
            guard let self = self else { return }
            
            UIView.transition(with: self.window!,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                self.window?.rootViewController = self.createTabBarController()
            }, completion: nil)
        }
        
        self.window?.rootViewController = splashVC
        self.window?.overrideUserInterfaceStyle = .light
        self.window?.makeKeyAndVisible()
    }
    
    private func createTabBarController() -> UITabBarController {
        let tabBarVC = UITabBarController()
        
        let home = UINavigationController(rootViewController: HomeVC())
        home.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(named: "tab_Home"),
            selectedImage: UIImage(named: "tab_Home_active")?.withRenderingMode(.alwaysOriginal)
        )
        home.tabBarItem.tag = 0
        
        let stats = UINavigationController(rootViewController: UIViewController())
        stats.viewControllers.first?.view.backgroundColor = .white
        stats.tabBarItem = UITabBarItem(
            title: "Quiz",
            image: UIImage(named: "tab_Quiz"),
            selectedImage: UIImage(named: "tab_Quiz_active")?.withRenderingMode(.alwaysOriginal)
        )
        stats.tabBarItem.tag = 1
        
        let settings = UINavigationController(rootViewController: UIViewController())
        settings.viewControllers.first?.view.backgroundColor = .white
        settings.tabBarItem = UITabBarItem(
            title: "Statistics",
            image: UIImage(named: "tab_Statistics"),
            selectedImage: UIImage(named: "tab_Statistics_active")?.withRenderingMode(.alwaysOriginal)
        )
        settings.tabBarItem.tag = 2
        
        tabBarVC.viewControllers = [home, stats, settings]
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .backgroundMain
        
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
        
        tabBarVC.tabBar.standardAppearance = appearance
        tabBarVC.tabBar.scrollEdgeAppearance = appearance
        
        tabBarVC.tabBar.tintColor = .activeColor
        tabBarVC.tabBar.shadowImage = UIImage()
        tabBarVC.tabBar.backgroundImage = UIImage()
        
        return tabBarVC
    }
}
