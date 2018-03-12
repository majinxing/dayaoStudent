//
//  MJXChatCellTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/26.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Hyphenate/Hyphenate.h>

@interface MJXChatCellTableViewCell : UITableViewCell
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView EMMessage:(EMMessage *)message;
@end
