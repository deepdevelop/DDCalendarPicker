//
//  ProductTimePicker.h
//  RentVogueiOS
//
//  Created by Shao.Tc on 15/11/6.
//  Copyright © 2015年 Rent Vogue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDCanlendarPickerDelegate <NSObject>

- (void)pickedAtBegin:(NSDate *)beginDate end:(NSDate *)endDate;

@end

@interface DDCanlendarPicker : UIView
@property (strong, readonly, nonatomic) NSDate *beginDate;
@property (strong, readonly, nonatomic) NSDate *endDate;

@property (weak, nonatomic) id<DDCanlendarPickerDelegate> timePickerDelegate;

- (void)setupMutipleDays:(NSArray<NSNumber *> *)days defaultChoose:(NSUInteger)defaultChoose;
@end
