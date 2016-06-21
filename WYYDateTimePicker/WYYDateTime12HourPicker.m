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
@property (nonatomic, assign) HourPeriod hourPeriod;

@end

@implementation WYYDateTime12HourPicker

#pragma mark - Initilizer
- (instancetype)initWithHeight:(CGFloat)height
                    hourFormat:(HourFormat)hourFormat
             needConfirmCancel:(BOOL)needConfirmCancel
                     yearRange:(WYYYearRange)range
                   initialDate:(NSDate *)initialDate{
    NSAssert(hourFormat == HourFormat12, @"Hour format does not match class %@", [self class]);
    
    self = [super initWithHeight:height hourFormat:HourFormat12 needConfirmCancel:needConfirmCancel yearRange:range initialDate:initialDate];
    
    if (self) {
        [self configureDefaultValue];
        [self setupSubviews];
        [self configureInitialDate:initialDate];
    }
    
    return self;
}

- (instancetype)initWithHeight:(CGFloat)height
                    hourFormat:(HourFormat)hourFormat
             needConfirmCancel:(BOOL)needConfirmCancel
                     yearRange:(WYYYearRange)range
                   initialDate:(NSDate *)initialDate
               valueDidChanged:(DateTimePickerValueDidChange)valueDidChange
       selectedValueDidConfirm:(DateTimePickerSelectedValueDidConfirm)selectedValueDidConfirm
        selectedValueDidCancel:(DateTimePickerSelectedValueDidCancel)selectedValueDidCancel{
    NSAssert(hourFormat == HourFormat12, @"Hour format does not match class %@", [self class]);
    
    self = [super initWithHeight:height hourFormat:HourFormat12 needConfirmCancel:needConfirmCancel yearRange:range initialDate:initialDate valueDidChanged:valueDidChange selectedValueDidConfirm:selectedValueDidConfirm selectedValueDidCancel:selectedValueDidCancel];
    
    if (self) {
        [self configureDefaultValue];
        [self setupSubviews];
        [self configureInitialDate:initialDate];
    }
    
    return self;
}

#pragma mark - View Helpers
- (void)setupSubviews{
    [super setupSubviews];
    
    [self addSubview:self.toolBar];
    self.pickerView.frame = CGRectMake(0, CGRectGetMaxY(self.toolBar.frame), CGRectGetWidth(self.pickerView.bounds), CGRectGetHeight(self.bounds) - CGRectGetHeight(self.toolBar.bounds));
}

#pragma mark - Helpers

+ (NSUInteger)indexOfElement:(NSInteger)element inDateComponent:(NSArray *)component{
    NSUInteger index = [component indexOfObject:[NSString stringWithFormat:@"%ld", (long)element]];
    NSAssert(index != NSNotFound, @"Can not index initial date componet");
    
    return index;
}

- (void)configureInitialDate:(NSDate *)initialDate{
    
    NSUInteger yearIndex   = 0;
    NSUInteger monthIndex  = 0;
    NSUInteger dayIndex    = 0;
    NSUInteger hourIndex   = 0;
    NSUInteger minuteIndex = 0;
    NSUInteger secondIndex = 0;
    
    if (initialDate) {
        NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        self.dateComponent = [CurrentCalendar components:unitFlags fromDate:initialDate];
        
        yearIndex  = [[self class] indexOfElement:self.dateComponent.year inDateComponent:self.years];
        monthIndex = [[self class] indexOfElement:self.dateComponent.month inDateComponent:self.months];
        dayIndex   = [[self class] indexOfElement:self.dateComponent.day inDateComponent:self.days];
        
        if (self.dateComponent.hour > 11) {
            self.dateComponent.hour -= 12;
            self.hourPeriod = HourPeriodNight;
        } else {
            self.hourPeriod = HourPeriodDay;
        }
        
        hourIndex  = [[self class] indexOfElement:self.dateComponent.hour inDateComponent:self.hours];
        minuteIndex = [[self class] indexOfElement:self.dateComponent.minute inDateComponent:self.minutes];
        secondIndex = [[self class] indexOfElement:self.dateComponent.second inDateComponent:self.seconds];
        
        self.selectedDate = initialDate;
    } else {
        self.dateComponent.year   = [self.years[yearIndex] integerValue];
        self.dateComponent.month  = [self.months[monthIndex] integerValue];
        self.dateComponent.day    = [self.days[dayIndex] integerValue];
        self.dateComponent.hour   = [self.hours[hourIndex] integerValue];
        self.dateComponent.minute = [self.minutes[minuteIndex] integerValue];
        self.dateComponent.second = [self.seconds[secondIndex] integerValue];
        
        self.selectedDate = [self generateLocalDateWithDateComponents:self.dateComponent];
    }
    
    [self.pickerView selectRow:yearIndex inComponent:0 animated:YES];
    [self.pickerView selectRow:monthIndex inComponent:1 animated:YES];
    [self.pickerView selectRow:dayIndex inComponent:2 animated:YES];
    [self.pickerView selectRow:hourIndex inComponent:3 animated:YES];
    [self.pickerView selectRow:minuteIndex inComponent:5 animated:YES];
    [self.pickerView selectRow:secondIndex inComponent:7 animated:YES];
    [self.dayNightSymbolSeg setSelectedSegmentIndex:self.hourPeriod];
}

- (void)dayNightSwitchAction:(UISegmentedControl *)sender{
    
    self.hourPeriod = (HourPeriod)sender.selectedSegmentIndex;
    [self pickerView:self.pickerView didSelectRow:0 inComponent:3];
    if ([self.dateTimeDelegate respondsToSelector:@selector(dateTimePicker:didChangeAMPM:dateTime:)]) {
        [self.dateTimeDelegate dateTimePicker:self didChangeAMPM:self.hourPeriod dateTime:self.selectedDate];
    } else if (self.dateTimePickerValueAMPMDidChange) {
        self.dateTimePickerValueAMPMDidChange(self, self.hourPeriod, self.selectedDate);
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
    
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld%@", (long)dateComponents.year, (long)dateComponents.month, (long)dateComponents.day, (long)dateComponents.hour, (long)dateComponents.minute, (long)dateComponents.second, self.dayNightSymbols[self.hourPeriod]]];
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
