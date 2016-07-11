# TabPageViewController

[![Version](https://img.shields.io/cocoapods/v/TabPageViewController.svg?style=flat)](http://cocoapods.org/pods/TabPageViewController)
[![License](https://img.shields.io/cocoapods/l/TabPageViewController.svg?style=flat)](http://cocoapods.org/pods/TabPageViewController)
[![Platform](https://img.shields.io/cocoapods/p/TabPageViewController.svg?style=flat)](http://cocoapods.org/pods/TabPageViewController)




## Description

<img src="https://raw.githubusercontent.com/wiki/EndouMari/TabPageViewController/images/demo2.gif" width="300" align="right" hspace="20">


TabPageViewController is paging view controller and scroll tab view.

**Screenshot**

Infinity Mode

<img src="https://raw.githubusercontent.com/wiki/EndouMari/TabPageViewController/images/ScreenShot2.png" height="300">


Limited Mode

<img src="https://raw.githubusercontent.com/wiki/EndouMari/TabPageViewController/images/ScreenShot1.png" height="300">



<br clear="right">

## Customization

Use TabPageOption

* fontSize for tab item

`fontSize: CGFloat`

* currentColor for current tab item

`currentColor: UIColor`

* defaultColor for tab item
 
`defaultColor: UIColor`

* tabBarAlpha for tab view

`tabBarAlpha: CGFloat`

* tabHeight for tab view

`tabHeight: CGFloat`

* tabMargin for tab item

`tabMargin: CGFloat`

* tabBackgroundColor for tab view

`tabBackgroundColor: UIColor`

* pageBackgoundColor for tab page viewcontroller 

`pageBackgoundColor: UIColor`

## Usage

`import TabPageViewController` to use TabPageViewController in your file.


### Example 

```swift
let tabPageViewController = TabPageViewController.create()
let vc1 = UIViewController()
let vc2 = UIViewController()

tabPageViewController.tabItems = [(vc1, "First"), (vc2, "Second")]

TabPageOption.currentColor = UIColor.redColor()

```

Infinity Mode 

```swift
let tabPageViewController = TabPageViewController.create()
tabPageViewController.isInfinity = true
```


## Requirements

iOS8+

## Installation

### Using CocoaPods

```ruby
pod "TabPageViewController"
```

### Using Carthage

```ruby
github "EndouMari/TabPageViewController"

```

## Author

EndouMari, endo@vasily.jp

## License

TabPageViewController is available under the MIT license. See the LICENSE file for more info.
