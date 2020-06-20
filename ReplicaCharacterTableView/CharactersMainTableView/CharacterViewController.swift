//
//  ViewController.swift
//  ReplicaCharacterTableView
//
//  Created by JFC on 03/06/20.
//  Copyright © 2020 JFC. All rights reserved.
//

import UIKit
import Toast_Swift

// Protocol: CharacterDisplayLogic
protocol CharactersDisplayLogic: class {
    func displayCharacters(viewModel: Characters.ViewModel)
    func displayImage(viewModel: Characters.ViewModel)
    func notify(error message: String)
}


class CharacterViewController: UITableViewController, UISearchBarDelegate {
	// MARK: Constants and variables
	var interactor: CharactersBusinessLogic?
	var searchPerformed: Bool = false

	// MARK: Elements in Storyboard
	@IBOutlet var loadingIndicator: UIActivityIndicatorView!
	@IBOutlet var searchCharacterSearchBar: UISearchBar!
	
	
	// MARK: - View lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()

		setup()
        getCacheCharacters()
		tableView.makeToast(Constant().kScrollDown, point: tableView.center, title: nil, image: nil, completion: nil)
	}
	
	
	private func setup() {
		hideKeyboardWhenTappedAround()
		placeKeyboardUnderTableView()
		
		title = Constant().kMainTableViewTitle
		
		searchCharacterSearchBar.delegate = self
		
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

		print("character.comics:", character.comics)
		
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
	
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedRow = tableView.cellForRow(at: indexPath) else { return }
        let characterId = Int(selectedRow.accessibilityIdentifier!)
		guard let characterDetailViewController = storyboard?.instantiateViewController(identifier: "CharacterDetails") as? CharacterDetailViewController else { return }
		navigationController?.pushViewController(characterDetailViewController, animated: true)
		navigationController?.navigationBar.prefersLargeTitles = false
		
		guard let character = Model().getCharacterBy(id: characterId!) else { return }

		characterDetailViewController.title = character.name
		characterDetailViewController.characterImageViewData = character.imageData
		characterDetailViewController.characterDetailDescription = character.desc
		characterDetailViewController.characterId = characterId!
    }
	
	
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
		tableView.reloadData()
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
	
	
	//MARK:- Method to hide the keyboard (when typing for a Marvel character's name) when tapped outside of it.
	func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
	
	
	// MARK: Methods to scroll up the table view above the keyboard when the keyboard appears on screen
	// Keyboard Delegates
	// Show the keyboard under the table view
	func placeKeyboardUnderTableView() {
		navigationItem.rightBarButtonItem = nil
		
		// setup keyboard event
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.keyboardWillShow(notification:)),
			name: UIResponder.keyboardDidShowNotification, object: nil)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.keyboardWillHide(notification:)),
			name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	
	@objc func keyboardWillShow(notification: NSNotification) {
		navigationItem.rightBarButtonItem = nil
		
		let userInfo = notification.userInfo!
		var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
		keyboardFrame = self.view.convert(keyboardFrame, from: nil)
		
		var contentInset: UIEdgeInsets = self.tableView.contentInset
		contentInset.bottom = keyboardFrame.size.height
		self.tableView.contentInset = contentInset
	}
	
	
	@objc func keyboardWillHide(notification: NSNotification) {
		let contentInset:UIEdgeInsets = UIEdgeInsets.zero
		self.tableView.contentInset = contentInset
	}
}
