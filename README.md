# SPChart

A simple yet beautifully animated chart library, used in [Spreaker](http://itunes.apple.com/app/id388449677) for iPhone app. 
It is a fork of [PNChart](https://github.com/kevinzhow/PNChart) with a much cleaner and uniform code and more nice features built-in.

In the repository, there is a demo app you can use to see and test specific customizations you would like you have. Have fun with it!

If you **found a bug** or **have a feature request**, please open an issue. 
If you **want to contribute**, submit a pull request.



## Features

* Every chart will draw itself with a nice **animation**.

* **Touch events** are propagated to a delegate object. See `SPChartDelegate` for more details.

* Tons of **customizations** possibles (colors, fonts, visibility of chart axis and labels).

* If a chart is **empty**, an custom text message is automatically displayed over the chart.

Plus, in the pie chart:

* **highlight** a specific piece of the pie


There is also some nice **accessories**:

* `SPChartPopup`, a popup view that you can use to show any custom information once user select a specific point/bar in the chart.



## Limitations

There are only 3 types of chart available: lines, bars and pie.

All charts works with **NSInteger** values.



## Requirements

SPChart requires iOS 6 and ARC. It depends on the following Apple frameworks, which probably are already included in your Xcode project:

* CoreGraphics.framework
* Foundation.framework
* QuartzCore.framework
* UIKit.framework



## Installation

### Cocoapods

[CocoaPods](http://cocoapods.org) is the recommended way to add SPChart to your project.
It is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like SPChart in your projects.

All you have to do is

1. Add a pod entry for SPChart to your Podfile `pod 'SPChart'`
2. Install pod(s) by running `pod install`.
3. Add `#import <SPChart.h>` wherever you need to use one of the supported charts.


### Copy the SPChart folder to your project

and remember to link the required frameworks in your project targets.


## Usage

There is a nice *demo app* in the Example folder.

Each chart has a well documented header file. Please refer to them to understand how to customize them.



## Credits

SPChart is a fork of [PNChart](https://github.com/kevinzhow/PNChart) library, created by [kevinzhow](https://github.com/kevinzhow). Kudos to you, Kevin!



## License

SPChart is available under the MIT license. See [LICENSE](LICENSE) file for more info.

