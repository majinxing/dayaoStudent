//
//  HomeworkCreateTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/23.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "HomeworkCreateTableViewCell.h"
#import "DYHeader.h"
#import "UIImageView+WebCache.h"


@interface HomeworkCreateTableViewCell()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *textFile;
@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutlet UIButton *imageBtn1;
@property (strong, nonatomic) IBOutlet UIButton *imageBtn2;
@property (strong, nonatomic) IBOutlet UIButton *imageBtn3;
@property (strong, nonatomic) IBOutlet UIButton *imageBtn4;
@property (strong, nonatomic) IBOutlet UIButton *imageBtn5;
@property (strong, nonatomic) IBOutlet UIButton *imageBtn6;

@property (strong, nonatomic) IBOutlet UIButton *endTime;
@property (nonatomic,strong) NSMutableArray * imageAry;
@end

@implementation HomeworkCreateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _sendHomework.backgroundColor = [[Appsetting sharedInstance] getThemeColor];
    _imageBtn2.selected = NO;
    _imageBtn3.selected = NO;
    _imageBtn4.selected = NO;
    _imageBtn5.selected = NO;
    _imageBtn6.selected = NO;
    
    _textFile.delegate = self;
    
    _imageAry = [[NSMutableArray alloc] init];
    for (int i = 0; i<6;i++) {
        UIButton *btn = (UIButton *)[self.contentView viewWithTag:i+2];
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height)];
        [_imageAry addObject:image];
    }
    // Initialization code
}
-(void)textViewDidChange:(UITextView *)textView{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(textViewDidChangeDelegate:)]) {
        [self.delegate textViewDidChangeDelegate:textView];
    }
}
- (IBAction)selectImageBtn:(UIButton *)sender {
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectImageBtnDelegate:)]) {
        [self.delegate selectImageBtnDelegate:sender];
    }
}
- (IBAction)sendHomeworkPressed:(UIButton *)sender {
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(sendHomeworkPressedDelegate:)]) {
        [self.delegate sendHomeworkPressedDelegate:_textFile.text];
    }
}
-(void)setbtnImageWithAry:(NSMutableArray *)ary withEndTime:(NSString *)time edit:(BOOL)edit{
    if (![UIUtils isBlankString:time]) {
        [_endTime setTitle:time forState:UIControlStateNormal];
    }
    if (!edit) {
        for (int i=0; i<ary.count; i++) {
            UIImageView * image = _imageAry[i];
            UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
            
            NSString * baseUrl = user.host;
            
            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",baseUrl,FileDownload,ary[i]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            
            [self.contentView addSubview:image];
        }
        [_endTime setEnabled:NO];
    }else{
        for (int i = 0; i<ary.count; i++) {
            UIButton *btn = (UIButton *)[self.contentView viewWithTag:i+2];
            [btn setBackgroundImage:ary[i] forState:UIControlStateNormal];
        }
        
        if (ary.count<6) {
            UIButton *btn1 = [self viewWithTag:ary.count+2];
            btn1.selected = YES;
            [btn1 setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
            
        }
    }
    
    
    
}
-(void)addContentFirstView:(NSString *)str{
    _textFile.text = str;
    _textFile.editable = NO;

}
- (IBAction)selectTime:(UIButton *)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(selectTimeBtnPressedDelegate)]) {
        [self.delegate selectTimeBtnPressedDelegate];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
