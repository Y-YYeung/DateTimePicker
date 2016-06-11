//
//  WYYDateTime24HourPicker.m
//  WYYDatePicker
//
//  Created by Mon on 6/10/16.
//  Copyright © 2016 YYYeung. All rights reserved.
//

#import "WYYDateTime24HourPicker.h"

@implementation WYYDateTime24HourPicker

#pragma mark - Initilizer
- (instancetype)initWithHeight:(CGFloat)height hourFormat:(HourFormat)hourFormat needConfirmCancel:(BOOL)needConfirmCancel{
    self = [super initWithHeight:height hourFormat:hourFormat needConfirmCancel:needConfirmCancel];
    
    if (self) {
        [self configureDefaultValue];
        [self setupSubviews];
    }
    
    return self;
}

#pragma mark - View Helpers
- (void)setupSubviews{
    [super setupSubviews];
    
    CGFloat y = 0, height = 0;
    if (self.needConfirmCancel) {
        [self addSubview:self.toolBar];
        y = CGRectGetMaxY(self.toolBar.frame);
        height = CGRectGetHeight(self.toolBar.bounds);
    }
    
    self.pickerView.frame = CGRectMake(0, y, CGRectGetWidth(self.pickerView.bounds), CGRectGetHeight(self.bounds) - height);
}

#pragma mark - Helpers

- (NSDate *)generateLocalDateWithDateComponents:(NSDateComponents *)dateComponents{
    NSMutableString *mutableDateFormat = [NSMutableString stringWithString:@"yyyy"];
    [mutableDateFormat appendString:dateComponents.month < 10 ? @"M" : @"MM"];
    [mutableDateFormat appendString:dateComponents.day < 10 ? @"d" : @"dd"];
    [mutableDateFormat appendString:dateComponents.hour < 10 ? @"H" : @"HH"];
    [mutableDateFormat appendString:dateComponents.minute < 10 ? @"m" : @"mm"];
    [mutableDateFormat appendString:dateComponents.second < 10 ? @"s" : @"ss"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = [mutableDateFormat copy];
    
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld", dateComponents.year, dateComponents.month, dateComponents.day, dateComponents.hour, dateComponents.minute, dateComponents.second]];
    self.selectedDate = date;
    
    return date;
}

#pragma mark - Accessors
@synthesize hours = _hours;
- (NSArray *)hours{
    if (!_hours) {
        _hours = [[super class] generateSequenceFrom:0 to:23];
    }
    
    return _hours;
}

@synthesize toolBar = _toolBar;
- (UIToolbar *)toolBar{
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 45.f)];
        _toolBar.clipsToBounds = YES;
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(confirmAction:)];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
#pragma clang diagnostic pop
        
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        _toolBar.items = @[cancelItem, flexibleItem, confirmItem];
    }
    
    return _toolBar;
}

@end
