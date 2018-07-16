//
//  MJXAddPatientsTableViewCell.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/30.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXAddPatientsTableViewCell.h"
#import "UIImageView+WebCache.h"


@interface MJXAddPatientsTableViewCell()<UITextViewDelegate>
@property (nonatomic,strong)UIButton *headImageButton;

@property (nonatomic,strong)UILabel * label;
@end
@implementation MJXAddPatientsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        _headImageButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _headImageButton.frame=CGRectMake(105, 0, 50, 50);
        _saveButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.frame=CGRectMake(21, 30, APPLICATION_WIDTH-42, 44);
        _saveButton.userInteractionEnabled=NO;
        _saveButton.backgroundColor=[UIColor colorWithHexString:@"#bfbfbf"];
        [_saveButton setTitle:@"保 存" forState:UIControlStateNormal];
        _saveButton.layer.cornerRadius=8;
        _saveButton.layer.masksToBounds=YES;
        _saveButton.titleLabel.font=[UIFont systemFontOfSize:15];
    }
    return self;
}
-(void)setUITextViewWithText:(NSString *)text{
    _label = [[UILabel alloc] initWithFrame:CGRectMake(15, 9, 200, 15)];
    _label.textColor = [UIColor colorWithHexString:@"#999999"];
    _label.font = [UIFont systemFontOfSize:14];
    if (text.length>0) {
        _label.text = @"";
    }else{
        _label.text = @"用一句话介绍一下您自己";
    }
    [self.contentView addSubview:_label];
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 9, APPLICATION_WIDTH-30, 80-9)];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.textColor = [UIColor colorWithHexString:@"#333333"];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.text = text;
    [self.contentView addSubview:_textView];
}
#pragma mark UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    _label.text = @"";
}
-(void)textViewDidChange:(UITextView *)textView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewTextDidChange:)]) {
        [self.delegate textViewTextDidChange:textView];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length>0) {
        
    }else{
     _label.text = @"用一句话介绍一下您自己";
    }
}
-(void)setLableAndTextFiledWithLableText:(NSString *)lableText withTextfiledText:(NSString *)textFiledText withEditable:(BOOL)yn withText:(NSString *)text withImageView:(NSString *)headImageString withUIImage:(UIImage *)headImage{
    
    UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 30)];
    lable.text=lableText;
    lable.font=[UIFont systemFontOfSize:15];
    lable.textColor=[UIColor colorWithHexString:@"#666666"];
    
    _textField=[[UITextField alloc] init];
    if (![text isEqualToString:@"1a1aqeqewewewewe01"]&&![text isEqualToString:@""]) {
        _textField.text=text;
    }
    [self.contentView addSubview:lable];
    UIImageView * i = [[UIImageView alloc] init];
    if (headImage.size.width>0) {
        i.image = headImage;
    }else{
    [i sd_setImageWithURL:[NSURL URLWithString:headImageString] placeholderImage:[UIImage imageNamed:@"man"]];
    }
    i.frame = CGRectMake(105, 0, 50, 50);
    
    if ([lable.text isEqualToString:@"头   像"]) {
        [self.contentView addSubview:i];
//        if (i.image.size.height>0) {
//            [_headImageButton setImage:i.image forState:UIControlStateNormal];
//        }else{
//            [_headImageButton setImage:[UIImage imageNamed:@"man"] forState:UIControlStateNormal];
//        }
        [_headImageButton addTarget:self action:@selector(getImageView) forControlEvents:UIControlEventTouchUpInside];
    }else{
        _textField.font=[UIFont systemFontOfSize:15];
        _textField.frame=CGRectMake(CGRectGetMaxX(lable.frame)+35, 0, APPLICATION_WIDTH-CGRectGetMaxX(lable.frame)-35, 50);
        //文字上下居中
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        _textField.placeholder=textFiledText;
        
    }
    [self.contentView addSubview:_headImageButton];
    [self.contentView addSubview:_textField];
}
-(void)setLableAndTextFiledWithLableText:(NSString *)lableText withTextfiledText:(NSString *)textFiledText withEditable:(BOOL)yn withText:(NSString *)text withImage:(UIImage *)headImage{
    
    UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 30)];
    lable.text=lableText;
    lable.font=[UIFont systemFontOfSize:15];
    lable.textColor=[UIColor colorWithHexString:@"#666666"];
    
    _textField=[[UITextField alloc] init];
    if (yn) {
        _textField.text=textFiledText;
    }else{
        _textField.placeholder=textFiledText;
    }
    if (![text isEqualToString:@"1a1aqeqewewewewe01"]&&![text isEqualToString:@"(null)"]&&![text isEqualToString:@"<null>"]) {
        _textField.text=text;
    }
    [self.contentView addSubview:lable];
    
    if ([lable.text isEqualToString:@" 姓      名"]) {
        UIImageView *star=[[UIImageView alloc] initWithFrame:CGRectMake(4,20,10,10)];
        star.image=[UIImage imageNamed:@"Must"];
        [self.contentView addSubview:star];
    }
    if ([lable.text isEqualToString:@"分       组"]) {
        _textField.userInteractionEnabled = NO;
    }else{
        _textField.userInteractionEnabled = YES;
    }
    if ([lable.text isEqualToString:@"头       像"]) {
        if (headImage.size.height>0) {
            [_headImageButton setImage:headImage forState:UIControlStateNormal];
        }else{
            [_headImageButton setImage:[UIImage imageNamed:@"man"] forState:UIControlStateNormal];
        }
        [_headImageButton addTarget:self action:@selector(getImageView) forControlEvents:UIControlEventTouchUpInside];
    }else{
    _textField.font=[UIFont systemFontOfSize:15];
    _textField.frame=CGRectMake(CGRectGetMaxX(lable.frame)+35, 0, APPLICATION_WIDTH-CGRectGetMaxX(lable.frame)-35, 50);
    //文字上下居中
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    }
    [self.contentView addSubview:_headImageButton];
    [self.contentView addSubview:_textField];

}
-(void)getImageView{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(headImageButtonPressed)]) {
        [self.delegate headImageButtonPressed];
    }
   
}
-(void)setSaveButton{
 //页面底部的那个保存按钮
    [self.contentView addSubview:_saveButton];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
