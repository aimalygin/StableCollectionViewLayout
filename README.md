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