
<p align="center">
    <a href="https://app.bitrise.io/app/7728e287cc146a7f">
        <img src="https://app.bitrise.io/app/7728e287cc146a7f/status.svg?token=hud0QzPtQQzeKyywD1RyCA&branch=main"
             alt="Build Status">
    </a>
    <a href="https://github.com/aimalygin/StableCollectionViewLayout">
        <img src="https://img.shields.io/badge/cocoapods-latest-green"
             alt="Pods Version">
    </a>
    <a href="https://github.com/aimalygin/StableCollectionViewLayout">
        <img src="https://img.shields.io/badge/platform-ios-lightgrey"
             alt="Platforms">
    </a>
    <a href="https://github.com/aimalygin/StableCollectionViewLayout">
        <img src="https://img.shields.io/badge/spm-compatible-green"
             alt="SPM Compatible">
    </a>
</p>

----------------

# StableCollectionViewLayout

This layout adjusts a content offset if the collection view is updated. You can insert, delete or reload items and `StableCollectionViewLayout` will take care of the content offset.

Like this

![stable](https://raw.githubusercontent.com/aimalygin/InfiniteCollectionViewFlowLayout/main/stable.gif)

## Demo

![Demo](https://raw.githubusercontent.com/aimalygin/InfiniteCollectionViewFlowLayout/main/demo.gif)

## Usage

You should just create and pass `StableCollectionViewFlowLayout` to `UICollectionView` init
```swift
import StableCollectionViewLayout

UICollectionView(frame: .zero, collectionViewLayout: StableCollectionViewFlowLayout())
```
Also, you can create the own subclass of `StableCollectionViewLayout` and use it.

## Installation

### CocoaPods

The preferred installation method is with [CocoaPods](https://cocoapods.org). Add the following to your `Podfile`:

```ruby
pod 'StableCollectionViewLayout', '~> 1.0.0'
```

### Carthage

For [Carthage](https://github.com/Carthage/Carthage), add the following to your `Cartfile`:

```ogdl
github "aimalygin/StableCollectionViewLayout" ~> 1.0.0
```

### Swift Package Manager

For [Swift Package Manager](https://swift.org/package-manager/):

```
To integrate using Xcode:

File -> Swift Packages -> Add Package Dependency

Enter package URL: https://github.com/aimalygin/StableCollectionViewLayout, and select the latest release.
```