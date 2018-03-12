//
//  DefinitionPersonalTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/30.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DefinitionPersonalTableViewCellDelegate <NSObject>
-(void)textFileDidChangeForDPTableViewCellDelegate:(UITextField *)textFile;
-(void)textFieldDidBeginEditingDPTableViewCellDelegate:(UITextField *)textFile;
@optional
-(void)gggDelegate:(UIButton *)btn;
-(void)seeSaetPressedDelegate;
@end

@interface DefinitionPersonalTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *textFile;

@property (nonatomic,weak)id<DefinitionPersonalTableViewCellDelegate>delegate;
-(void)addContentView:(NSString *)infoLabelText withTextFileText:(NSString *)textFile withIndex:(int)n;
-(void)addCourseContentView:(NSString *)infoLabelText withTextFileText:(NSString *)textFile withIndex:(int)n;
-(void)addTemporaryCourseContentView:(NSString *)infoLabelText withTextFileText:(NSString *)textFile withIndex:(int)n;
-(void)addMeetingContentView:(NSString *)infoLabelText withTextFileText:(NSString *)textFile withIndex:(int)n;
@end
