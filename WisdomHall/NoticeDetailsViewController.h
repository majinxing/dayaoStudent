//
//  NoticeDetailsViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/12/19.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeModel.h"

@interface NoticeDetailsViewController : UIViewController
@property (nonatomic,strong)NoticeModel * notice;
-(instancetype)initWithActionBlock:(void(^)(NSString *str))actionBlock;
@end
