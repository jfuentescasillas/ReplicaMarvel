# MarvelApiWrapper

[![CI Status](https://img.shields.io/travis/tdle94/MarvelApiWrapper.svg?style=flat)](https://travis-ci.org/tdle94/MarvelApiWrapper)
[![Version](https://img.shields.io/cocoapods/v/MarvelApiWrapper.svg?style=flat)](https://cocoapods.org/pods/MarvelApiWrapper)
[![License](https://img.shields.io/cocoapods/l/MarvelApiWrapper.svg?style=flat)](https://cocoapods.org/pods/MarvelApiWrapper)
[![Platform](https://img.shields.io/cocoapods/p/MarvelApiWrapper.svg?style=flat)](https://cocoapods.org/pods/MarvelApiWrapper)

## About
A wrapper class around Marvel API that will make your life easier for requesting characters, comics, event, stories and much more from Marvel Studio. I use this for [My Marvel app](https://github.com/tdle94/Marvel-App)

## Motivation
Marvel API has many optional parameter for their GET request. This will simplify your API call as you can choose to whether or not to provide optional parameter through Config without having to remember what to provide to your GET request.

## Usage
You have to get public and private key from [Marvel](https://developer.marvel.com/)

```swift
let privateKey = "replace with your own private key"
let publicKey = "replace with your own public key"

let marvel = MarvelApiWrapper(publicKey: privateKey, privateKey: publicKey)
var config = StoryConfig()
config.limit = 1

marvel.getAllStorieWith(config: config) { data, statusCode, error in
  guard let data = data else {
    return
  }
          
  let json = JSON(data)
  // Do something with json data
}
```
## Installation

MarvelApiWrapper is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MarvelApiWrapper'
```

## Author

tdle94, tuyendle92

## License

MarvelApiWrapper is available under the MIT license. See the LICENSE file for more info.
