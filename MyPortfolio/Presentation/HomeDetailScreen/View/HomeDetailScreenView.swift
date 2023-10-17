//
//  HomeDetailScreenView.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import SwiftUI

struct HomeDetailScreenView<ViewModel: HomeDetailScreenViewModelInput>: View {
    /// The view model responsible for handling the business logic of the detail screen.
    @ObservedObject var viewModel: ViewModel
    /// The coordinator responsible for dismissing the detail screen.
    private(set) var detailScreenDismissCoordinator: DetailScreenDismissFlow?

    /// - Returns: A SwiftUI view hierarchy representing the body of the HomeDetailScreenView.
    var body: some View {
        VStack(spacing: ConstraintConstants.number20.rawValue) {
            CustomHeaderView()
            StockNameView()
            StockQuantityView()
            LastTradedPriceView()
            ProfitAndLossView()
            FavouriteButton()
            Spacer()
        }
        .padding(.top, .zero)
    }

    ///
    /// - Returns: A SwiftUI view representing the button for marking the favourite stocks.
    @ViewBuilder
    private func FavouriteButton() -> some View {
        Image(viewModel.data.isFavourite
              ? APP_IMAGES.favFilled.rawValue : APP_IMAGES.fav.rawValue)
        .resizable()
        .scaledToFit()
        .frame(width: ConstraintConstants.number40.rawValue, 
               height: ConstraintConstants.number40.rawValue)
        .onTapGesture {
            viewModel.userDidTapOnFavourite()
        }
        .accessibilityHint(viewModel.data.isFavourite ? Strings.markItAsUnFavCopyText.rawValue : Strings.markItAsFavCopyText.rawValue)
        .accessibilityAddTraits(.isButton)
    }

    ///
    /// - Returns: A SwiftUI view representing the copy text for Profit and loss view.
    @ViewBuilder
    private func ProfitAndLossView() -> some View {
        HStack() {
            Text(Strings.plRupees.rawValue)
                .modifier(TitleFieldModifier())
            Text(String(viewModel.data.profitNLoss))
                .modifier(ValueFieldModifier())
            Spacer()
        }
        .padding(.leading, ConstraintConstants.number10.rawValue)
    }

    ///
    /// - Returns: A SwiftUI view representing the copy text for last traded price.
    @ViewBuilder
    private func LastTradedPriceView() -> some View {
        HStack() {
            Text(Strings.ltpRupees.rawValue)
                .modifier(TitleFieldModifier())
            Text(String(viewModel.data.ltp ?? .zero))
                .modifier(ValueFieldModifier())
            Spacer()
        }
        .padding(.leading, ConstraintConstants.number10.rawValue)
    }

    ///
    /// - Returns: A SwiftUI view representing the copy text for stock quantity view.
    @ViewBuilder
    private func StockQuantityView() -> some View {
        HStack() {
            Text(Strings.stockQuantity.rawValue)
                .modifier(TitleFieldModifier())
            Text(String(Int(viewModel.data.quantity ?? .zero)))
                .modifier(ValueFieldModifier())
            Spacer()
        }
        .padding(.leading, ConstraintConstants.number10.rawValue)
    }

    ///
    /// - Returns: A SwiftUI view representing the copy text for stock name.
    @ViewBuilder
    private func StockNameView() -> some View {
        HStack() {
            Text(Strings.stockName.rawValue)
                .modifier(TitleFieldModifier())
            Text(viewModel.data.symbol ?? "")
                .modifier(ValueFieldModifier())
            Spacer()
        }
        .padding(.leading, ConstraintConstants.number10.rawValue)
    }

    ///
    /// - Returns: A SwiftUI view representing the header view with title and close button.
    @ViewBuilder
    private func CustomHeaderView() -> some View {
        HStack( content: {
            HeaderCopyText()
            Spacer()
            HeaderCloseButton()
        })
        .padding(.top, ConstraintConstants.number10.rawValue)
        .background(Color(UIColor.systemPurple))
        .frame(height: ConstraintConstants.number60.rawValue, alignment: .center)
    }

    ///
    /// - Returns: A SwiftUI view representing the header Copy text view.
    @ViewBuilder
    private func HeaderCopyText() -> some View {
        Text(Strings.detailHeader.rawValue)
            .multilineTextAlignment(.center)
            .padding()
            .foregroundStyle(.white)
            .font(.custom(FontName.helveticaBold.rawValue,
                          size: ConstraintConstants.number20.rawValue))
            .accessibilityAddTraits(.isHeader)
    }

    ///
    /// - Returns: A SwiftUI view representing the header close button view.
    @ViewBuilder
    private func HeaderCloseButton() -> some View {
        Image(APP_IMAGES.closeButton.rawValue)
            .renderingMode(.template)
            .resizable(capInsets: .init())
            .foregroundStyle(.white)
            .scaledToFit()
            .padding(.trailing, ConstraintConstants.number10.rawValue)
            .frame(width: ConstraintConstants.number40.rawValue, height: ConstraintConstants.number40.rawValue)
            .onTapGesture {
                detailScreenDismissCoordinator?.dismissDetailPage()
            }
            .accessibilityAddTraits(.isButton)
    }
}

/// A SwiftUI modifier representing the title text of the detail view.
private struct TitleFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontName.helveticaBold.rawValue,
                          size: ConstraintConstants.number18.rawValue))
    }
}
/// A SwiftUI modifier representing the values of corresponding title text of the detail view.
private struct ValueFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontName.helvetica.rawValue,
                          size: ConstraintConstants.number18.rawValue))
    }
}
