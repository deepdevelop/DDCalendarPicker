//
//  ProductTimePicker.m
//  RentVogueiOS
//
//  Created by Shao.Tc on 15/11/6.
//  Copyright © 2015年 Rent Vogue. All rights reserved.
//

#import "DDCalendarPicker.h"
#import "UIView+RBAddition.h"

#define kDDCalendarPickerWeekDay @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"]
#define kDDCalendarPickerHexColor(h) [UIColor colorWithRed:((float)((h & 0xFF0000) >> 16))/255.0 green:((float)((h & 0xFF00) >> 8))/255.0 blue:((float)(h & 0xFF))/255.0 alpha:1.0]
static NSInteger const DaySeconds = 24 * 3600;
static NSInteger const DayButtonTag = 700;
static NSInteger const MutiplePickDayButtonTag = 88776;

@interface DDCanlendarPickerIndicator : UIView

+ (instancetype)indicator;

@end

@interface DDCalendarPicker ()
@property (strong, nonatomic) UIScrollView *mutiplePickDaysScrollView;
@property (copy, nonatomic) NSArray<NSNumber *> *mutiplePickDays;

@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UIButton *previousMonthButton;
@property (strong, nonatomic) UIButton *followingMonthButton;
@property (strong, nonatomic) UILabel *yearAndMonthLabel;

@property (strong, nonatomic) UIView *weekView;

@property (strong, nonatomic) UIScrollView *daysScrollView;

@property (strong, nonatomic) NSDate *firstDateOfCurrentMonth;
@property (strong, nonatomic) NSDateComponents *currentMonthComponents;
@property (assign, nonatomic) NSUInteger dayCountOfNextMonth;

@property (weak, nonatomic) UIButton *selectedMutiplePickButton;
@property (assign, nonatomic) NSUInteger selectedMutiplePickDay;
@property (assign, nonatomic) NSUInteger firstDayIndex;

@property (assign, nonatomic) NSRange selectedButtonRange;

@property (strong, readwrite, nonatomic) NSDate *beginDate;
@property (strong, readwrite, nonatomic) NSDate *endDate;

@property (assign, nonatomic) NSUInteger positionIndex;
@property (assign, nonatomic) NSUInteger nextMonthDay;

@property (strong, nonatomic) NSMutableArray<UIView *> *selectedBackgroundViews;

@property (strong, nonatomic) UIView *mutipleDayButtonContainerView;
@property (strong, nonatomic) DDCanlendarPickerIndicator *indicator;

@property (strong, nonatomic) UIImage *previousMonthButtonImage;
@property (strong, nonatomic) UIImage *followingMonthButtonImage;
@end

@implementation DDCalendarPicker

- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupViews];
}

- (void)setupViews {
    [self setupMutiplePickDaysScrollView];
    [self setupTitleView];
    [self setupWeekView];
    [self setupDaysScrollView];
    [self layoutIfNeeded];
}

- (void)setupMutiplePickDaysScrollView {
    self.mutiplePickDaysScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.mutiplePickDaysScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_mutiplePickDaysScrollView];
    
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_mutiplePickDaysScrollView
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self attribute:NSLayoutAttributeTop
                                                                             multiplier:1.f constant:0],
                                                 [NSLayoutConstraint constraintWithItem:_mutiplePickDaysScrollView
                                                                              attribute:NSLayoutAttributeLeading
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self attribute:NSLayoutAttributeLeading
                                                                             multiplier:1.f constant:0],
                                                 [NSLayoutConstraint constraintWithItem:_mutiplePickDaysScrollView
                                                                              attribute:NSLayoutAttributeTrailing
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self attribute:NSLayoutAttributeTrailing
                                                                             multiplier:1.f constant:0],
                           
                                                 ]];
    [_mutiplePickDaysScrollView addConstraint:[NSLayoutConstraint constraintWithItem:_mutiplePickDaysScrollView
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.f constant:50.f]];
}

