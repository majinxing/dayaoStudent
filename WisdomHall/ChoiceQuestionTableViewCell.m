//
//  ChoiceQuestionTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/2.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "ChoiceQuestionTableViewCell.h"
#import "DYHeader.h"
#import "UIImageView+WebCache.h"


@interface ChoiceQuestionTableViewCell()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *withddd;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *firstBtnEWith;
@property (strong, nonatomic) IBOutlet UIView *Firstline;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *optionBtnAwith;

@property (strong, nonatomic) IBOutlet UILabel *firstLabel;
@property (strong, nonatomic) IBOutlet UITextView *firstTitleTextView;
@property (strong, nonatomic) IBOutlet UIButton *firstBtnA;
@property (strong, nonatomic) IBOutlet UIButton *firstBtnB;
@property (strong, nonatomic) IBOutlet UIButton *firsthBtnC;
@property (strong, nonatomic) IBOutlet UIButton *firstBtnD;
@property (strong, nonatomic) IBOutlet UIButton *firstBtnE;
@property (strong, nonatomic) IBOutlet UIButton *firstBtnF;

@property (strong, nonatomic) IBOutlet UILabel *orderNumber;
@property (strong, nonatomic) IBOutlet UITextView *thirdOptionText;
@property (strong, nonatomic) IBOutlet UIButton *thirdBtnA;
@property (strong, nonatomic) IBOutlet UIButton *thirdBtnB;
@property (strong, nonatomic) IBOutlet UIButton *thirdBtnC;

@property (strong, nonatomic) IBOutlet UIImageView *thirdImage;
@property (strong, nonatomic) IBOutlet UIButton *thirdSelectEdBtn;

@property (strong, nonatomic) IBOutlet UITextView *fourthAnswerTextView;
@property (strong, nonatomic) IBOutlet UILabel *fourthLabel;


@property (strong, nonatomic) IBOutlet UIButton *secondScoreBtn;
@property (strong, nonatomic) IBOutlet UIButton *secondDifficultBtn;

@property (nonatomic,strong) NSMutableArray * imageAry;

@property (nonatomic,strong) NSMutableArray * optionsImageAry;
@property (strong, nonatomic) IBOutlet UIButton *addCellNumberi;//选择题增加选项，填空提增加答案
@property (strong, nonatomic) IBOutlet UITextView *seventhTextView;
@property (strong, nonatomic) IBOutlet UILabel *seventhApllabel;

@property (strong, nonatomic) IBOutlet UIImageView *firstDelImageA;

@property (strong, nonatomic) IBOutlet UIButton *firstDelBtnA;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *firstDelImageAHeight;




@property (strong, nonatomic) IBOutlet NSLayoutConstraint *firstDelBtnAHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleType;
@property (weak, nonatomic) IBOutlet UILabel *titleScore;
@property (weak, nonatomic) IBOutlet UIImageView *eighthImage;
@property (weak, nonatomic) IBOutlet UIButton *eigthSelectBtn;
@property (strong, nonatomic) IBOutlet UIView *firstBackView;
@property (strong, nonatomic) IBOutlet UIView *seventhBackView;
@property (strong, nonatomic) IBOutlet UIImageView *correctImage;

@property (nonatomic,strong) NSMutableArray * deleImageAry;

@property (nonatomic,strong) NSMutableArray * deleImageBtnAry;

@end


@implementation ChoiceQuestionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_firstBtnB setEnabled:NO];
    [_firsthBtnC setEnabled:NO];
    [_firstBtnD setEnabled:NO];
    [_firstBtnD setEnabled:NO];
    [_firstBtnE setEnabled:NO];
    
