//
//  ViewController.m
//  DateTimePicker
//
//  Created by Mon on 6/11/16.
//  Copyright © 2016 YYYeung. All rights reserved.
//

#import "ViewController.h"
#import "WYYDateTimePicker.h"

@interface ViewController ()<WYYDateTimePickerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    WYYDateTimePicker *dateTimePicker = [WYYDateTimePicker pickerWithHeight:200.f hourFormat:HourFormat24 needConfirmCancel:NO];
    dateTimePicker.startYear = 1970;
    dateTimePicker.endYear = 2029;
    dateTimePicker.dateTimeDelegate = self;
    [self.view addSubview:dateTimePicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate
- (void)dateTimePicker:(WYYDateTimePicker *)dateTimePicker didChangeDateTime:(NSDate *)dateTime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSLog(@"%@", [dateFormatter stringFromDate:dateTime]);
}

- (void)dateTimePicker:(WYYDateTimePicker *)dateTimePicker didConfirmSelectedDateTime:(NSDate *)dateTime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSLog(@"%@", [dateFormatter stringFromDate:dateTime]);
}

- (void)dateTimePicker:(WYYDateTimePicker *)dateTimePicker didCancelSelectedDateTiem:(NSDate *)dateTime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSLog(@"%@", [dateFormatter stringFromDate:dateTime]);
}

@end
