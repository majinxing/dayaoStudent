//
//  CalendarViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/1/17.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "CalendarViewController.h"
#import "DAYCalendarView.h"
#import "DYHeader.h"


@interface CalendarViewController ()
@property (nonatomic,strong) DAYCalendarView * calendarView;
@property (nonatomic,copy)NSString * dataTime;
@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationTitle];
    
    self.calendarView = [[DAYCalendarView alloc] initWithFrame:CGRectMake(20, 90, APPLICATION_WIDTH-40, 260)];
    [self.view addSubview:self.calendarView];
    
    [self.calendarView addTarget:self action:@selector(calendarViewDidChange:) forControlEvents:UIControlEventValueChanged];

    // Do any additional setup after loading the view from its nib.
}

-(void)setNavigationTitle{
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"创建课堂";
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(back)];

    self.navigationItem.rightBarButtonItem = myButton;
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)returnText:(returnTextBlock)block{
    self.returnTextBlock = block;
}
- (void)viewWillDisappear:(BOOL)animated {
    
    if (self.returnTextBlock != nil) {
        self.returnTextBlock(_dataTime);
    }
}
- (void)calendarViewDidChange:(id)sender {
//    self.datePicker.date = self.calendarView.selectedDate;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
//    NSLog(@"%@", [formatter stringFromDate:self.calendarView.selectedDate]);
    _dataTime = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.calendarView.selectedDate]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
