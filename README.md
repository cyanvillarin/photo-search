# UnifaCodingExam

This is the coding exam for my job application at UniFa.

NOTE: In case the API doesn't work, the reason could be that the API request limit has been reached. The limit is 200 requests per hour and 20,000 requests per month. If that happens, please contact me and I will update the API key. Thank you for understanding.

## Frameworks Used
1. RxSwift - for Data Binding View and ViewModel
2. RxCocoa - for integrating TableView with RxSwift
3. SDWebImage - for loading images
4. NVActivityIndicatorView - for loading view
5. RxTest - for testing RxSwift components

## Architecture
1. This project was made using the MVVM Architecture

## Swift Concurrency
1. This project uses the latest technology introduced by Swift which is the Swift Concurrency. So for performing asynchronous tasks, instead of using the completionHandler, I have used the async-await keywords instead.
2. I also used withCheckedThrowingContinuation function, since this is needed when we want to integrate completionHandler-based functions inside a async-based function.

## Unit Testing
1. Unit Testing was done in this project, however it is not 100% code coverage. I only added Unit Testing for ViewModel files.
2. SearchViewModel and SearchTableViewCellViewModel both have 100% code coverage.
3. Needed to use RxTest framework in order to see the values on stream of the Observable properties.



