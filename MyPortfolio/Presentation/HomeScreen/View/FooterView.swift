//
//  FooterView.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import UIKit

final class FooterView: UIView {

    //MARK:- Properties
    private lazy var lblCurrentValueText: UILabel = {
        let lblCurrentValueText = UILabel()
        lblCurrentValueText.font = UIFont(name: FontName.helveticaBold.rawValue,
                                          size: ConstraintConstants.number18.rawValue)
        lblCurrentValueText.text = Strings.currentValue.rawValue
        lblCurrentValueText.translatesAutoresizingMaskIntoConstraints = false
        return lblCurrentValueText
    }()

    private lazy var lblCurrentValue: UILabel = {
        let lblCurrentValue = UILabel()
        lblCurrentValue.font = UIFont(name: FontName.helvetica.rawValue,
                                      size: ConstraintConstants.number16.rawValue)
        lblCurrentValue.textAlignment = .right
        lblCurrentValue.translatesAutoresizingMaskIntoConstraints = false
        return lblCurrentValue
    }()

    private lazy var lblTotalInvestmentText: UILabel = {
        let lblTotalInvestmentText = UILabel()
        lblTotalInvestmentText.font = UIFont(name: FontName.helveticaBold.rawValue,
                                             size: ConstraintConstants.number18.rawValue)
        lblTotalInvestmentText.text = Strings.totalInvestment.rawValue
        lblTotalInvestmentText.translatesAutoresizingMaskIntoConstraints = false
        return lblTotalInvestmentText
    }()

    private lazy var lblTotalInvestmentValue: UILabel = {
        let lblTotalInvestmentValue = UILabel()
        lblTotalInvestmentValue.font = UIFont(name: FontName.helvetica.rawValue,
                                              size: ConstraintConstants.number16.rawValue)
        lblTotalInvestmentValue.textAlignment = .right
        lblTotalInvestmentValue.translatesAutoresizingMaskIntoConstraints = false
        return lblTotalInvestmentValue
    }()

    private lazy var lblTodaysProfitnLossText: UILabel = {
        let lblTodaysProfitnLossText = UILabel()
        lblTodaysProfitnLossText.font = UIFont(name: FontName.helveticaBold.rawValue,
                                               size: ConstraintConstants.number18.rawValue)
        lblTodaysProfitnLossText.text = Strings.todaysPnL.rawValue
        lblTodaysProfitnLossText.translatesAutoresizingMaskIntoConstraints = false
        return lblTodaysProfitnLossText
    }()

    private lazy var lblTodaysProfitnLossValue: UILabel = {
        let lblTodaysProfitnLossValue = UILabel()
        lblTodaysProfitnLossValue.font = UIFont(name: FontName.helvetica.rawValue,
                                                size: ConstraintConstants.number16.rawValue)
        lblTodaysProfitnLossValue.textAlignment = .right
        lblTodaysProfitnLossValue.translatesAutoresizingMaskIntoConstraints = false
        return lblTodaysProfitnLossValue
    }()

    private lazy var lblProfitNLossText: UILabel = {
        let lblProfitNLossText = UILabel()
        lblProfitNLossText.font = UIFont(name: FontName.helveticaBold.rawValue,
                                         size: ConstraintConstants.number18.rawValue)
        lblProfitNLossText.text = Strings.profitNLoss.rawValue
        lblProfitNLossText.translatesAutoresizingMaskIntoConstraints = false
        return lblProfitNLossText
    }()

