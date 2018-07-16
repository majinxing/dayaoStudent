//
//  MJXAddPatientsTableViewCell.h
//  XinSuiFang
//
//  Created by majinxing on 16/8/30.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol addPatientsTableViewCellDelegate  <NSObject>
-(void)headImageButtonPressed;
-(void)textViewTextDidChange:(UITextView *)text;
@end

@interface MJXAddPatientsTableViewCell : UITableViewCell
@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)UIButton *saveButton;
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,weak)id <addPatientsTableViewCellDelegate> delegate;

-(void)setLableAndTextFiledWithLableText:(NSString *)lableText withTextfiledText:(NSString *)textFiledText withEditable:(BOOL)yn withText:(NSString *)text withImage:(UIImage *)headImage;
-(void)setLableAndTextFiledWithLableText:(NSString *)lableText withTextfiledText:(NSString *)textFiledText withEditable:(BOOL)yn withText:(NSString *)text withImageView:(NSString *)headImage withUIImage:(UIImage *)headImage;
-(void)setUITextViewWithText:(NSString *)text;
-(void)setSaveButton;
@end
