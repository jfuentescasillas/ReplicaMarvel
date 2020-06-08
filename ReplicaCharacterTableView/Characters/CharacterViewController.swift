//
//  ViewController.swift
//  ReplicaCharacterTableView
//
//  Created by Jorge Fuentes Casillas on 03/06/20.
//  Copyright © 2020 Jorge Fuentes Casillas. All rights reserved.
//

import UIKit
import Toast_Swift

// Protocol: CharacterDisplayLogic
protocol CharactersDisplayLogic: class {
    func displayCharacters(viewModel: Characters.ViewModel)
    func displayImage(viewModel: Characters.ViewModel)
    func notify(error message: String)
}


class CharacterViewController: UITableViewController {
	// MARK: Constants and variables
	var interactor: CharactersBusinessLogic?

	// MARK: Elements in Storyboard
	@IBOutlet var loadingIndicator: UIActivityIndicatorView!
	
	
	// MARK: - View lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()

		setup()
        getCacheCharacters()
        tableView.makeToast("Scroll down for more", point: tableView.center, title: nil, image: nil, completion: nil)
	}
	
	
	private func setup() {
		title = "Marvel Comics Characters"
		
        let viewController = self
        let interactor = CharactersInteractor()
        let presenter = CharactersPresenter()
        
		viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.characterViewController = viewController
    }
}


// MARK: - extension: CharacterViewController: UITableViewDataSource, UITableViewDelegate
extension CharacterViewController: CharactersDisplayLogic  {
	override func numberOfSections(in tableView: UITableView) -> Int {
        return Model().getAllCharacters()?.count ?? 1
    }
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1 // Cambiar a 1 en lugar de 3
	}
	
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 20
    }

	
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let emptyView = UIView()
        emptyView.backgroundColor = .clear
        
		return emptyView
    }
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as? CustomTableViewCell,
              let character = Model().getAllCharacters()?[indexPath.section] else {
            return UITableViewCell()
        }

        cell.textLabel?.text = character.name
        cell.detailTextLabel?.text = character.desc
        cell.accessibilityIdentifier = String(character.id)
        cell.detailTextLabel?.numberOfLines = 0 // 4
        cell.imageView?.image = UIImage(data: character.imageData ?? Data())

        return cell
	}
	
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
	
	
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let height = scrollView.frame.size.height
		let contentYoffset = scrollView.contentOffset.y
		let distanceFromBottom = scrollView.contentSize.height - contentYoffset
		
		if distanceFromBottom < height && !self.loadingIndicator.isAnimating && tableView.numberOfSections != 0 {
			getCharacters()
		}
	}
	
	
	// MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? CharacterDetailViewController, let id = sender as? Int {
            destinationVC.characterId = id
        }
    }

	
//	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let selectedRow = tableView.cellForRow(at: indexPath) else {
//            return
//        }
//        let characterId = Int(selectedRow.accessibilityIdentifier!)
//
//        performSegue(withIdentifier: Constant.Segue.CharacterDetail.rawValue, sender: characterId)
//    }
	
	
	// MARK: - We start to get the characters from the API
	func getCacheCharacters() {
        interactor?.getCacheCharacters()
    }
	
	
	func getCharacters() {
        loadingIndicator.startAnimating()
        interactor?.getCharacters()
    }
	
	
	// MARK: - Protocol methods
	func displayCharacters(viewModel: Characters.ViewModel) {
		let numberOfCharacters = Model().getAllCharacters()?.count ?? 0
		let numberOfSections = tableView.numberOfSections
		
		loadingIndicator.stopAnimating()
		
		tableView.beginUpdates()
		tableView.insertSections(IndexSet(integersIn: numberOfSections..<numberOfCharacters), with: .none)
		tableView.endUpdates()
	}
		
	func displayImage(viewModel: Characters.ViewModel) {
        let model = Model()
        if let id = viewModel.characterId,
            let characters = model.getAllCharacters(),
            let sectionToRelooad = characters.firstIndex(where: { $0.id == id })
        {
            tableView.reloadRows(at: [IndexPath(row: 0, section: sectionToRelooad)], with: .none)
        }
    }
	
	func notify(error message: String) {
        loadingIndicator.stopAnimating()
        tableView.tableFooterView?.makeToast(message)
    }
}
