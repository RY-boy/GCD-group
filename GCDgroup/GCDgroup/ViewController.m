//
//  ViewController.m
//  GCDgroup
//
//  Created by qingyun on 15/11/16.
//  Copyright (c) 2015年 qingyun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UITextView *textViewTemp;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation ViewController
#pragma mark 登陆
-(void)loginRequest
{
    //耗时操作
    [NSThread sleepForTimeInterval:2];
    NSLog(@"=====登录成功");
}
-(void)departmentRequest
{
    //下载部门
    [NSThread sleepForTimeInterval:4];
    NSLog(@"=====下载部门成功");
}
-(void)contationRequest
{
    //下载联系人列表
    [NSThread sleepForTimeInterval:5];
    NSLog(@"======下载联系人成功");
    
}
-(void)GroupRequest
{

    //GCD 同步下载
    NSDate *nowDate = [NSDate date];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //主线程更新UI 风火轮转起来
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_activityView startAnimating];
            
        });
        //1.登陆
        [self loginRequest];
        //创建一个组group
        dispatch_group_t group = dispatch_group_create();
        //2.获取部门和联系人
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self departmentRequest];
        });
        //联系人
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self contationRequest];
            
        });
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self contationRequest];
        });
        

        //notify Group任务完成后进行回调通知
        //notify 也是一个异步的操作
        dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //更新ui
            dispatch_sync(dispatch_get_main_queue(), ^{
                [_activityView stopAnimating];
                _textViewTemp.text=@"哈哈哈  我更新成功了";
                
            });
            NSDate *endDate = [NSDate date];
            NSTimeInterval Duration = [endDate timeIntervalSinceDate:nowDate];
            NSLog(@"=======%f",Duration);
            
        });
    });

    
}
   - (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickLogin:(id)sender
{
    [self GroupRequest];
}

@end
