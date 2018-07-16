//
//  HomeworkCreateTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/23.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeworkCreateTableViewCellDelegate<NSObject>
-(void)selectImageBtnDelegate:(UIButton *)btn;
-(void)sendHomeworkPressedDelegate:(NSString *)homeworkText;
-(void)textViewDidChangeDelegate:(UITextView *)textView;
-(void)selectTimeBtnPressedDelegate;
@end
@interface HomeworkCreateTableViewCell : UITableViewCell
@property (nonatomic,weak)id<HomeworkCreateTableViewCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIButton *sendHomework;
-(void)setbtnImageWithAry:(NSMutableArray *)ary withEndTime:(NSString *)time edit:(BOOL)edit;
-(void)addContentFirstView:(NSString *)str;
@end
