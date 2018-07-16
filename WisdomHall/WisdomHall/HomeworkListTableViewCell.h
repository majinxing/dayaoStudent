//
//  HomeworkListTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/23.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Homework.h"

@interface HomeworkListTableViewCell : UITableViewCell
-(void)addContentViewWith:(Homework *)homework;
@end