    private lazy var lblProfitNLossValue: UILabel = {
        let lblProfitNLossValue = UILabel()
        lblProfitNLossValue.font = UIFont(name: FontName.helvetica.rawValue,
                                          size: ConstraintConstants.number16.rawValue)
        lblProfitNLossValue.translatesAutoresizingMaskIntoConstraints = false
        lblProfitNLossValue.textAlignment = .right
        return lblProfitNLossValue
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    // MARK: - Setup UI
    private func setupUI() {
        addAllSubViews()
        applyConstraintToAddedSubViews()
    }

    private func addAllSubViews() {
        self.addSubview(lblCurrentValueText)
        self.addSubview(lblCurrentValue)
        self.addSubview(lblTotalInvestmentText)
        self.addSubview(lblTotalInvestmentValue)
        self.addSubview(lblTodaysProfitnLossText)
        self.addSubview(lblTodaysProfitnLossValue)
        self.addSubview(lblProfitNLossText)
        self.addSubview(lblProfitNLossValue)
    }

    private func applyConstraintToAddedSubViews() {

        // Current Value Static label
        labelCurrentValueStaticTextApplyConstraint()

        // Current Value label
        labelCurrentValueApplyConstraint()

        // Total Investment Static label
        labelTotalInvestmentStaticTextApplyConstraint()

        // Total Investment Value label
        labelTotalInvestmentValueApplyConstraint()

        // Todays Profit and Loss Static label
        labelTodaysProfitnLossStaticTextApplyConstraint()

        // Todays Profit and Loss Value label
        labelTodaysProfitnLossApplyConstraint()

        // Profit and Loss Static label
        labelProfitNLossStaticTextApplyConstraint()

        // Profit and Loss Value label
        labelProfitNLossApplyConstraint()
    }
}

/// All UI element wise constraint functions
private extension FooterView {

    private func labelCurrentValueStaticTextApplyConstraint() {
        lblCurrentValueText.topAnchor.constraint(equalTo: self.topAnchor,
                                                 constant: ConstraintConstants.number20.rawValue).isActive = true
        lblCurrentValueText.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                     constant: ConstraintConstants.number25.rawValue).isActive = true
        lblCurrentValueText.trailingAnchor.constraint(equalTo: self.lblCurrentValue.leadingAnchor,
                                                      constant: ConstraintConstants.number5.rawValue).isActive = true
    }

    private func labelCurrentValueApplyConstraint() {
        lblCurrentValue.topAnchor.constraint(equalTo: self.topAnchor,
                                             constant: ConstraintConstants.number20.rawValue).isActive = true
        lblCurrentValue.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                  constant: -ConstraintConstants.number20.rawValue).isActive = true
    }

    private func labelTotalInvestmentStaticTextApplyConstraint() {
        lblTotalInvestmentText.topAnchor.constraint(equalTo: self.lblCurrentValueText.bottomAnchor,
                                                    constant: ConstraintConstants.number5.rawValue).isActive = true
        lblTotalInvestmentText.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                        constant: ConstraintConstants.number25.rawValue).isActive = true
        lblTotalInvestmentText.trailingAnchor.constraint(equalTo: self.lblTotalInvestmentValue.leadingAnchor,
                                                         constant: ConstraintConstants.number5.rawValue).isActive = true
    }

    private func labelTotalInvestmentValueApplyConstraint() {
        lblTotalInvestmentValue.topAnchor.constraint(equalTo: self.lblCurrentValue.bottomAnchor,
                                                     constant: ConstraintConstants.number10.rawValue).isActive = true
        lblTotalInvestmentValue.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                          constant: -ConstraintConstants.number20.rawValue).isActive = true
    }

    private func labelTodaysProfitnLossStaticTextApplyConstraint() {
        lblTodaysProfitnLossText.topAnchor.constraint(equalTo: self.lblTotalInvestmentText.bottomAnchor,
                                                      constant: ConstraintConstants.number10.rawValue).isActive = true
        lblTodaysProfitnLossText.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                          constant: ConstraintConstants.number25.rawValue).isActive = true
        lblTodaysProfitnLossText.trailingAnchor.constraint(equalTo: self.lblTodaysProfitnLossValue.leadingAnchor,
                                                           constant: ConstraintConstants.number5.rawValue).isActive = true
    }

    private func labelTodaysProfitnLossApplyConstraint() {
        lblTodaysProfitnLossValue.topAnchor.constraint(equalTo: self.lblTotalInvestmentValue.bottomAnchor,
                                                       constant: ConstraintConstants.number10.rawValue).isActive = true
        lblTodaysProfitnLossValue.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                            constant: -ConstraintConstants.number20.rawValue).isActive = true
    }

    private func labelProfitNLossStaticTextApplyConstraint() {
        lblProfitNLossText.topAnchor.constraint(equalTo: self.lblTodaysProfitnLossText.bottomAnchor,
                                                constant: ConstraintConstants.number25.rawValue).isActive = true
        lblProfitNLossText.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                    constant: ConstraintConstants.number25.rawValue).isActive = true
        lblProfitNLossText.trailingAnchor.constraint(equalTo: self.lblProfitNLossValue.leadingAnchor,
                                                     constant: ConstraintConstants.number5.rawValue).isActive = true
        lblProfitNLossText.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                                                   constant: -ConstraintConstants.number40.rawValue).isActive = true
    }

    private func labelProfitNLossApplyConstraint() {
        lblProfitNLossValue.topAnchor.constraint(equalTo: self.lblTodaysProfitnLossValue.bottomAnchor,
                                                 constant: ConstraintConstants.number25.rawValue).isActive = true
        lblProfitNLossValue.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                      constant: -ConstraintConstants.number20.rawValue).isActive = true
        lblProfitNLossValue.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                                                    constant: -ConstraintConstants.number40.rawValue).isActive = true
    }
}

