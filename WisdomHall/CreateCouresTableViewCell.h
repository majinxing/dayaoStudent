//
//  CreateCouresTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/7/14.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignPeople.h"

@protocol CreateCouresTableViewCellDelegate <NSObject>

-(void)signPeopleBtnPressed:(UIButton *)btn;

@end
@interface CreateCouresTableViewCell : UITableViewCell
@property (nonatomic,weak)id<CreateCouresTableViewCellDelegate>delegate;
-(void)setContenView:(SignPeople *)s withIndex:(NSInteger)n;
@end
