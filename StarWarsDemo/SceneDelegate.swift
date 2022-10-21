//
//  SceneDelegate.swift
//  StarWarsDemo
//
//  Created by Nicholas Welch on 10/19/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		// create the window and attach the rootViewController
		
		guard let windowScene = (scene as? UIWindowScene) else { return }
		
		let window = UIWindow(windowScene: windowScene)
		
		// for a Star Wars aesthetic
		window.overrideUserInterfaceStyle = .dark
		
		let nav = UINavigationController()
		
		nav.navigationBar.setBackgroundImage(UIImage(named: "SpacePattern"), for: .default)
		
		// set custom Star Wars font for nav bar titles
		if let starJediFont = UIFont(name: "StarJedi", size: 20) {
			nav.navigationBar.titleTextAttributes = [
				NSAttributedString.Key.font: starJediFont
			]
		}
		nav.viewControllers = [FilmListViewController()]
		
		window.rootViewController = nav
		
		self.window = window
		
		window.makeKeyAndVisible()
	}
}

