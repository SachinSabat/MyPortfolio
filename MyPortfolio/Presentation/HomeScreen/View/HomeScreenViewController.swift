//
//  HomeScreenViewController.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import UIKit

/// A view controller responsible for displaying the home screen.
final class HomeScreenViewController: UIViewController, BaseViewInput {

    //MARK: Properties
    /// The view model for the home screen.
    private var viewModel: HomeScreenViewInputCommonProtocol?
    /// The view state for the home screen.
    private (set) var viewState: ViewState = .none
    /// The coordinator for the home screen's detail flow.
    private var homeScreenDetailCoordinator: HomeDetailScreenFlow?
    /// The table view displaying data on the home screen.
    private var homeScreenTableViewController: HomeScreenTableViewController?

    /// The footer view displayed at the bottom of the table view.
    private lazy var uiFooterView: FooterView = {
        let uiView = FooterView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()

    //MARK: Lifecycle Methods
    convenience init(viewModel: HomeScreenViewInputCommonProtocol,
                     homeScreenTableViewController: HomeScreenTableViewController,
                     homeScreenDetailCoordinator: HomeDetailScreenFlow)
    {
        self.init()
        self.viewModel = viewModel
        self.homeScreenTableViewController = homeScreenTableViewController
        self.homeScreenDetailCoordinator = homeScreenDetailCoordinator
    }

    override func loadView() {
        super.loadView()
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationTitle()
        setupViewModel()
    }

    // MARK: - Methods
    /// Sets up the navigation title for the view controller.
    private func setUpNavigationTitle() {
        self.navigationItem.title = NavigationHeaderTitle.homeScreenTitle.rawValue
    }

    /// Sets up the view model and initiates data loading.
    private func setupViewModel() {
        if let viewModel = viewModel {
            viewModel.viewDelegate = self
            viewModel.getHomeScreenData()
        }
    }

    /// Sets up the table view and its constraints.
    private func setUpTableView() {
        if let homeScreenTableViewController = self.homeScreenTableViewController {
            self.homeScreenTableViewController = .init(tableViewHandler: homeScreenTableViewController.tableViewHandler,
                                                  viewModel: viewModel,
                                                  homeScreenDetailCoordinator: homeScreenDetailCoordinator)
            setupTableViewConstraints()
        }
    }

    /// Adds Constraints to the TableView
    private func setupTableViewConstraints() {
        guard let homeScreenTableViewControllerView = homeScreenTableViewController?.view else {
            return
        }
        self.view.addSubview(homeScreenTableViewControllerView)
        self.view.addSubview(uiFooterView)

        homeScreenTableViewControllerView.translatesAutoresizingMaskIntoConstraints = false
        homeScreenTableViewControllerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                                                                constant: ConstraintConstants.number0.rawValue).isActive = true
        homeScreenTableViewControllerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                                    constant: ConstraintConstants.number0.rawValue).isActive = true
        homeScreenTableViewControllerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                                     constant: ConstraintConstants.number0.rawValue).isActive = true
        homeScreenTableViewControllerView.bottomAnchor.constraint(equalTo: self.uiFooterView.topAnchor,
                                                                   constant: ConstraintConstants.number0.rawValue).isActive = true
    }

    /// Sets up the footer view and its constraints.
    private func setupFooterView() {
        uiFooterView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
                                              constant: ConstraintConstants.number0.rawValue).isActive = true
        uiFooterView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
                                               constant: ConstraintConstants.number0.rawValue).isActive = true
        uiFooterView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                             constant: ConstraintConstants.number0.rawValue).isActive = true
    }
}

//MARK: Delegates of the API - HomeScreenViewModelOutput, PresentAlert
extension HomeScreenViewController: HomeScreenViewModelOutput, PresentAlert {

    /// Changes the view state of the screen and updates UI components accordingly.
    ///
    /// - Important: This method updates the view state and performs UI-related actions based on the provided state.
    ///
    /// - Parameter state: The new view state to set.
    ///
    func changeViewState(_ state: ViewState) {
        viewState = state
        switch state {
        case .loading:
            // Show loading spinner.
            showActivityLoader()
        case .content:
            // Hide loading spinner, set up table view and footer view, and update the data.
            hideActivityLoader()
            setUpTableView()
            setupFooterView()
            self.updateData()
        case .error(let message):
            // Hide loading spinner, show an alert with the provided error message, and trigger data retrieval on alert dismissal.
            hideActivityLoader()
            self.showAlertWith(message: message) { [weak self] in
                guard let self = self else {
                    return
                }
                guard let viewModel = self.viewModel else {
                    return
                }
                viewModel.getHomeScreenData()
            }
        case .reloadAtParticularRowIndex(let atIndex):
            // When user click on fav button it will reload the data of that particular index
            homeScreenTableViewController?.reloadDataAtIndex(atIndex: atIndex)
        default:
            // Handle other states (if needed).
            break
        }
    }

    /// Update the data and Reload the Table View
    func updateData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.updateFooterViewData()
            self.applyFooterViewColor()
            self.homeScreenTableViewController?.reload()
        }
    }
}

//MARK: Assign data and Label color to the foorter view labels
private extension HomeScreenViewController {

    private func updateFooterViewData() {
        if let viewModel = viewModel {
            uiFooterView.setUpFooterData(viewModel: viewModel)
        }
    }

    private func applyFooterViewColor() {
        self.uiFooterView.applyProfitAndLossLabelColor(viewModel: self.viewModel)
        self.uiFooterView.applyTodaysProfitAndLossLabelColor(viewModel: self.viewModel)
    }
}
