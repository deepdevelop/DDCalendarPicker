//
//  ViewController.m
//  DDCalendarPicker
//
//  Created by Shao.Tc on 15/11/26.
//  Copyright © 2015年 DeepDeveloper. All rights reserved.
//

#import "ViewController.h"
#import "DDCanlendarPicker.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet DDCanlendarPicker *canlendarPicker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_canlendarPicker setupMutipleDays:@[@4, @8, @20, @100] defaultChoose:0];
    
    DDCanlendarPicker *picker2 = [[DDCanlendarPicker alloc] initWithFrame:CGRectMake(0, 400, CGRectGetWidth([UIScreen mainScreen].bounds), 312)];
    [picker2 setupMutipleDays:@[@4, @8, @20, @100] defaultChoose:0];
    [self.view addSubview:picker2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
