//
//  PersonalInfoTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/8.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PersonalInfoTableViewCellDelegate <NSObject>
-(void)signBtnPressedPInfoDelegate;


@end
@interface PersonalInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *personalNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *headImage;

@property (nonatomic,weak)id<PersonalInfoTableViewCellDelegate>delegate;
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath array:(NSMutableArray *)ary;
-(void)setSignNumebr:(NSString *)str;
@end
