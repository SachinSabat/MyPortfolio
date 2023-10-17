# MyPortfolio
User can see it's portfolio of stocks holding and can mark any stocks as favourite/ Not-favourite in the portfolio of stock one holds. 

## Features
- [x] Clean Architecture
- [x] MVVM-C
- [x] Usefull extension
- [x] SwiftUI
- [x] Code based UI
- [x] Application Architecture (Usecase, Repository)
- [x] Protocol Oriented based Implementation
- [x] Unit Test
- [x] UI Test
- [x] Accessibility Supported

## Swift Package Manager
- [x] swift-snapshot-testing

## Field Details and Calculations
1. Symbol => Use from JSON response
2. Quantity => Use from JSON response
3. LTP => Use from JSON response
4. P&L = Current value (Individual item) (minus) Investment value (Individual
item)
5. Current value (Individual item) = LTP * Quantity
6. Investment value (Individual item) = Avg. Price - Quantity
7. Current value = sum of all the Current values
8. Total investment = sum of all the Investment values 
9. Total PNL = Current value - Total Investment
10. Today’s PNL = sum of ((previous_close - LTP ) * quantity) of all the holdings

## Description
- Home page shows the Stocks List. Where one can mark a stocks as favourite/ Not-favourite.
- Detail page shows detail of stock with a favourite button. Once user clicked on it, the stock  will change to favourite/ Not-favourite; same will reflect on the home page too.
- HomeScreenViewModel has getHomeScreenData which uses repository pattern to fetch data from the API. ViewModel is not aware how the data is fetched.
- HomeScreenProtocol defines the feature architecture and uses protocol input output architecture (Delegate approach).

## Unit test Code Coverage- Overall(92.6%)
<img width="1466" alt="CodeCoverageUnitTest" src="https://github.com/SachinSabat/MyPortfolio/assets/22394585/4d504b49-ccd2-4643-b170-1716badbb19e">

## UI test Code Coverage- Overall(88.7%)
<img width="1460" alt="CodeCoverageUItest" src="https://github.com/SachinSabat/MyPortfolio/assets/22394585/570fa22d-80a0-49a0-95a8-69207bd10116">

## Screen Shot of application
![LauchPage](https://github.com/SachinSabat/MyPortfolio/assets/22394585/4e1c8aa2-aa61-4054-91d1-a29ec77f8ff6)
![HomeScreen](https://github.com/SachinSabat/MyPortfolio/assets/22394585/6c09fa38-9174-4f0f-bca5-ef3fc95c938c)
![HomeScreenFavMarked](https://github.com/SachinSabat/MyPortfolio/assets/22394585/bff3957d-1fbb-4f4a-9c0f-605af74bc7b6)
![DetailScreenNotFav](https://github.com/SachinSabat/MyPortfolio/assets/22394585/e81e264a-ad7c-4619-8513-b4b272c65419)
![DetailScreenFav](https://github.com/SachinSabat/MyPortfolio/assets/22394585/4eea46d3-97c3-4460-8134-28437aa541cf)






