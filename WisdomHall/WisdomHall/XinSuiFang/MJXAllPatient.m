//
//  MJXAllPatient.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/26.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXAllPatient.h"
#import "MJRefresh.h"
@implementation MJXAllPatient
- (instancetype) initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setTableView];
    }
    return self;
}
-(void)setTableView{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-50) style:UITableViewStylePlain];
    //_tableView.contentInset=UIEdgeInsetsMake(45, 0, 0, 0);mjx
    UIButton *search=[UIButton buttonWithType:UIButtonTypeCustom];
    search.frame=CGRectMake(0, 0,APPLICATION_WIDTH, 45);
    //加载更多数据
    __weak  typeof(self)vc = self;
    [_tableView addHeaderWithCallback:^{
        [vc headerRereshing];
    }];
    
     //[_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self addSubview:_tableView];
    search.backgroundColor=[UIColor greenColor];
    [search addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    //[self addSubview:search];
}
-(void)headerRereshing{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(allPatientHeaderRereshing)]) {
        [self.delegate allPatientHeaderRereshing];
    }
}
-(void)search{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(allPatientViewSearchPressed)]) {
        [self.delegate allPatientViewSearchPressed];
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
