//
//  NavBarNavigationController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/14.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "NavBarNavigationController.h"
#import "DYHeader.h"
#import <CoreLocation/CoreLocation.h>

@interface NavBarNavigationController ()
@property (nonatomic,strong)NSTimer *showTimer;
@property (nonatomic,strong)NSDictionary * dict;
@end
@implementation NavBarNavigationController
-(void)setColor{
    self.navigationBar.barTintColor = [[ThemeTool shareInstance] getThemeColor];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    self.navigationBar.barTintColor = [[ThemeTool shareInstance] getThemeColor];
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(setColor)
     name:ThemeColorChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(inApp)
     name:InApp object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(outApp)
     name:OutApp object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(stopTime)
     name:@"stopTime" object:nil];
}
-(void)stopTime{
    [_showTimer invalidate];
}
-(void)inApp{
    //时间间隔
    NSTimeInterval timeInterval = 3*60 ;
    
    //定时器
    _showTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                  target:self
                                                selector:@selector(handleMaxShowTimer:)
                                                userInfo:nil
                                                 repeats:YES];
    [_showTimer fire];
}
-(void)handleMaxShowTimer:(NSTimer *)theTimer{
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    if (user.peopleId) {
        NSDictionary * dict = @{@"appState":@"1",@"id":[NSString stringWithFormat:@"%@",user.peopleId]};
        [[NetworkRequest sharedInstance] POST:ChangeAppState dict:dict succeed:^(id data) {
            //            NSLog(@"%@",data);
        } failure:^(NSError *error) {
            
        }];
    }
}
-(void)outApp{
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    [_showTimer invalidate];
    
    if (user.peopleId) {
        NSDictionary * dict = @{@"appState":@"3",@"id":[NSString stringWithFormat:@"%@",user.peopleId]};
        [[NetworkRequest sharedInstance] POST:ChangeAppState dict:dict succeed:^(id data) {
            //            NSLog(@"%@",data);
        } failure:^(NSError *error) {
            
        }];
    }
}
@end
