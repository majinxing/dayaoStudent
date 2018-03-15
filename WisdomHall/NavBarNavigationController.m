//
//  NavBarNavigationController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/14.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "NavBarNavigationController.h"
#import "DYHeader.h"

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
}
@end