- (void)setupTitleView {
    self.titleView = [[UIView alloc] init];
    _titleView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_titleView];
    
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_titleView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.mutiplePickDaysScrollView attribute:NSLayoutAttributeBottom
                                                       multiplier:1.f constant:0],
                           [NSLayoutConstraint constraintWithItem:_titleView
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self attribute:NSLayoutAttributeLeading
                                                       multiplier:1.f constant:0],
                           [NSLayoutConstraint constraintWithItem:_titleView
                                                        attribute:NSLayoutAttributeTrailing
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self attribute:NSLayoutAttributeTrailing
                                                       multiplier:1.f constant:0],
                           
                           ]];
    [_titleView addConstraint:[NSLayoutConstraint constraintWithItem:_titleView
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1.f constant:45]];
    
    self.previousMonthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _previousMonthButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_previousMonthButton setBackgroundImage:self.previousMonthButtonImage forState:UIControlStateNormal];
    [_previousMonthButton addTarget:self action:@selector(showPreviousMonth:) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:_previousMonthButton];
    
    [_titleView addConstraints:@[[NSLayoutConstraint constraintWithItem:_previousMonthButton
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_titleView attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.f constant:0],
                           [NSLayoutConstraint constraintWithItem:_previousMonthButton
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_titleView attribute:NSLayoutAttributeLeading
                                                       multiplier:1.f constant:28],
                           ]];
    [_previousMonthButton addConstraints:@[[NSLayoutConstraint constraintWithItem:_previousMonthButton
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1.f constant:23],
                                [NSLayoutConstraint constraintWithItem:_previousMonthButton
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.f constant:23],

     ]];
    
    self.followingMonthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _followingMonthButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_followingMonthButton setBackgroundImage:self.followingMonthButtonImage forState:UIControlStateNormal];
    [_followingMonthButton addTarget:self action:@selector(showFollowingMonth:) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:_followingMonthButton];
    
    [_titleView addConstraints:@[[NSLayoutConstraint constraintWithItem:_followingMonthButton
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_titleView attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.f constant:0],
                                 [NSLayoutConstraint constraintWithItem:_followingMonthButton
                                                              attribute:NSLayoutAttributeTrailing
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_titleView attribute:NSLayoutAttributeTrailing
                                                             multiplier:1.f constant:-28],
                                 ]];
    [_followingMonthButton addConstraints:@[[NSLayoutConstraint constraintWithItem:_followingMonthButton
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.f constant:23],
                                           [NSLayoutConstraint constraintWithItem:_followingMonthButton
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.f constant:23],
                                           
                                           ]];
    
    self.yearAndMonthLabel = [[UILabel alloc] init];
    _yearAndMonthLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月";
    _yearAndMonthLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    _yearAndMonthLabel.font = [UIFont systemFontOfSize:12];
    _yearAndMonthLabel.textColor = [UIColor blackColor];
    _yearAndMonthLabel.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_yearAndMonthLabel];
    
    [_titleView addConstraints:@[[NSLayoutConstraint constraintWithItem:_yearAndMonthLabel
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_titleView attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.f constant:0],
                                 [NSLayoutConstraint constraintWithItem:_yearAndMonthLabel
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_titleView attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.f constant:0],
                                 [NSLayoutConstraint constraintWithItem:_yearAndMonthLabel
                                                              attribute:NSLayoutAttributeLeading
                                                              relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                 toItem:_previousMonthButton attribute:NSLayoutAttributeTrailing
                                                             multiplier:1.f constant:0],
                                 [NSLayoutConstraint constraintWithItem:_yearAndMonthLabel
                                                              attribute:NSLayoutAttributeTrailing
                                                              relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                 toItem:_followingMonthButton attribute:NSLayoutAttributeLeading
                                                             multiplier:1.f constant:0],
                                 ]];
}

