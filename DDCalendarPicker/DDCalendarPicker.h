//
//  ProductTimePicker.h
//  RentVogueiOS
//
//  Created by Shao.Tc on 15/11/6.
//  Copyright © 2015年 Rent Vogue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDCalendarPickerDelegate <NSObject>

- (void)pickedAtBegin:(NSDate *)beginDate end:(NSDate *)endDate;

@end

@interface DDCalendarPicker : UIView
@property (strong, readonly, nonatomic) NSDate *beginDate;
@property (strong, readonly, nonatomic) NSDate *endDate;

@property (weak, nonatomic) id<DDCalendarPickerDelegate> timePickerDelegate;

- (void)setupMutipleDays:(NSArray<NSNumber *> *)days defaultChoose:(NSUInteger)defaultChoose;
@end
