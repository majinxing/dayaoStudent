//
//  PersonalDataTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/10.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "PersonalDataTableViewCell.h"
#import "DYHeader.h"

@interface PersonalDataTableViewCell()<UITextFieldDelegate>
@property (nonatomic,strong)UIButton * btn;
@property (strong, nonatomic) IBOutlet UIButton *changeImage;
@property (strong, nonatomic) IBOutlet UIImageView *headImage;


@end
@implementation PersonalDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UserModel * userl = [[Appsetting sharedInstance] getUsetInfo];
    _placeholder = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",userl.userName],[NSString stringWithFormat:@"%@",userl.studentId],[NSString stringWithFormat:@"%@",userl.schoolName],[NSString stringWithFormat:@"%@",userl.departmentsName],[NSString stringWithFormat:@"%@",userl.professionalName], nil];
    
    _labelAry = [NSArray arrayWithObjects:@"姓名",@"学号",@"学校",@"院系",@"专业", nil];
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(CGRectGetMaxX(_dataLabel.frame), 0, APPLICATION_WIDTH-CGRectGetMaxX(_dataLabel.frame), 50);
    [_btn addTarget:self action:@selector(changeSex:) forControlEvents:UIControlEventTouchUpInside];
    _changeImage.enabled = NO;
    // Initialization code
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"PersonalDataTableViewCellSecond";//对应xib中设置的identifier
    NSInteger index = 1; //xib中第几个Cell
    switch (indexPath.section) {
        case 0:
            identifier = @"PersonalDataTableViewCellFirst";
            index = 0;
            break;
        case 1:
            identifier = @"PersonalDataTableViewCellSecond";
            index = 1;
        default:
            break;
    }
    PersonalDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonalDataTableViewCell" owner:self options:nil] objectAtIndex:index];
    }
    return cell;
}
-(void)setInfo:(NSString *)labelText withTextAry:(NSString *)textText isEdictor:(BOOL)edictor withRow:(NSInteger)n{
    _dataLabel.text = labelText;
    _textFilePh.placeholder = labelText;
    if ([UIUtils isBlankString:textText]) {

    }else{
        _textFilePh.text = textText;
    }
    _textFilePh.delegate = self;
    _textFilePh.tag = n;
    [_textFilePh addTarget:self action:@selector(textFileDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    if (edictor) {
        if (n<6) {
            _dataLabel.alpha = 0.5;
            _textFilePh.alpha = 0.5;
        }else{
            _textFilePh.enabled = YES ;
            _dataLabel.textColor = [UIColor blueColor];
        }
        if (n == 8) {
            [self.contentView addSubview:_btn];
        }
    }else{
        _dataLabel.alpha = 1;
        _textFilePh.alpha = 1;
        _textFilePh.enabled = NO ;
        _dataLabel.textColor = [UIColor blackColor];
    }
}
-(void)changeImageIsBool:(BOOL)edictor withImage:(UIImage *)image{
    if (edictor) {
        _changeImage.enabled = YES;
    }else{
        _changeImage.enabled = NO;
    }
    if (image.size.height>0) {
        _headImage.image = image;
    }
}
- (IBAction)changeHeadImage:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(changeHeadImageDelegate:)]) {
        [self.delegate changeHeadImageDelegate:sender];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)textFileDidChange:(UITextField *)textField{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(textFieldDidChangeDelegate:)]) {
        [self.delegate textFieldDidChangeDelegate:textField];
    }
}
-(void)changeSex:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(changeSexBtnPressed:)]) {
        [self.delegate changeSexBtnPressed:btn];
    }
    
}
@end
