//
//  MJXSetRemindersViewController.h
//  XinSuiFang
//
//  Created by majinxing on 16/9/20.
//  Copyright © 2016年 majinxing. All rights reserved.
//随访提醒时间的展示

#import <UIKit/UIKit.h>
#import "MJXPatients.h"
@interface MJXSetRemindersViewController : UIViewController
@property (nonatomic,strong)NSMutableArray *timeAdviceArray;
@property (nonatomic,strong)NSString *templateName;
@property (nonatomic,strong)NSString *followupId;
@property (nonatomic,strong)MJXPatients *patients;
@end
