//
//  CharacterSearchDetailsTableViewController.swift
//  ReplicaCharacterTableView
//
//  Created by JFC on 16/06/20.
//  Copyright © 2020 JFC. All rights reserved.
//

import UIKit

class CharacterSearchDetailsTableViewController: UITableViewController {
	// MARK: Constants and Variables
	let sections = Constant().kCharacterDetailsSectionTitles
	let noDataInSection = Constant()
	var characterImageURL: String = ""
	var characterDescription: String = ""
	var characterComics = [MarvelItems]()
	var characterSeries = [MarvelItems]()
	var characterStories = [MarvelItems]()
	var characterEvents = [MarvelItems]()
	var characterID: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
		
    }

    // MARK: - Table view data source
	override func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count
	}
	
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return (section == 0 || section == 1) ? 0.1 : 30  // For section 0 and 1 (where the hero's image  and hero's description are located), we use a height of 0.1 points. The other sections (which have names) have a height of 30.
	}
	
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView()
		let label = UILabel()
		
		if (section == 0 || section == 1) {
			// Again, the label's color for section 0 is "clear"
			label.backgroundColor = .clear
			view.addSubview(label)
		} else {
			label.text = sections[section]
			label.backgroundColor = UIColor.lightGray
			label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
			view.addSubview(label)
		}

		return view
	}
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (section == 0 || section == 1) {  // Image and description sections
			return 1
		} else if section == 2 {  // character's comics sections

			if characterComics.count == 0 {
				return 1
			} else {
				return characterComics.count
			}
			
		} else if section == 3 {  // character's series sections
			
			if characterSeries.count == 0 {
				return 1
			} else {
				return characterSeries.count
			}
			
		} else if section == 4 {  // character's stories sections
			
			if characterStories.count == 0 {
				return 1
			} else {
				return characterStories.count
			}
			
		} else {   				  // character's events sections
			
			if characterEvents.count == 0 {
				return 1
			} else {
				return characterEvents.count
			}
		}
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterSearchDetailsCell", for: indexPath) as? CharacterSearchDetailsTableViewCell else { return UITableViewCell() }
		cell.textLabel?.numberOfLines = 0
		
		if indexPath.section == 0 {  	    // character's Image section
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterSearchImageDetailsCell", for: indexPath) as? CharacterSearchImageTableViewCell else { return UITableViewCell() }
			cell.characterSearchImageImageView.downloaded(from: self.characterImageURL)
			cell.characterSearchImageImageView.contentMode = .scaleAspectFit
			
			
			return cell
		} else if indexPath.section == 1 { // character's description section
			
			if characterDescription == "" {
				cell.textLabel?.text = noDataInSection.kNoCharacterDescription
			} else {
				cell.textLabel?.text = characterDescription
			}
			
		} else if indexPath.section == 2 {  // character's comics section
			
			if characterComics.isEmpty {
				cell.textLabel?.text = noDataInSection.kNoCharacterComics
			} else {
				cell.textLabel?.text = characterComics[indexPath.row].name
			}

		} else if indexPath.section == 3 {  // character's series section
			
			if characterSeries.isEmpty {
				cell.textLabel?.text = noDataInSection.kNoCharacterSeries
			} else {
				cell.textLabel?.text = characterSeries[indexPath.row].name
			}
			
		} else if indexPath.section == 4 {  // character's stories section
			
			if characterStories.isEmpty {
				cell.textLabel?.text = noDataInSection.kNoCharacterStories
			} else {
				cell.textLabel?.text = characterStories[indexPath.row].name
			}
			
		} else {  							// character's events section
			
			if characterEvents.isEmpty {
				cell.textLabel?.text = noDataInSection.kNoCharacterEvents
			} else {
				cell.textLabel?.text = characterEvents[indexPath.row].name
			}
		}
		
		return cell
	}
	
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
