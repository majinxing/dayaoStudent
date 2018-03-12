//
//  OfficeTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/9/23.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OfficeTableViewCellDelegate <NSObject>
-(void)shareButtonClickedDelegate:(NSString *)str;
-(void)signBtnPressedDelegate:(UIButton *)btn;

@end
@interface OfficeTableViewCell : UITableViewCell
@property (nonatomic,weak)id<OfficeTableViewCellDelegate>delegate;
-(void)addSecondContentView;
-(void)signState;
@end
