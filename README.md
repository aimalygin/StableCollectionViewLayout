# StableCollectionViewLayout

This layout adjusts a content offset if the collection view is updated. You can insert, delete or reload items and `StableCollectionViewLayout` will take care of the content offset.

Like this

![stable](https://raw.githubusercontent.com/aimalygin/InfiniteCollectionViewFlowLayout/main/stable.gif)

## Demo

![Demo](https://raw.githubusercontent.com/aimalygin/InfiniteCollectionViewFlowLayout/main/demo.gif)

## Usage

Firstly, import `StableCollectionViewLayout`
```swift
import StableCollectionViewLayout
```

Then you should just create and pass `StableCollectionViewLayout` to `UICollectionView` init
```swift
UICollectionView(frame: .zero, collectionViewLayout: StableCollectionViewLayout())
```