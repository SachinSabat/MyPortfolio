//
//  HomeScreenCellView.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import UIKit

final class HomeScreenCellView: UIView {
    //MARK: Properties
    /// The view model for the home table view screen.
    var viewModel: HomeScreenViewInputCommonProtocol?
    
    private (set) lazy var lblSymbol: UILabel = {
        let lblSymbol = UILabel()
        lblSymbol.font = UIFont(name: FontName.helveticaBold.rawValue,
                                size: ConstraintConstants.number18.rawValue)
        lblSymbol.translatesAutoresizingMaskIntoConstraints = false
        return lblSymbol
    }()

    private (set) lazy var lblQuantity: UILabel = {
        let lblQuantity = UILabel()
        lblQuantity.font = UIFont(name: FontName.helvetica.rawValue,
                                  size: ConstraintConstants.number16.rawValue)
        lblQuantity.translatesAutoresizingMaskIntoConstraints = false
        return lblQuantity
    }()

    private lazy var lblLTPStaticText: UILabel = {
        let lblLTPStaticText = UILabel()
        lblLTPStaticText.font = UIFont(name: FontName.helvetica.rawValue,
                                       size: ConstraintConstants.number16.rawValue)
        lblLTPStaticText.text = Strings.ltpRupees.rawValue
        lblLTPStaticText.translatesAutoresizingMaskIntoConstraints = false
        return lblLTPStaticText
    }()

    private (set) lazy var lblLTPValue: UILabel = {
        let lblLTPValue = UILabel()
        lblLTPValue.font = UIFont(name: FontName.helvetica.rawValue,
                                  size: ConstraintConstants.number16.rawValue)
        lblLTPValue.translatesAutoresizingMaskIntoConstraints = false
        return lblLTPValue
    }()

    private lazy var lblPLStaticText: UILabel = {
        let lblPLStaticText = UILabel()
        lblPLStaticText.font = UIFont(name: FontName.helvetica.rawValue,
                                      size: ConstraintConstants.number16.rawValue)
        lblPLStaticText.text = Strings.plRupees.rawValue
        lblPLStaticText.translatesAutoresizingMaskIntoConstraints = false
        return lblPLStaticText
    }()

    private (set) lazy var lblPLValue: UILabel = {
        let lblPLValue = UILabel()
        lblPLValue.font = UIFont(name: FontName.helvetica.rawValue,
                                 size: ConstraintConstants.number16.rawValue)
        lblPLValue.translatesAutoresizingMaskIntoConstraints = false
        lblPLValue.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return lblPLValue
    }()

    lazy var imgForwardArrow: UIImageView = {
        let imgForwardArrow = UIImageView()
        imgForwardArrow.contentMode = .scaleAspectFit
        imgForwardArrow.image = UIImage(named: APP_IMAGES.forwardArrow.rawValue)
        imgForwardArrow.translatesAutoresizingMaskIntoConstraints = false
        imgForwardArrow.layer.masksToBounds = true
        return imgForwardArrow
    }()

    lazy var btnMarkAsFav: UIButton = {
        let btnMarkAsFav = UIButton()
        btnMarkAsFav.contentMode = .scaleAspectFit
        btnMarkAsFav.setImage(UIImage(named: APP_IMAGES.fav.rawValue), for: .normal)
        btnMarkAsFav.translatesAutoresizingMaskIntoConstraints = false
        btnMarkAsFav.layer.masksToBounds = true
        btnMarkAsFav.addTarget(self, action: #selector(userDidTapOnFavourite),
                                                  for: .touchUpInside)
        return btnMarkAsFav
    }()

    // MARK: Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    // MARK: Setu UI and its Constraint
    private func setupUI() {
        addAllSubViews()
        applyConstraintToAddedSubViews()
        setAccessibilityElement()
    }

    private func addAllSubViews() {
        self.addSubview(lblSymbol)
        self.addSubview(lblQuantity)
        self.addSubview(lblLTPStaticText)
        self.addSubview(lblLTPValue)
        self.addSubview(lblPLStaticText)
        self.addSubview(lblPLValue)
        self.addSubview(imgForwardArrow)
        self.addSubview(btnMarkAsFav)
    }

    private func applyConstraintToAddedSubViews() {
        // Symbol value text label
        labelSymbolApplyConstraint()

        // Fav Button
        buttonMarkAsFavApplyConstraint()

        // LTP static text label
        labelLTPStaticTextApplyConstraint()

        // LTP value text label
        labelLTPValueApplyConstraint()

        // Quantity value text label
        labelQuantityApplyConstraint()

        // PL static text label
        labelPLStaticTextApplyConstraint()

        // PL static text label
        labelPLValueApplyConstraint()

        // Forward Image
        imageForwardArrowApplyConstraint()
    }

    private func setAccessibilityElement() {
        self.accessibilityElements = [btnMarkAsFav, lblSymbol, lblQuantity, 
                                      lblLTPStaticText, lblLTPValue, lblPLStaticText,
                                      lblPLValue]
    }
}