//    [_thirdBtnA setEnabled:NO];
    [_thirdBtnB setEnabled:NO];
    [_thirdBtnC setEnabled:NO];
    
    _imageAry = [[NSMutableArray alloc] init];
    
    _optionsImageAry = [NSMutableArray arrayWithCapacity:1];
    
    _deleImageAry = [NSMutableArray arrayWithCapacity:1];
    
    _deleImageBtnAry = [NSMutableArray arrayWithCapacity:1];
    
    for (int i = 0; i<6;i++) {
//        UIButton *btn = (UIButton *)[self.contentView viewWithTag:i+101];
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH/3-20,APPLICATION_WIDTH/3-20)];
        
        [_imageAry addObject:image];
        
    }
    
    for (int i = 0; i<3; i++) {
//        UIButton *btn = (UIButton *)[self.contentView viewWithTag:i+1];
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,APPLICATION_WIDTH/3-30, APPLICATION_WIDTH/3-30)];
        
        [_optionsImageAry addObject:image];
    }
    // Initialization code
    
    self.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    
    _firstBackView.layer.masksToBounds = YES;
    
    _firstBackView.layer.cornerRadius = 10;
    
    _seventhBackView.layer.masksToBounds = YES;
    
    _seventhBackView.layer.cornerRadius = 10;
    
}
-(void)addCorrectImage:(NSString *)str{
    _correctImage.image = [UIImage imageNamed:str];
}
-(void)changeFirstTitleTextColor{
    _firstTitleTextView.textColor = [UIColor colorWithRed:16/255.0 green:157/255.0 blue:73/255.0 alpha:1/1.0];
}
-(void)addFirstTitleTextView:(NSString *)textStr withImageAry:(NSMutableArray *)ary withIsEdit:(BOOL)edit withIndexRow:(int)indexRow {
    
    _firstTitleTextView.text = textStr;
    if (![UIUtils isBlankString:textStr]) {
        _firstLabel.text = @"";

    }
    
    if (!edit) {
        
        [_firstTitleTextView setEditable:NO];
        
        _firstDelImageAHeight.constant -= 20;
        
        _firstDelBtnAHeight.constant -= 40;
        
        if (ary.count>0) {
            
        }else{
            _firstBtnEWith.constant -= (APPLICATION_WIDTH/3-20);
            
            [_Firstline removeFromSuperview];
        }
        for (int i=0; i<ary.count; i++) {
            UIImageView * image =_imageAry[i];
            
            UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
            
            NSString * baseUrl = user.host;
            
            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",baseUrl,FileDownload,ary[i]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            
            
            UIButton *btn1 = [self viewWithTag:i+101];
            
            [btn1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
            [btn1 setEnabled:YES];
            
            [btn1 addSubview:image];
            
            [btn1 setTitle:[NSString stringWithFormat:@"%d",indexRow] forState:UIControlStateNormal];

            [btn1 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        }
    }else{

        for (int i = 0; i<ary.count; i++) {
            UIButton *btn = (UIButton *)[self.contentView viewWithTag:i+101];
            
            [btn setBackgroundImage:ary[i] forState:UIControlStateNormal];
            
            [btn setEnabled:YES];
            
            [btn setTitle:[NSString stringWithFormat:@"%d",indexRow] forState:UIControlStateNormal];
            
            [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];

            
            UIImageView * im = (UIImageView *)[self.contentView viewWithTag:i+2001];
            
            im.image = [UIImage imageNamed:@"close"];

            UIButton *btn1 = (UIButton *)[self.contentView viewWithTag:i+1001];
            
            [btn1 setEnabled:YES];
            
            [btn1 setTitle:[NSString stringWithFormat:@"%d",indexRow] forState:UIControlStateNormal];
            [btn1 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];

        }
        
        if (ary.count<6) {
            
            UIButton *btn1 = [self viewWithTag:ary.count+101];
            
            [btn1 setEnabled:YES];
            
            [btn1 setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
            
            [btn1 setTitle:[NSString stringWithFormat:@"%d",indexRow] forState:UIControlStateNormal];
            [btn1 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];

        }
    }
}
- (IBAction)deleAnswerImage:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(deleAnswerImageDelegate:)]) {
        [self.delegate deleAnswerImageDelegate:sender];
    }
}


