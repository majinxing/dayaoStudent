//
//  ClassTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/10/18.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClassTableViewCellDelegate <NSObject>
-(void)intoTheCurriculumDelegate:(NSString *)str withNumber:(NSMutableArray *)btn;


@end
@interface ClassTableViewCell : UITableViewCell
@property (nonatomic,weak)id<ClassTableViewCellDelegate>delegate;
-(void)addFirstContentViewWith:(int)index withClass:(NSMutableArray *)classAry;

@end
