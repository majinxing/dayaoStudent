//
//  NoticeTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/10.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeModel.h"

@interface NoticeTableViewCell : UITableViewCell
-(void)setContentView:(NoticeModel *)notice;
@end
