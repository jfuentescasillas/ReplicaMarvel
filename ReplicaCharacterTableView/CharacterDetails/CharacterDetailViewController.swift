//
//  CharacterDetailViewController.swift
//  ReplicaCharacterTableView
//
//  Created by Jorge Fuentes Casillas on 07/06/20.
//  Copyright © 2020 Jorge Fuentes Casillas. All rights reserved.
//

import UIKit

class CharacterDetailViewController: UITableViewController {
	// MARK: Constants and Variables
    var characterId: Int?
	let sections = Constant().kCharacterDetailsSectionTitles
	let noDataInSection = Constant()
	
	
	// MARK: - ViewDidLoad
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
		} else if section == 2 {  // Hero's comics sections
			return 3
			
		} else if section == 3 {  // Hero's series sections
			return 3
			
		} else if section == 4 {  // Hero's series sections
			return 3
		} else {
			return 3
		}
	}
	
	
	// MARK: - Table view delegates
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterDetailsCell", for: indexPath)
		cell.textLabel?.numberOfLines = 0
		
		if indexPath.section == 0 {  // Hero's Image section
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterImageCell", for: indexPath) as? CharacterImageTableViewCell else { return UITableViewCell() }
						
			return cell
		} else if indexPath.section == 1 { // Hero's description section
			
			cell.textLabel?.text = noDataInSection.kNoCharacterDescription
			/*if heroDescription == "" {
				cell.textLabel?.text = noDataInSection.kNoCharacterDescription
			} else {
				cell.textLabel?.text = heroDescription
			}*/
			
		} else if indexPath.section == 2 {  // Hero's comics section
			
			cell.textLabel?.text = noDataInSection.kNoCharacterComics
			/*if heroComics.isEmpty {
				cell.textLabel?.text = noDataInSection.kNoHeroComics
			} else {
				cell.textLabel?.text = heroComics[indexPath.row].name
			}*/

		} else if indexPath.section == 3 {  // Hero's series section
			
			cell.textLabel?.text = noDataInSection.kNoCharacterSeries
			/*if heroSeries.isEmpty {
				cell.textLabel?.text = noDataInSection.kNoHeroSeries
			} else {
				cell.textLabel?.text = heroSeries[indexPath.row].name
			}*/
			
		} else if indexPath.section == 4 {  // Hero's stories section
			
			cell.textLabel?.text = noDataInSection.kNoCharacterStories
			/*if heroStories.isEmpty {
				cell.textLabel?.text = noDataInSection.kNoHeroStories
			} else {
				cell.textLabel?.text = heroStories[indexPath.row].name
			}*/
			
		} else {  							// Hero's events section
			
			cell.textLabel?.text = noDataInSection.kNoCharacterEvents
			/*if heroEvents.isEmpty {
				cell.textLabel?.text = noDataInSection.kNoHeroEvents
			} else {
				cell.textLabel?.text = heroEvents[indexPath.row].name
			}*/
		}
		
		return cell
	}
	
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
