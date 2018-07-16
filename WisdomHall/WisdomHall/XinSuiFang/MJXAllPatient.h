//
//  MJXAllPatient.h
//  XinSuiFang
//
//  Created by majinxing on 16/8/26.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  MJXAllPatientViewDelegate<NSObject>
-(void)allPatientViewSearchPressed;
-(void)allPatientHeaderRereshing;

@end
@interface MJXAllPatient : UIView
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,weak)id<MJXAllPatientViewDelegate> delegate;
@end
