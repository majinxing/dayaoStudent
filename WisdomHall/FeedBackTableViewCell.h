//
//  FeedBackTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/1.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FeedBackTableViewCellDelegate <NSObject>
-(void)feedBackCellDelegateTextViewChange:(UITextView *)textFile;


@end

@interface FeedBackTableViewCell : UITableViewCell
@property (nonatomic,weak)id<FeedBackTableViewCellDelegate>delegate;
-(void)addContentView:(NSString *)labelStr withTextFiled:(NSString *)textFileStr withIndex:(NSInteger)index;
@end