-(void)setScoreAndDifficult:(NSString *)score withDifficult:(NSString *)difficult withEdit:(BOOL)edit{
    if (edit) {
        [_secondDifficultBtn setEnabled:YES];
        [_secondScoreBtn setEnabled:YES];
    }else{
        [_secondDifficultBtn setEnabled:NO];
        [_secondScoreBtn setEnabled:NO];
    }
    [_secondScoreBtn setTitle:[NSString stringWithFormat:@"  分数            %@",score] forState:UIControlStateNormal];
    [_secondDifficultBtn setTitle:[NSString stringWithFormat:@"  难度            %@",difficult] forState:UIControlStateNormal];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setThirdImagee:(NSString *)str{
    _thirdImage.image = [UIImage imageNamed:str];

}
-(void)addOptionWithModel:(optionsModel *) optionsM withEdit:(BOOL)edit withIndexRow:(int)row withISelected:(BOOL)isSelected{
    
    _orderNumber.text = [NSString stringWithFormat:@"%c、",65+(row%1000)];
    
    
    _thirdOptionText.text = optionsM.optionsTitle;
    
    if (isSelected) {
        _thirdImage.image = [UIImage imageNamed:@"Oval"];
    }else{
        _thirdImage.image = [UIImage imageNamed:@"Oval3"];
    }
//    _thirdImage.backgroundColor = [UIColor redColor];
    
    _thirdSelectEdBtn.tag = 65+row;//选中按钮的tag
    
    
    _thirdBtnA.tag = (row+1)*1000+1;
    _thirdBtnB.tag = (row+1)*1000+2;
    _thirdBtnC.tag = (row+1)*1000+3;
    
    if (!edit) {
        [_thirdOptionText setEditable:NO];
        

        if (optionsM.optionsImageIdAry.count>0) {
            
        }else{
            [_thirdBtnA removeFromSuperview];
//            _withddd.constant -= (APPLICATION_WIDTH/3+30);
        }
        
        for (int i=0; i<optionsM.optionsImageIdAry.count; i++) {
            UIImageView * image = _optionsImageAry[i];
            
            UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
            
            NSString * baseUrl = user.host;
            
            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",baseUrl,FileDownload,optionsM.optionsImageIdAry[i]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            
            
            UIButton *btn1 = [self viewWithTag:i+(row+1)*1000+1];
            
            [btn1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

            [btn1 setEnabled:YES];
            
            [btn1 addSubview:image];

        }
    }

}
-(void)changeSeventhTextColor{
    _seventhTextView.textColor = [UIColor colorWithRed:16/255.0 green:157/255.0 blue:73/255.0 alpha:1/1.0];
;
}
-(void)addSeventhTextViewWithStr:(NSString *)str withIndexRow:(int)row{
    _seventhTextView.tag = row;
    
    if (![UIUtils isBlankString:str]) {
        _seventhTextView.text = str;
        _seventhApllabel.text = @"";
    }else{
        
    }
}
- (IBAction)addOption:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(addOptionsDelegate:)]) {
        [self.delegate addOptionsDelegate:sender];
    }
}
- (IBAction)createTheTitle:(UIButton *)sender {
    
}
- (IBAction)selectScore:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectScoreDeleate:)]) {
        [self.delegate selectScoreDeleate:sender];
    }
}
- (IBAction)selectDifficulty:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectDifficultyDelegate:)]) {
        [self.delegate selectDifficultyDelegate:sender];
    }
}

- (IBAction)firstSelectImageBtn:(UIButton *)sender {
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(firstSelectImageBtnDelegate:)]) {
        
        [self.delegate firstSelectImageBtnDelegate:sender];
        
    }
    
}
- (IBAction)thirthSelectOptionsImageBtn:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(thirthSelectOptionsImageBtnDelegate:)]) {
        [self.delegate thirthSelectOptionsImageBtnDelegate:sender];
    }
}
//选项被选中
- (IBAction)thirthSelectOption:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(thirthSelectOptionDelegate:)]) {
        [self.delegate thirthSelectOptionDelegate:sender];
    }
}
-(void)eigthTitleType:(NSString *)titleType withScore:(NSString *)score isSelect:(BOOL)select btnTag:(int)index{
    _titleType.text = titleType;
    _titleScore.text = score;
    
    _eigthSelectBtn.tag = index;
    
    if (select) {
        _eighthImage.image = [UIImage imageNamed:@"方形选中-fill"];
    }else{
        _eighthImage.image = [UIImage imageNamed:@"方形未选中"];
    }
}
-(void)addOptionWithModel:(optionsModel *)optionsM withIndexRow:(int)row withISelected:(BOOL)isSelected{
    
    _orderNumber.text = [NSString stringWithFormat:@"%c、",65+row];
    
    
    _thirdOptionText.text = optionsM.optionsTitle;
    
    [_thirdImage removeFromSuperview];
    
    if (isSelected) {
        _orderNumber.textColor = RGBA_COLOR(0, 113, 113, 1);
        
        _thirdOptionText.textColor = RGBA_COLOR(0, 113, 113, 1);
    }
    
    _thirdSelectEdBtn.tag = 65+row;//选中按钮的tag
    
    
    _thirdBtnA.tag = (row+1)*1000+1;
    _thirdBtnB.tag = (row+1)*1000+2;
    _thirdBtnC.tag = (row+1)*1000+3;
    
    
    [_thirdOptionText setEditable:NO];
    
    
    if (optionsM.optionsImageIdAry.count>0) {
        
    }else{
        [_thirdBtnA removeFromSuperview];
    }
    
    for (int i=0; i<optionsM.optionsImageIdAry.count; i++) {
        UIImageView * image = _optionsImageAry[i];
        
        UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
        
        NSString * baseUrl = user.host;
        
        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",baseUrl,FileDownload,optionsM.optionsImageIdAry[i]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        
        UIButton *btn1 = [self viewWithTag:i+(row+1)*1000+1];
        
        [btn1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        [btn1 setEnabled:YES];
        
        [btn1 addSubview:image];
    }
}
-(void)addSeventhTextViewWithStrEndEditor:(NSString *)str{
    if (![UIUtils isBlankString:str]) {
        _seventhTextView.text = str;
        _seventhApllabel.text = @"";
    }else{
        
    }
    [_seventhTextView setEditable: NO];
}
#pragma mark UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(textViewDidChangeDelegate:)]) {
        
        [self.delegate textViewDidChangeDelegate:textView];
    }
}
@end
