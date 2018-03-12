//
//  GroupListTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/10/10.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupModel.h"

@interface GroupListTableViewCell : UITableViewCell
-(void)addContentView:(GroupModel *)group;
@end