/// Extension to update data of the following footer text
///
extension FooterView {
    func setUpFooterData(viewModel: HomeScreenViewInputCommonProtocol) {
        lblCurrentValue.text = Strings.rupeeSymbol.rawValue +        "\(viewModel.getAllCurrentValue())"
        lblTotalInvestmentValue.text = Strings.rupeeSymbol.rawValue + "\(viewModel.getAllInvestmentValue())"
        setTodaysProfitNLoss(viewModel: viewModel)
        setTotalProfitNLoss(viewModel: viewModel)
    }

    private func setTodaysProfitNLoss(viewModel: HomeScreenViewInputCommonProtocol) {
        guard let getTodaysPnL = viewModel.getTodaysPnL() else {
            return
        }
        lblTodaysProfitnLossValue.text = Strings.rupeeSymbol.rawValue + "\(getTodaysPnL.0)"
    }

    private func setTotalProfitNLoss(viewModel: HomeScreenViewInputCommonProtocol) {
        guard let getTotalPnL = viewModel.getTotalPnL() else {
            return
        }
        lblProfitNLossValue.text = Strings.rupeeSymbol.rawValue + "\(getTotalPnL.0)"
    }
}

/// Extension to Apply color on the following text
///
extension FooterView {
    /// Func to add color on lblProfitNLossValue
    func applyProfitAndLossLabelColor(viewModel: HomeScreenViewInputCommonProtocol?) {
        guard let viewModel = viewModel,
              let getTotalPnL = viewModel.getTotalPnL() else {
            return
        }
        switch getTotalPnL.1 {
        case .Positive:
            lblProfitNLossValue.textColor = UIColor.systemGreen
        case .Negative:
            lblProfitNLossValue.textColor = UIColor.systemRed
        case .Zero:
            return
        }
    }

    /// Func to add color on lblTodaysProfitnLossValue
    func applyTodaysProfitAndLossLabelColor(viewModel: HomeScreenViewInputCommonProtocol?) {
        guard let viewModel = viewModel, let getTodaysPnL = viewModel.getTodaysPnL()  else {
            return
        }
        switch getTodaysPnL.1 {
        case .Positive:
            lblTodaysProfitnLossValue.textColor = UIColor.systemGreen
        case .Negative:
            lblTodaysProfitnLossValue.textColor = UIColor.systemRed
        case .Zero:
            return
        }
    }

}
