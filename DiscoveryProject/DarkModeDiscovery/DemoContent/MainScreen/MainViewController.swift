//
//  MainViewController.swift
//  DarkModeDiscovery
//
//  Created by Mikhail Zhigulin on 09.02.2022.
//

import UIKit
import PerseusDarkMode
import AdaptedSystemUI

class MainViewController: UIViewController, AppearanceAdaptableElement
{
    deinit { AppearanceService.unregister(self) }
    
    // MARK: - Interface Builder connections
    
    @IBOutlet weak var titleTop    : UILabel!
    @IBOutlet weak var titleImage  : UIImageView!
    
    @IBOutlet weak var tableView   : UITableView!
    @IBOutlet weak var bottomImage : UIImageView!
    
    @IBOutlet weak var optionsPanel: OptionsPanel!
    
    // MARK: - The data to show on screen
    
    private lazy var members: [Member] =
        {
            guard let fileURL = Bundle.main.url(forResource: "members", withExtension: "json"),
                  let data = try? Data(contentsOf: fileURL)
            else { return [] }
            
            return (try? JSONDecoder().decode([Member].self, from: data)) ?? []
        }()
    
    // MARK: - Instance of the class
    
    class func storyboardInstance() -> MainViewController
    {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        let screen = storyboard.instantiateInitialViewController() as! MainViewController
        
        /// Do default setup; don't set any parameter causing loadView up, breaks unit tests
        
        screen.modalTransitionStyle = UIModalTransitionStyle.partialCurl
        
        return screen
    }
    
    // MARK: - The life cyrcle group of methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        AppearanceService.register(self)
        configure()
        
        //let value = PerseusDarkMode.AppearanceService.shared.isEnabled
        
        //print(value.description)
        //let color: UIColor = .label
    }
    
    // MARK: - AppearanceAdaptableElement protocol
    
    func adaptAppearance() { makeUp() }
    
    // MARK: - Appearance matter methods
    
    private func configure()
    {
        titleTop.text = "The Fellowship of the Ring"
        
        titleImage.layer.cornerRadius = 40
        titleImage.layer.masksToBounds = true
        
        optionsPanel.segmentedControlValueChangedClosure =
            { actualValue in
                // Value should be saved
                
                self.DarkMode.DarkModeUserChoice = actualValue
                
                // Value should be updated on screen after
                
                self.optionsPanel.setStatusValue(self.DarkMode.Style)
                
                // Customise appearance
                
                AppearanceService.adaptToDarkMode()
            }
        optionsPanel.actionButtonClosure =
            {
                self.present(self.semanticToolsViewController,
                             animated  : true,
                             completion: nil)
            }
        
        optionsPanel.setSegmentedControlValue(DarkMode.DarkModeUserChoice)
        optionsPanel.setStatusValue(DarkMode.Style)
        
        // Move to makeUp if changing
        
        bottomImage.image = UIImage(named: "OneRing")
    }
    
    private func makeUp()
    {
        optionsPanel.setStatusValue(DarkMode.Style)
        
        view.backgroundColor = ._customPrimaryBackground
        titleTop.textColor = ._customTitle
        
        titleImage.image = DarkMode.Style == .light ?
            UIImage(named: "TheFellowship") :
            UIImage(named: "FrodoWithTheRing")
    }
    
    // MARK: - Dark Mode switched manually
    
    func userChoiceForDarkModeChanged(_ actualValue: DarkModeOption)
    {
        // Value should be saved
        
        DarkMode.DarkModeUserChoice = actualValue
        
        // Value should be updated on screen after
        
        optionsPanel.setStatusValue(DarkMode.Style)
        
        // Customise appearance
        
        AppearanceService.adaptToDarkMode()
    }

    // MARK: - Child View Controllers
    
    private lazy var detailsViewController =
        { () -> DetailsViewController in
            
            let storyboard = UIStoryboard(name  : String(describing: DetailsViewController.self),
                                          bundle: nil)
            
            let screen = storyboard.instantiateInitialViewController() as! DetailsViewController
            
            /// Do default setup; don't set any parameter causing loadView up, breaks unit tests
            //screen.makeUp()
            
            return screen
        }()
    
    private lazy var semanticToolsViewController =
        { () -> SemanticsViewController in
            
            let storyboard = UIStoryboard(name  : String(describing: SemanticsViewController.self),
                                          bundle: nil)
            
            let screen = storyboard.instantiateInitialViewController() as! SemanticsViewController
            
            /// Do default setup; don't set any parameter causing loadView up, breaks unit tests
            
            screen.view.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            
            return screen
        }()
}

// MARK: - UITableView

extension MainViewController: UITableViewDataSource, UITableViewDelegate
{
    // MARK: - UITableViewDataSource protocol
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "MemberCell", for: indexPath) as? MemberTableViewCell
        else { return UITableViewCell() }
        
        cell.data = members[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate protocol
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let index = self.tableView.indexPathForSelectedRow
        {
            self.tableView.deselectRow(at: index, animated: false)
        }
        
        present(detailsViewController, animated: true, completion: nil)
        detailsViewController.data = members[indexPath.row]
    }
}

// MARK: - Experiments

extension MainViewController
{
    private func experiment()
    {
        print("[\(type(of: self))] " + #function)
        
        print("UserChoice: \(AppearanceService.shared.DarkModeUserChoice)")
        print("System: \(DarkModeDecision.calculateSystemStyle())")
        print("DarkMode: \(AppearanceService.shared.Style)")
        
        titleTop.isHidden = true
        
        if #available(iOS 13.0, *),
           let view = titleTop.nextFirstResponder(where: { $0 is UIView }) as? UIView
        {
            view.backgroundColor = .label
            print(UIColor.label.rgba)
        }
    }
}

/*
 
 print("UserChoice: \(AppearanceService.shared.DarkModeUserChoice)")
 print("System: \(DarkModeDecision.calculateSystemStyle())")
 print("DarkMode: \(AppearanceService.shared.Style)")
 
 print("[\(type(of: self))] " + #function)
 
 //let _ = UIColor()
 //let _ : UIColor = .systemRed
 
 //if #available(iOS 13.0, *) { self.view.backgroundColor = ._systemBackground }
 //if #available(iOS 13.0, *) { print(UIColor.systemBackground.rgba) }
 
 */
