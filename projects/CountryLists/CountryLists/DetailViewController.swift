//
//  DetailViewController.swift
//  CountryLists
//
//  Created by Yi An Chen on 2022/4/15.
//

import UIKit

class DetailViewController: UITableViewController {
    var country: Country?
    @IBOutlet var capitalLabel: UILabel!
    @IBOutlet var populationLabel: UILabel!
    @IBOutlet var areaLabel: UILabel!
    @IBOutlet var flagLabel: UILabel!
    @IBOutlet var languageLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = country?.name.common
        navigationItem.largeTitleDisplayMode = .never
        
        guard let country = country else { return }
        
        capitalLabel.text = country.capital?.formatted(.list(type: .and)) ?? "-"
        populationLabel.text = country.population.formatted() + " people"
        areaLabel.text = country.area.formatted() + " km2"
        flagLabel.text = country.flag ?? "-"
        languageLabel.text = country.languages?.values.formatted(.list(type: .and)) ?? "-"
        currencyLabel.text = country.currencies?.values.map{ $0.name }.formatted(.list(type: .and)) ?? "-"
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
