//
//  WYYDateTime12Hour.m
//  WYYDatePicker
//
//  Created by Mon on 6/10/16.
//  Copyright © 2016 YYYeung. All rights reserved.
//

#import "WYYDateTime12HourPicker.h"

@interface WYYDateTime12HourPicker ()

@property (nonatomic, strong) UISegmentedControl *dayNightSymbolSeg;
@property (nonatomic, strong) NSArray *dayNightSymbols;

@end

@implementation WYYDateTime12HourPicker

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
    
    [self addSubview:self.toolBar];
    self.pickerView.frame = CGRectMake(0, CGRectGetMaxY(self.toolBar.frame), CGRectGetWidth(self.pickerView.bounds), CGRectGetHeight(self.bounds) - CGRectGetHeight(self.toolBar.bounds));
    
    [self.dayNightSymbolSeg setSelectedSegmentIndex:0];
}

#pragma mark - Helpers

- (void)dayNightSwitchAction:(UISegmentedControl *)sender{
    
    [self pickerView:self.pickerView didSelectRow:0 inComponent:3];
    
    if ([self.dateTimeDelegate respondsToSelector:@selector(dateTimePicker:didChangeAMPM:)]) {
        NSString *symbol = self.dayNightSymbols[sender.selectedSegmentIndex];
        [self.dateTimeDelegate dateTimePicker:self didChangeAMPM:symbol];
    }
}

- (NSDate *)generateLocalDateWithDateComponents:(NSDateComponents *)dateComponents{
    NSMutableString *mutableDateFormat = [NSMutableString stringWithString:@"yyyy"];
    [mutableDateFormat appendString:dateComponents.month < 10 ? @"M" : @"MM"];
    [mutableDateFormat appendString:dateComponents.day < 10 ? @"d" : @"dd"];
    [mutableDateFormat appendString:dateComponents.hour < 10 ? @"h" : @"hh"];
    [mutableDateFormat appendString:dateComponents.minute < 10 ? @"m" : @"mm"];
    [mutableDateFormat appendString:dateComponents.second < 10 ? @"s" : @"ss"];
    [mutableDateFormat appendString:@"a"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = [mutableDateFormat copy];
    
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld%@", dateComponents.year, dateComponents.month, dateComponents.day, dateComponents.hour, dateComponents.minute, dateComponents.second, self.dayNightSymbols[self.dayNightSymbolSeg.selectedSegmentIndex]]];
    self.selectedDate = date;
    
    return date;
}

#pragma mark - Accessors
@synthesize hours = _hours;
- (NSArray *)hours{
    if (!_hours) {
        _hours = [[super class] generateSequenceFrom:0 to:11];
    }
    
    return _hours;
}

- (NSArray *)dayNightSymbols{
    if (!_dayNightSymbols) {
        _dayNightSymbols = @[[CurrentCalendar AMSymbol], [CurrentCalendar PMSymbol]];
    }
    
    return _dayNightSymbols;
}

- (UISegmentedControl *)dayNightSymbolSeg{
    if (!_dayNightSymbolSeg) {
        _dayNightSymbolSeg = [[UISegmentedControl alloc] initWithItems:self.dayNightSymbols];
        [_dayNightSymbolSeg addTarget:self action:@selector(dayNightSwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _dayNightSymbolSeg;
}

@synthesize toolBar = _toolBar;
- (UIToolbar *)toolBar{
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 45.f)];
        _toolBar.clipsToBounds = YES;
        
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *segmentItem = [[UIBarButtonItem alloc] initWithCustomView:self.dayNightSymbolSeg];
        
        if (self.needConfirmCancel) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(confirmAction:)];
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
#pragma clang diagnostic pop
            
            _toolBar.items = @[cancelItem, flexibleItem, segmentItem, flexibleItem, confirmItem];
        } else {
            _toolBar.items = @[flexibleItem, segmentItem, flexibleItem];
        }
        
    }
    
    return _toolBar;
}

@end
