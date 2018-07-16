//
//  MJXSelectGroupTableViewCell.h
//  XinSuiFang
//
//  Created by majinxing on 16/11/23.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJXGroup.h"

@protocol MJXSelectGroupTableViewCellDelegate <NSObject>
-(void)selectBtnPressed:(UIButton *)btn;
@end
@interface MJXSelectGroupTableViewCell : UITableViewCell
@property (nonatomic,weak)id<MJXSelectGroupTableViewCellDelegate>delegate;
-(void)selectGroup:(MJXGroup *)g withTag:(int)tag;
@end
