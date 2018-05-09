//
//  StatisticalTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/1/29.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StatisticalTableViewCellDelegate <NSObject>
-(void)selectBtnPressedDelegate:(UIButton *)btn;
-(void)departmentPressedDelegate:(UIButton *)btn;
-(void)classPressedDelegate:(UIButton *)btn;
@end
@interface StatisticalTableViewCell : UITableViewCell
@property (nonatomic,weak)id<StatisticalTableViewCellDelegate>delegate;
-(void)addContentView:(NSString *)titleStr withText:(NSString *)textStr;
-(void)addContentThirdView:(int)temp;
@end
