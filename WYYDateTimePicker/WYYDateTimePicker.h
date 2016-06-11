//
//  WYYAbstractDateTimePicker.h
//  WYYDatePicker
//
//  Created by Mon on 6/10/16.
//  Copyright © 2016 YYYeung. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CurrentCalendar [NSCalendar currentCalendar]

static const CGFloat RowHeight           = 35.f;
static const CGFloat YearComponentWidth  = 68.f;
static const CGFloat TimeSeparatorWidth  = 14.f;
static const CGFloat OtherComponentWidth = 40.f;

typedef enum : NSUInteger {
    HourFormat12,
    HourFormat24,
} HourFormat;

@class WYYDateTimePicker;
@protocol WYYDateTimePickerDelegate <NSObject>

@optional
- (void)dateTimePicker:(WYYDateTimePicker *)dateTimePicker didChangeDateTime:(NSDate *)dateTime;

/**
 *  @author YYYeung
 *
 *  @brief Called when the day/night is switched. Usable when the concrete instance is class of WYYDateTime12HourPicker.
 *
 *  @param dateTimePicker The manipulated DateTimePicker.
 *  @param symbol         A string of 'AM' or 'PM'
 */
- (void)dateTimePicker:(WYYDateTimePicker *)dateTimePicker didChangeAMPM:(NSString *)symbol;

/**
 *  @author YYYeung
 *
 *  @brief Called when the selected dateTime is confirmed.
 *
 *  @param dateTimePicker The manipulated DateTimePicker.
 *  @param dateTime       The selected dateTime when confirming.
 */
- (void)dateTimePicker:(WYYDateTimePicker *)dateTimePicker didConfirmSelectedDateTime:(NSDate *)dateTime;

/**
 *  @author YYYeung
 *
 *  @brief Called when the DateTimePicker is canceled.
 *
 *  @param dateTimePicker The manipulated DateTimePicker.
 *  @param dateTime       The selected dateTime when canceled.
 */
- (void)dateTimePicker:(WYYDateTimePicker *)dateTimePicker didCancelSelectedDateTiem:(NSDate *)dateTime;


@end

@interface WYYDateTimePicker : UIView<UIPickerViewDelegate, UIPickerViewDataSource>

/**
 *  @author YYYeung
 *
 *  @brief Start of the range of year.
 */
@property (nonatomic, assign) NSInteger startYear;

/**
 *  @author YYYeung
 *
 *  @brief End of the range of year.
 */
@property (nonatomic, assign) NSInteger endYear;

/**
 *  @author YYYeung
 *
 *  @brief Indicates the time format is 12-hour or 24-hour.
 *         YES if the format is 24-hour, NO if the format is 12-hour.
 */
@property (nonatomic, assign, readonly) HourFormat hourFormat;

@property (nonatomic, assign) BOOL needConfirmCancel;
@property (nonatomic, weak) id<WYYDateTimePickerDelegate> dateTimeDelegate;

#pragma mark - Data Source
@property (nonatomic, strong) NSArray *years;
@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) NSArray *days;
@property (nonatomic, strong) NSArray *hours;
@property (nonatomic, strong) NSArray *minutes;
@property (nonatomic, strong) NSArray *seconds;

#pragma mark - Controls
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong, readonly) UIToolbar *toolBar;

#pragma mark - Other Properties
@property (nonatomic, strong) NSDate           *selectedDate;
@property (nonatomic, strong) NSDictionary     *titleAttributes;
@property (nonatomic, strong) NSDateComponents *dateComponent;

#pragma mark - Initializer
+ (instancetype)pickerWithHeight:(CGFloat)height hourFormat:(HourFormat)hourFormat needConfirmCancel:(BOOL)needConfirmCancel;
- (instancetype)initWithHeight:(CGFloat)height hourFormat:(HourFormat)hourFormat needConfirmCancel:(BOOL)needConfirmCancel;

#pragma mark - Other Methods
- (void)setupSubviews;
- (void)configureDefaultValue;
- (BOOL)isValidDateInGregorianCalendarWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day;
- (BOOL)dateValidWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day;
- (BOOL)isValidDateInGregorianCalendarWithDateComponents:(NSDateComponents *)dateComponents;
- (NSDate *)generateLocalDateWithDateComponents:(NSDateComponents *)dateComponents;


#pragma mark - Class Methods
+ (NSArray *)generateSequenceFrom:(NSInteger)from to:(NSInteger)to;


@end
