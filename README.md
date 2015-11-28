# DDCalendarPicker
---
DDCalendarPicker can be used to select mutiple days.

##Installation
---

####CocoaPods

    pod 'DDCalendarPicker'  

##Usage
---
You can use directly in Storyboard or use code to create

	DDCalendarPicker *picker = [[DDCalendarPicker alloc] initWithFrame:frame];
    [picker setupMutipleDays:@[@4, @8, @20, @100] defaultChoose:0];
    [self.view addSubview:picker];
##Dependency
---

- RBBorderView
 
##Author
---

EscapedDog, snowmoonking@gmail.com

##License
---

DDCalendarPicker is available under the MIT license. See the LICENSE file for more info.