//MARK: Exetnsion to setup data
extension HomeScreenCellView {
    //MARK: SetData for label text
    func setData(data: HomeScreenListItemViewData,
                 viewModel: HomeScreenViewInputCommonProtocol)
    {
        self.viewModel = viewModel
        lblSymbol.text = data.symbol
        if let quantity = data.quantity {
            lblQuantity.text = "\(Int(quantity))"
        } else {
            lblQuantity.text = Strings.noValue.rawValue
        }
        if let ltp = data.ltp {
            lblLTPValue.text = "\(ltp)"
        } else {
            lblLTPValue.text = Strings.noValue.rawValue
        }
        lblPLValue.text = "\(data.profitNLoss)"
        setImageForBtnMarkAsFav(data: data)
    }

    /// Set the image on the favorite button.
    ///
    /// - Parameter data: HomeScreenListItemViewData received from HomeScreenTableViewController
    private func setImageForBtnMarkAsFav(data: HomeScreenListItemViewData) {
        let image = data.isFavourite ? UIImage(named: APP_IMAGES.favFilled.rawValue) : UIImage(named: APP_IMAGES.fav.rawValue)
        btnMarkAsFav.setImage(image, for: .normal)
    }

    /// Handles the user's tap on the favorite button.
    ///
    /// - Parameter sender: The button that was tapped.
    @objc func userDidTapOnFavourite(sender: UIButton) {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.userDidTapOnFavourite(at: sender.tag)
    }
}

/// All UI element wise constraint functions
extension HomeScreenCellView {

    private func labelSymbolApplyConstraint() {
        lblSymbol.topAnchor.constraint(equalTo: self.topAnchor,
                                       constant: ConstraintConstants.number15.rawValue).isActive = true
        lblSymbol.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                           constant: ConstraintConstants.number30.rawValue).isActive = true
        lblSymbol.trailingAnchor.constraint(equalTo: self.lblLTPStaticText.leadingAnchor,
                                            constant: -ConstraintConstants.number5.rawValue).isActive = true
    }

    private func buttonMarkAsFavApplyConstraint() {
        btnMarkAsFav.centerYAnchor.constraint(equalTo: self.centerYAnchor,
                                              constant: .zero).isActive = true
        btnMarkAsFav.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                              constant: ConstraintConstants.number5.rawValue).isActive = true
        btnMarkAsFav.heightAnchor.constraint(equalToConstant: ConstraintConstants.number20.rawValue).isActive = true
        btnMarkAsFav.widthAnchor.constraint(equalToConstant: ConstraintConstants.number20.rawValue).isActive = true
    }

    private func labelLTPStaticTextApplyConstraint() {
        lblLTPStaticText.topAnchor.constraint(equalTo: self.topAnchor,
                                              constant: ConstraintConstants.number15.rawValue).isActive = true
        lblLTPStaticText.trailingAnchor.constraint(equalTo: self.lblLTPValue.leadingAnchor,
                                                   constant: ConstraintConstants.number0.rawValue).isActive = true
    }

    private func labelLTPValueApplyConstraint() {
        lblLTPValue.topAnchor.constraint(equalTo: self.topAnchor,
                                         constant: ConstraintConstants.number15.rawValue).isActive = true
        lblLTPValue.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                              constant: -ConstraintConstants.number20.rawValue).isActive = true
    }

    private func labelQuantityApplyConstraint() {
        lblQuantity.topAnchor.constraint(equalTo: self.lblSymbol.bottomAnchor,
                                         constant: ConstraintConstants.number5.rawValue).isActive = true
        lblQuantity.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                             constant: ConstraintConstants.number30.rawValue).isActive = true
        lblQuantity.trailingAnchor.constraint(equalTo: self.lblPLStaticText.leadingAnchor,
                                              constant: -ConstraintConstants.number5.rawValue).isActive = true
        lblQuantity.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                            constant: -ConstraintConstants.number15.rawValue).isActive = true
    }

    private func labelPLStaticTextApplyConstraint() {
        lblPLStaticText.topAnchor.constraint(equalTo: self.lblLTPStaticText.bottomAnchor,
                                             constant: ConstraintConstants.number10.rawValue).isActive = true
        lblPLStaticText.trailingAnchor.constraint(equalTo: self.lblPLValue.leadingAnchor,
                                                  constant: ConstraintConstants.number0.rawValue).isActive = true
    }

    private func labelPLValueApplyConstraint() {
        lblPLValue.topAnchor.constraint(equalTo: self.lblLTPValue.bottomAnchor,
                                        constant: ConstraintConstants.number10.rawValue).isActive = true
        lblPLValue.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                             constant: -ConstraintConstants.number20.rawValue).isActive = true
    }

    private func imageForwardArrowApplyConstraint() {
        imgForwardArrow.bottomAnchor.constraint(equalTo: self.lblPLValue.topAnchor,
                                                constant: ConstraintConstants.number10.rawValue).isActive = true
        imgForwardArrow.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                  constant: .zero).isActive = true
    }
}
