//
//  ViewController.m
//  DDCalendarPicker
//
//  Created by Shao.Tc on 15/11/26.
//  Copyright © 2015年 DeepDeveloper. All rights reserved.
//

#import "ViewController.h"
#import "DDCalendarPicker.h"

@interface ViewController () <DDCalendarPickerDelegate>
@property (weak, nonatomic) IBOutlet DDCalendarPicker *calendarPicker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_calendarPicker setupMutipleDays:@[@4, @8, @20, @100] defaultChoose:0];
    _calendarPicker.timePickerDelegate = self;
    
    DDCalendarPicker *picker2 = [[DDCalendarPicker alloc] initWithFrame:CGRectMake(0, 400, CGRectGetWidth([UIScreen mainScreen].bounds), 312)];
    [picker2 setupMutipleDays:@[@4, @8, @20, @100] defaultChoose:0];
    [self.view addSubview:picker2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DDCalendarPicker Delegate

- (void)pickedAtBegin:(NSDate *)beginDate end:(NSDate *)endDate {
    NSLog(@"picked at begin %@, end %@", beginDate, endDate);
}

@end
