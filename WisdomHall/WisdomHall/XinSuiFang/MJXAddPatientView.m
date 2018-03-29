//
//  MJXAddPatientView.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/30.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXAddPatientView.h"

@implementation MJXAddPatientView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor greenColor];
        [self setTableView];
    }
    return self;
}
-(void)setTableView{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    [self addSubview:_tableView];
}
//回收键盘的
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self endEditing:YES];
    
}

@end