- (void)setupWeekView {
    self.weekView = [[UIView alloc] init];
    _weekView.translatesAutoresizingMaskIntoConstraints = NO;
    _weekView.backgroundColor = kDDCalendarPickerHexColor(0xF7F7F7);
    [self addSubview:_weekView];
    
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_weekView
                                                              attribute:NSLayoutAttributeLeading
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self attribute:NSLayoutAttributeLeading
                                                             multiplier:1.f constant:27],
                                 [NSLayoutConstraint constraintWithItem:_weekView
                                                              attribute:NSLayoutAttributeTrailing
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self attribute:NSLayoutAttributeTrailing
                                                             multiplier:1.f constant:-27],
                                 [NSLayoutConstraint constraintWithItem:_weekView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_titleView attribute:NSLayoutAttributeBottom
                                                             multiplier:1.f constant:0],
                           
                                 ]];
    [_weekView addConstraint:[NSLayoutConstraint constraintWithItem:_weekView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.f constant:34]];
    
    for (NSUInteger i = 0; i < 7; i ++) {
        UILabel *label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = kDDCalendarPickerWeekDay[i];
        label.font = [UIFont systemFontOfSize:9];
        label.textColor = kDDCalendarPickerHexColor(0xACACAC);
        [_weekView addSubview:label];
        
        [_weekView addConstraints:@[[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_weekView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.f constant:0],
                                    [NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_weekView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:(2 * i + 1) / 7.f constant:0]]];
    }
}

- (void)setupDaysScrollView {
    if (_daysScrollView) {
        [_daysScrollView removeFromSuperview];
    }
    _daysScrollView = [[UIScrollView alloc] init];
    _daysScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_daysScrollView];
    
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_daysScrollView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_weekView
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.f constant:0],
                           [NSLayoutConstraint constraintWithItem:_daysScrollView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.f constant:0],
                           [NSLayoutConstraint constraintWithItem:_daysScrollView
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeading
                                                       multiplier:1.f constant:27],
                           [NSLayoutConstraint constraintWithItem:_daysScrollView
                                                        attribute:NSLayoutAttributeTrailing
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTrailing
                                                       multiplier:1.f constant:-27]
                           ]];
    
    if (!_currentMonthComponents) {
        NSDate *today = [NSDate date];
        self.currentMonthComponents = [self componentsWithDate:today];
    }
    
    self.firstDayIndex = [self indexOfDate:_firstDateOfCurrentMonth];
    
    NSUInteger currentMonthDays = [self numberOfDaysInMonthOfCurrentDate:_firstDateOfCurrentMonth];
    NSUInteger lastMonthDays = [self numberOfDaysInMonthOfCurrentDate:[self firstDayInLastMonth:_firstDateOfCurrentMonth]];
    
    for (NSUInteger i = _firstDayIndex; i > 0; i --) {
        [self addDayButton:(_firstDayIndex - i) title:[NSString stringWithFormat:@"%ld", (long)(lastMonthDays - i + 1)] isCurrentMonthDay:NO];
    }
    
    self.positionIndex = _firstDayIndex;
    for (NSUInteger i = 0; i < currentMonthDays; i++, _positionIndex++) {
        [self addDayButton:_positionIndex title:[NSString stringWithFormat:@"%ld", (long)(i + 1)] isCurrentMonthDay:YES];
    }
    
    NSUInteger tempPositionIndex = _positionIndex;
    for (NSUInteger i = 0; i < 7 - tempPositionIndex % 7; i ++, _positionIndex++) {
        self.nextMonthDay = i + 1;
        [self addDayButton:_positionIndex title:[NSString stringWithFormat:@"%ld", (long)(_nextMonthDay)] isCurrentMonthDay:NO];
    }
}

