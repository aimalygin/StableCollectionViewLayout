# InfiniteCollectionViewFlowLayout

This layout adjusts a content offset if the collection view is updated. You can insert, delete or reload items and `InfiniteCollectionViewFlowLayout` will take care of the content offset.

## Demo

![Demo](https://raw.githubusercontent.com/aimalygin/InfiniteCollectionViewFlowLayout/main/demo.gif)

## Usage

Firstly, import `InfiniteCollectionViewFlowLayout`
```swift
import InfiniteCollectionViewFlowLayout
```

Then you should just create and pass `InfiniteCollectionViewFlowLayout` to `UICollectionView` init
```swift
UICollectionView(frame: .zero, collectionViewLayout: InfiniteCollectionViewFlowLayout())
```