//
//  ViewController.m
//  naozhong
//
//  Created by liyang on 2017/5/20.
//  Copyright © 2017年 liyang. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface ViewController ()

//时间选择器
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置闹钟不能小于当前时间
    self.datePicker.minimumDate = [NSDate date];
}

- (IBAction)clickBtn:(UIButton *)sender {
    
    [self addLocalNotification];
}



#pragma mark - 增加本地通知

- (void) addLocalNotification{
    // 使用iOS10新的本地推送类来管理通知
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:@"脑中通知" arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:@"您设置的闹钟生效了"
                                                         arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    //计算确定时间与当前时间的秒数时间差
    NSDate *now = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];//设置时区
    NSInteger interval = [zone secondsFromGMTForDate: now];
    NSDate *localDate = [now  dateByAddingTimeInterval: interval];
    NSInteger endInterval = [zone secondsFromGMTForDate: self.datePicker.date];
    NSDate *end = [self.datePicker.date dateByAddingTimeInterval: endInterval];
    NSUInteger voteCountTime = [end timeIntervalSinceDate:localDate];
    // 用秒数倒计时的方式添加本地推送
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:voteCountTime repeats:NO];
    //发送通知
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"naozhong"
                                                                          content:content trigger:trigger];
    
    //添加推送成功后的处理
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"本地通知" message:@"成功添加闹钟" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }];
    
    
}


@end
