//
//  MJXPatientsGroupView.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/6.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXPatientsGroupView.h"

@interface MJXPatientsGroupView()

@end
@implementation MJXPatientsGroupView
- (instancetype) initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setTableView];
    }
    return self;
}
-(void)setTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH,self.frame.size.height) style:UITableViewStylePlain];
    [self addSubview:_tableView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