- (void)addDayButton:(NSUInteger)index title:(NSString *)title isCurrentMonthDay:(BOOL)isCurrentMonthDay {
    UIButton *dayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dayButton.tag = DayButtonTag + (NSInteger)index;
    [dayButton setTitle:title forState:UIControlStateNormal];
    [dayButton.titleLabel setFont:[UIFont systemFontOfSize:8]];
    [dayButton setTitleColor: isCurrentMonthDay ? [UIColor blackColor] : kDDCalendarPickerHexColor(0xB2B2B2) forState:UIControlStateNormal];
    [dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    if (isCurrentMonthDay) {
        [dayButton addTarget:self action:@selector(pickDayAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    dayButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_daysScrollView addSubview:dayButton];
    
    [_daysScrollView addConstraints:@[[NSLayoutConstraint constraintWithItem:dayButton
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_daysScrollView
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.f constant:35.f * (index / 7)],
                                      [NSLayoutConstraint constraintWithItem:dayButton
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_daysScrollView
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:(2 * (index % 7) + 1) / 7.f constant:0],
                                      [NSLayoutConstraint constraintWithItem:dayButton
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_daysScrollView
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:1 / 7.f constant:0]
                                      ]];
    
    [dayButton addConstraint:[NSLayoutConstraint constraintWithItem:dayButton
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.f constant:35]
     ];
    
    _daysScrollView.contentSize = CGSizeMake(0, 35.f * (index / 7 + 1));
}

- (void)setupMutipleDays:(NSArray<NSNumber *> *)days defaultChoose:(NSUInteger)defaultChoose {
    if ([days isEqualToArray:_mutiplePickDays]) {
        return;
    }
    
    if (!_mutipleDayButtonContainerView) {
        self.mutipleDayButtonContainerView = [UIView new];
        [_mutipleDayButtonContainerView rb_addBorder:BorderSide_Bottom width:2.f color:kDDCalendarPickerHexColor(0xEDEDED)];
        [_mutiplePickDaysScrollView addSubview:_mutipleDayButtonContainerView];
    }
    
    _mutipleDayButtonContainerView.frame = CGRectMake(0, 0, MAX(CGRectGetWidth(_mutiplePickDaysScrollView.frame), 20 + 67 * days.count), CGRectGetHeight(_mutiplePickDaysScrollView.frame));
    
    self.mutiplePickDays = days;
    NSUInteger i = 0;
    for (NSNumber *day in days) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[NSString stringWithFormat:@"%@天", day] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.layer.cornerRadius = 13.f;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(selectedMutiplePickDay:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = MutiplePickDayButtonTag + (NSInteger)i;
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [_mutipleDayButtonContainerView addSubview:button];
        
        [_mutipleDayButtonContainerView addConstraints:@[[NSLayoutConstraint constraintWithItem:button
                                                                                      attribute:NSLayoutAttributeCenterY
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:_mutipleDayButtonContainerView
                                                                                      attribute:NSLayoutAttributeCenterY
                                                                                     multiplier:1 constant:0],
                                                         [NSLayoutConstraint constraintWithItem:button
                                                                                      attribute:NSLayoutAttributeLeading
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:_mutipleDayButtonContainerView
                                                                                      attribute:NSLayoutAttributeLeading
                                                                                     multiplier:1.f constant:67 * i + 20]]];
        [button addConstraints:@[[NSLayoutConstraint constraintWithItem:button
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.f constant:47],
                                 [NSLayoutConstraint constraintWithItem:button
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.f constant:26]]];

        if (i == defaultChoose) {
            [_mutipleDayButtonContainerView layoutIfNeeded];
            [self selectedMutiplePickDay:button];
        }
        
        i++;
    }
}

#pragma mark - Actions

- (void)showPreviousMonth:(UIButton *)sender {
    NSDateComponents *tempComponents = [_currentMonthComponents copy];
    if (tempComponents.month > 1) {
        tempComponents.month -= 1;
    } else {
        tempComponents.month = 12;
        tempComponents.year -= 1;
    }
    self.currentMonthComponents = [tempComponents copy];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月";
    _yearAndMonthLabel.text = [dateFormatter stringFromDate:_firstDateOfCurrentMonth];
    [self setupDaysScrollView];
}

- (void)showFollowingMonth:(UIButton *)sender {
    NSDateComponents *tempComponents = [_currentMonthComponents copy];
    if (tempComponents.month == 12) {
        tempComponents.month = 1;
        tempComponents.year += 1;
    } else {
        tempComponents.month += 1;
    }
    self.currentMonthComponents = [tempComponents copy];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月";
    _yearAndMonthLabel.text = [dateFormatter stringFromDate:_firstDateOfCurrentMonth];
    [self setupDaysScrollView];
}

- (void)selectedMutiplePickDay:(UIButton *)sender {
    [self unselectedMutiplePickButton:_selectedMutiplePickButton];
    [sender setSelected:YES];
    
    sender.backgroundColor = kDDCalendarPickerHexColor(0xB37E79);
    self.selectedMutiplePickButton = sender;
    
    self.indicator.frame = CGRectMake(0, CGRectGetMaxY(sender.frame) + 3.5f, CGRectGetWidth(self.indicator.frame), CGRectGetHeight(self.indicator.frame));
    self.indicator.center = CGPointMake(sender.center.x, self.indicator.center.y);
    
    [_mutiplePickDaysScrollView layoutIfNeeded];
    
    NSUInteger index = (NSUInteger)sender.tag - MutiplePickDayButtonTag;
    self.selectedMutiplePickDay = [_mutiplePickDays[index] unsignedIntegerValue];
}

- (void)unselectedMutiplePickButton:(UIButton *)button {
    [_selectedMutiplePickButton setSelected:NO];
    button.backgroundColor = [UIColor clearColor];
}

- (void)pickDayAction:(UIButton *)sender {
    // Move all selected background view before new pick
    [self.selectedBackgroundViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    // Set all selected button to unselected
    // Change title color from white to black
    for (NSUInteger i = 0; i < _selectedButtonRange.length; i ++) {
        NSInteger tag = (NSInteger)(_selectedButtonRange.location + i) + DayButtonTag;
        UIButton *dayButton = (UIButton *)[_daysScrollView viewWithTag:tag];
        [dayButton setSelected:NO];
    }
    
    // First date index
    NSUInteger beginDateIndex = (NSUInteger)sender.tag - DayButtonTag;
    self.selectedButtonRange = NSMakeRange(beginDateIndex, _selectedMutiplePickDay);
    
    NSUInteger dayAfterFirstDay = beginDateIndex - _firstDayIndex;
    self.beginDate = [_firstDateOfCurrentMonth dateByAddingTimeInterval:dayAfterFirstDay * DaySeconds];
    self.endDate = [self.beginDate dateByAddingTimeInterval:(_selectedMutiplePickDay - 1) * DaySeconds];
    
    if ([_timePickerDelegate respondsToSelector:@selector(pickedAtBegin:end:)]) {
        [_timePickerDelegate pickedAtBegin:_beginDate end:_endDate];
    }
    
    NSUInteger endDateIndex = beginDateIndex + _selectedMutiplePickDay - 1;
    NSUInteger beginRow = beginDateIndex % 7;
    NSUInteger endRow   = endDateIndex % 7;
    NSUInteger beginLine = beginDateIndex / 7;
    NSUInteger endLine   = endDateIndex / 7;
    
    NSUInteger lineCount = endLine - beginLine + 1;
    
    for (NSUInteger i = 0; i < lineCount; i ++) {
        // When line is not in view
        // Create a new line
        if ((beginLine + i) * 7 >= _positionIndex) {
            for (NSUInteger j = 0; j < 7; j ++, _positionIndex++) {
                self.nextMonthDay++;
                [self addDayButton:_positionIndex title:[NSString stringWithFormat:@"%lu", (unsigned long)_nextMonthDay] isCurrentMonthDay:NO];
            }
            [_daysScrollView layoutIfNeeded];
            _daysScrollView.contentOffset = CGPointMake(0, _daysScrollView.contentSize.height - CGRectGetHeight(_daysScrollView.frame));
        }
        
        UIView *selectedBackgroundView = [self selectedBackgroundView];
        if (i == 0) {
            // begin to 7
            UIButton *firstButton = sender;
            NSInteger endButtonTag = sender.tag + 7 - beginRow - 1;
            if (endButtonTag > sender.tag + _selectedMutiplePickDay - 1) {
                endButtonTag = sender.tag + _selectedMutiplePickDay - 1;
            }
            UIButton *endButton = (UIButton *)[_daysScrollView viewWithTag:endButtonTag];
            selectedBackgroundView.frame = CGRectMake(CGRectGetMinX(firstButton.frame), CGRectGetMinY(firstButton.frame), CGRectGetMaxX(endButton.frame) - CGRectGetMinX(firstButton.frame), CGRectGetHeight(firstButton.frame));
        } else if (i == lineCount - 1) {
            // 0 to end
            UIButton *endButton = (UIButton *)[_daysScrollView viewWithTag:endDateIndex + DayButtonTag];
            UIButton *firstButton = (UIButton *)[_daysScrollView viewWithTag:endButton.tag - endRow];
            selectedBackgroundView.frame = CGRectMake(CGRectGetMinX(firstButton.frame), CGRectGetMinY(firstButton.frame), CGRectGetMaxX(endButton.frame), CGRectGetHeight(firstButton.frame));
        } else {
            // 0 to 7
            UIButton *firstButton = (UIButton *)[_daysScrollView viewWithTag:(beginLine + i) * 7 + DayButtonTag];
            UIButton *endButton = (UIButton *)[_daysScrollView viewWithTag:firstButton.tag + 6];
            selectedBackgroundView.frame = CGRectMake(CGRectGetMinX(firstButton.frame), CGRectGetMinY(firstButton.frame), CGRectGetMaxX(endButton.frame), CGRectGetHeight(firstButton.frame));
        }
        [_daysScrollView addSubview:selectedBackgroundView];
        [_daysScrollView sendSubviewToBack:selectedBackgroundView];
        [self.selectedBackgroundViews addObject:selectedBackgroundView];
    }
    
    for (NSUInteger i = 0; i < _selectedButtonRange.length; i ++) {
        NSInteger tag = (NSInteger)(_selectedButtonRange.location + i) + DayButtonTag;
        UIButton *dayButton = (UIButton *)[_daysScrollView viewWithTag:tag];
        [dayButton setSelected:YES];
    }
}

#pragma mark - Setter

- (void)setCurrentMonthComponents:(NSDateComponents *)currentMonthComponents {
    _currentMonthComponents = currentMonthComponents;
    NSDateComponents *nextMonthComponents = [_currentMonthComponents copy];
    if (nextMonthComponents.month == 12) {
        nextMonthComponents.year += 1;
        nextMonthComponents.month = 1;
    } else {
        nextMonthComponents.month += 1;
    }
    
    NSDate *firstDataOfNextMonth = [self firstDateInComponents:nextMonthComponents];
    self.dayCountOfNextMonth = [self numberOfDaysInMonthOfCurrentDate:firstDataOfNextMonth];
    self.firstDateOfCurrentMonth = [self firstDateInComponents:_currentMonthComponents];
}

- (void)setNextMonthDay:(NSUInteger)nextMonthDay {
    if (nextMonthDay > _dayCountOfNextMonth) {
        nextMonthDay = 1;
    }
    _nextMonthDay = nextMonthDay;
}

#pragma mark - Getter

- (DDCanlendarPickerIndicator *)indicator {
    if (!_indicator) {
        _indicator = [DDCanlendarPickerIndicator indicator];
        [_mutipleDayButtonContainerView addSubview:_indicator];
    }
    return _indicator;
}

- (UIImage *)previousMonthButtonImage {
    if (!_previousMonthButtonImage) {
        _previousMonthButtonImage = [self drawPreviousMonthButtonImage];
    }
    
    return _previousMonthButtonImage;
}

- (UIImage *)followingMonthButtonImage {
    if (!_followingMonthButtonImage) {
        _followingMonthButtonImage = [self drawFollowingMonthButtonImage];
    }
    
    return _followingMonthButtonImage;
}

- (UIView *)selectedBackgroundView {
    UIView *view = [UIView new];
    view.backgroundColor = kDDCalendarPickerHexColor(0xB37E79);
    view.layer.cornerRadius = 35 / 2.f;
    view.layer.masksToBounds = YES;
    return view;
}

- (NSMutableArray<UIView *> *)selectedBackgroundViews {
    if (!_selectedBackgroundViews) {
        _selectedBackgroundViews = [NSMutableArray array];
    }
    
    return _selectedBackgroundViews;
}

#pragma mark - Date

- (NSDateComponents *)componentsWithDate:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    return comps;
}

/**
 *  index in week
 *
 *  @param date current date
 *
 *  @return index in week
 */
- (NSUInteger)indexOfDate:(NSDate *)date {
    NSDateComponents *comps = [self componentsWithDate:date];
    return (NSUInteger)comps.weekday - 1;
}

- (NSDate *)firstDateInComponents:(NSDateComponents *)components {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *tempComponents = [components copy];
    tempComponents.day = 1;
    return [calendar dateFromComponents:tempComponents];
}

- (NSDate *)firstDayInLastMonth:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    if (components.month > 1) {
        components.month -= 1;
    } else {
        components.month = 12;
        components.year -= 1;
    }
    components.day = 1;
    return [calendar dateFromComponents:components];
}

- (NSUInteger)numberOfDaysInMonthOfCurrentDate:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange days = [calendar rangeOfUnit:NSCalendarUnitDay
                                  inUnit:NSCalendarUnitMonth
                                 forDate:date];
    return days.length;
}

#pragma mark - Draw

- (UIImage *)drawPreviousMonthButtonImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(25.f, 25.f), NO, [UIScreen mainScreen].scale);
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 0.844 green: 0.844 blue: 0.844 alpha: 1];
    UIColor* strokeColor = [UIColor colorWithRed: 0.845 green: 0.845 blue: 0.845 alpha: 1];
    
    //// product_time_picker_previous_button.pdf Group
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(14.58, 7.75)];
        [bezierPath addLineToPoint: CGPointMake(9.39, 12.5)];
        [bezierPath addLineToPoint: CGPointMake(14.58, 17.25)];
        [bezierPath addCurveToPoint: CGPointMake(14.58, 17.87) controlPoint1: CGPointMake(14.75, 17.42) controlPoint2: CGPointMake(14.75, 17.7)];
        [bezierPath addCurveToPoint: CGPointMake(13.96, 17.87) controlPoint1: CGPointMake(14.41, 18.04) controlPoint2: CGPointMake(14.13, 18.04)];
        [bezierPath addLineToPoint: CGPointMake(8.49, 12.86)];
        [bezierPath addCurveToPoint: CGPointMake(8.41, 12.83) controlPoint1: CGPointMake(8.46, 12.84) controlPoint2: CGPointMake(8.43, 12.85)];
        [bezierPath addCurveToPoint: CGPointMake(8.29, 12.5) controlPoint1: CGPointMake(8.32, 12.74) controlPoint2: CGPointMake(8.28, 12.62)];
        [bezierPath addCurveToPoint: CGPointMake(8.41, 12.17) controlPoint1: CGPointMake(8.28, 12.38) controlPoint2: CGPointMake(8.32, 12.26)];
        [bezierPath addCurveToPoint: CGPointMake(8.49, 12.14) controlPoint1: CGPointMake(8.43, 12.15) controlPoint2: CGPointMake(8.46, 12.16)];
        [bezierPath addLineToPoint: CGPointMake(13.96, 7.13)];
        [bezierPath addCurveToPoint: CGPointMake(14.58, 7.13) controlPoint1: CGPointMake(14.13, 6.96) controlPoint2: CGPointMake(14.41, 6.96)];
        [bezierPath addCurveToPoint: CGPointMake(14.58, 7.75) controlPoint1: CGPointMake(14.75, 7.3) controlPoint2: CGPointMake(14.75, 7.57)];
        [bezierPath addLineToPoint: CGPointMake(14.58, 7.75)];
        [bezierPath closePath];
        bezierPath.usesEvenOddFillRule = YES;
        
        [fillColor setFill];
        [bezierPath fill];
        
        
        //// Oval Drawing
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(1, 1, 23, 23)];
        [strokeColor setStroke];
        ovalPath.lineWidth = 1;
        [ovalPath stroke];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)drawFollowingMonthButtonImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(25.f, 25.f), NO, [UIScreen mainScreen].scale);
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 0.844 green: 0.844 blue: 0.844 alpha: 1];
    UIColor* strokeColor = [UIColor colorWithRed: 0.845 green: 0.845 blue: 0.845 alpha: 1];
    
    //// product_time_picker_following_button.pdf Group
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(10.42, 7.75)];
        [bezierPath addLineToPoint: CGPointMake(15.61, 12.5)];
        [bezierPath addLineToPoint: CGPointMake(10.42, 17.25)];
        [bezierPath addCurveToPoint: CGPointMake(10.42, 17.87) controlPoint1: CGPointMake(10.25, 17.42) controlPoint2: CGPointMake(10.25, 17.7)];
        [bezierPath addCurveToPoint: CGPointMake(11.04, 17.87) controlPoint1: CGPointMake(10.59, 18.04) controlPoint2: CGPointMake(10.87, 18.04)];
        [bezierPath addLineToPoint: CGPointMake(16.51, 12.86)];
        [bezierPath addCurveToPoint: CGPointMake(16.59, 12.83) controlPoint1: CGPointMake(16.54, 12.84) controlPoint2: CGPointMake(16.57, 12.85)];
        [bezierPath addCurveToPoint: CGPointMake(16.71, 12.5) controlPoint1: CGPointMake(16.68, 12.74) controlPoint2: CGPointMake(16.72, 12.62)];
        [bezierPath addCurveToPoint: CGPointMake(16.59, 12.17) controlPoint1: CGPointMake(16.72, 12.38) controlPoint2: CGPointMake(16.68, 12.26)];
        [bezierPath addCurveToPoint: CGPointMake(16.51, 12.14) controlPoint1: CGPointMake(16.57, 12.15) controlPoint2: CGPointMake(16.54, 12.16)];
        [bezierPath addLineToPoint: CGPointMake(11.04, 7.13)];
        [bezierPath addCurveToPoint: CGPointMake(10.42, 7.13) controlPoint1: CGPointMake(10.87, 6.96) controlPoint2: CGPointMake(10.59, 6.96)];
        [bezierPath addCurveToPoint: CGPointMake(10.42, 7.75) controlPoint1: CGPointMake(10.25, 7.3) controlPoint2: CGPointMake(10.25, 7.57)];
        [bezierPath addLineToPoint: CGPointMake(10.42, 7.75)];
        [bezierPath closePath];
        bezierPath.usesEvenOddFillRule = YES;
        
        [fillColor setFill];
        [bezierPath fill];
        
        
        //// Oval Drawing
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(1, 1, 23, 23)];
        [strokeColor setStroke];
        ovalPath.lineWidth = 1;
        [ovalPath stroke];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



