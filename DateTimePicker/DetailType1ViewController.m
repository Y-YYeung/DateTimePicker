//
//  DetailType1ViewController.m
//  DateTimePicker
//
//  Created by Mon on 6/19/16.
//  Copyright © 2016 YYYeung. All rights reserved.
//

#import "DetailType1ViewController.h"

@interface DetailType1ViewController ()

@end

@implementation DetailType1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof(self) weakSelf = self;
    self.dateTimePicker = [WYYDateTimePicker pickerWithHeight:200.f hourFormat:HourFormat12 needConfirmCancel:YES yearRange:WYYMakeYearRange(2012, 2029) initialDate:nil valueDidChanged:^(WYYDateTimePicker *dateTimePicker, NSDate *dateTime) {
        weakSelf.lbValueChangedPrompt.text = [NSString stringWithFormat:@"%@ %@", ValueChangePrompt, [weakSelf.dateFormatter stringFromDate:dateTime]];
    } selectedValueDidConfirm:^(WYYDateTimePicker *dateTimePicker, NSDate *dateTime) {
        weakSelf.lbValueChangedPrompt.text = [NSString stringWithFormat:@"%@ %@", ValueConfirmSelectedPrompt, [weakSelf.dateFormatter stringFromDate:dateTime]];
    } selectedValueDidCancel:^(WYYDateTimePicker *datetimePicker, NSDate *dateTime) {
        weakSelf.lbValueChangedPrompt.text = [NSString stringWithFormat:@"%@ %@", ValueCancelSelectedPrompt, [weakSelf.dateFormatter stringFromDate:dateTime]];
    }];
    
    self.dateTimePicker.dateTimePickerValueAMPMDidChange = ^(WYYDateTimePicker *dateTimePicker, HourPeriod hourPeriod, NSDate *dateTime){
        weakSelf.lbValueChangedPrompt.text = [NSString stringWithFormat:@"%@ %@ \n%ld", ValueConfirmSelectedPrompt, [weakSelf.dateFormatter stringFromDate:dateTime], (HourPeriod)hourPeriod];
    };
    
    [self.view addSubview:self.dateTimePicker];
    self.dateTimePicker.center = self.view.center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
