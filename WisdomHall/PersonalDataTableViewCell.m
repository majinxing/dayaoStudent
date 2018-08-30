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
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *workNum;
@property (strong, nonatomic) IBOutlet UIImageView *pictureImage;

@property (nonatomic,strong)UserModel * userl;
@end
@implementation PersonalDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _userl = [[Appsetting sharedInstance] getUsetInfo];
    _placeholder = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",_userl.userName],[NSString stringWithFormat:@"%@",_userl.studentId],[NSString stringWithFormat:@"%@",_userl.schoolName],[NSString stringWithFormat:@"%@",_userl.departmentsName],[NSString stringWithFormat:@"%@",_userl.professionalName], nil];
    
    _labelAry = [NSArray arrayWithObjects:@"姓名",@"学号",@"学校",@"院系",@"专业", nil];
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(CGRectGetMaxX(_dataLabel.frame), 0, APPLICATION_WIDTH-CGRectGetMaxX(_dataLabel.frame), 50);
    [_btn addTarget:self action:@selector(changeSex:) forControlEvents:UIControlEventTouchUpInside];
    _changeImage.enabled = NO;
    
    _userName.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    _userName.textColor = [UIColor colorWithRed:69/255.0 green:69/255.0 blue:83/255.0 alpha:1/1.0];
    
    _workNum.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _workNum.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1/1.0];
    
    _dataLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    _dataLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    
    _textFilePh.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    _textFilePh.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    _headImage.layer.masksToBounds = YES;
    _headImage.layer.cornerRadius = 5;
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
        _pictureImage.image = [UIImage imageNamed:@"Add Photo"];
    }else{
        _changeImage.enabled = NO;
        _pictureImage.image = [UIImage imageNamed:@""];

    }
    if (image.size.height>0) {
        _headImage.image = image;
    }
    _userName.text = _userl.userName;
    _workNum.text = [NSString stringWithFormat:@"学号 %@",_userl.studentId];
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
