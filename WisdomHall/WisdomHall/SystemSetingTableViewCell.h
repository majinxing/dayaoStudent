//
//  SystemSetingTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/8.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYHeader.h"

@protocol SystemSetingTableViewCellDelegate <NSObject>
-(void)outAPPBtnPressedDelegate;
@end

@interface SystemSetingTableViewCell : UITableViewCell
@property (nonatomic,weak) id<SystemSetingTableViewCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *setingLabel;
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *workNo;
@property (nonatomic,strong) UserModel * user;


+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
