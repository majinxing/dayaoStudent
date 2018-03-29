//
//  MJXMedicalHistoryTableViewCell.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/13.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXMedicalHistoryTableViewCell.h"

@interface MJXMedicalHistoryTableViewCell ()<UITextFieldDelegate>

@end
@implementation MJXMedicalHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        
    }
    return self;
}

-(void)addCellViewWithLabelText:(NSString *)labelText withTextFieldP:(NSString *)placeholder withTextFieldText:(NSString *)text{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 15)];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.font = [UIFont systemFontOfSize:15];
    label.text = labelText;
    [self.contentView addSubview:label];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label.frame)+15, APPLICATION_WIDTH-20, 15)];
   
    textField.font = [UIFont systemFontOfSize:15];
    textField.placeholder = placeholder;
    textField.text = text;
    textField.textColor = [UIColor colorWithHexString:@"#333333"];
    textField.delegate = self;
    [self.contentView addSubview:textField];

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  
    return NO;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