@end

@implementation DDCanlendarPickerIndicator

+ (instancetype)indicator {
    DDCanlendarPickerIndicator *indicator = [[DDCanlendarPickerIndicator alloc] initWithFrame:CGRectMake(0, 0, 14, 9)];
    indicator.backgroundColor = [UIColor clearColor];
    return indicator;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor* strokeColor = [UIColor colorWithRed: 0.91 green: 0.91 blue: 0.91 alpha: 1];
    UIColor* fillColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    {
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(0, height)];
        [bezierPath addLineToPoint: CGPointMake(width / 2.f, 0)];
        [bezierPath addLineToPoint: CGPointMake(width, height)];
        bezierPath.lineCapStyle = kCGLineCapSquare;
        
        [strokeColor setStroke];
        bezierPath.lineWidth = 1;
        [bezierPath stroke];
        
        
        {
            CGContextSaveGState(context);
            CGContextBeginTransparencyLayer(context, NULL);

            UIBezierPath* clipPath = UIBezierPath.bezierPath;
            [clipPath moveToPoint: CGPointMake(width / 2.f, 0.5)];
            [clipPath addLineToPoint: CGPointMake(width, height + 0.5f)];
            [clipPath addLineToPoint: CGPointMake(0, height + 0.5f)];
            [clipPath addLineToPoint: CGPointMake(width / 2.f, 0 + 0.5f)];
            [clipPath closePath];
            clipPath.usesEvenOddFillRule = YES;
            
            [clipPath addClip];
            
            UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect))];
            [fillColor setFill];
            [rectanglePath fill];
            
            CGContextEndTransparencyLayer(context);
            CGContextRestoreGState(context);
        }
    }
}

@end
