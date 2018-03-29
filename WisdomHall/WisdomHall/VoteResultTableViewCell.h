//
//  VoteResultTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/26.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoteOption.h"

@interface VoteResultTableViewCell : UITableViewCell
-(void)addContentViewWith:(VoteOption *)voteOption withAllVotes:(NSString *)allNumber withIndex:(int)n;
-(void)addSecondContentView:(NSString *)n;
@end
