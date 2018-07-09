//
//  MeetingTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/10/24.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "MeetingTableViewCell.h"
#import "MeetingModel.h"
#import "DYHeader.h"
#import "ShareButton.h"
#import "UIImageView+WebCache.h"
#import "DetailsButton.h"
#import "peopleListView.h"

#define columns 3
#define buttonWH 60
#define buttonW 120
#define buttonH 60
#define marginHeight 25

@interface MeetingTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *meetName;
@property (strong, nonatomic) IBOutlet UILabel *meetTime;
@property (strong, nonatomic) IBOutlet UILabel *meetPlace;
@property (strong, nonatomic) IBOutlet UILabel *meetHost;
@property (strong, nonatomic) IBOutlet UILabel *meetCode;
@property (weak, nonatomic) IBOutlet UIButton *singNumber;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UIButton *code;
@property (strong, nonatomic) IBOutlet UILabel *meetAttention;
@property (strong, nonatomic) IBOutlet UIImageView *teacherPicture;
@property (strong,nonatomic) UIImageView * signCode;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *classImageWide;
@property (strong, nonatomic) IBOutlet peopleListView *peopleListView;
@property (strong, nonatomic) IBOutlet UILabel *peopleNum;


@end
@implementation MeetingTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _signCode = [[UIImageView alloc] init];
    
    _meetName.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _meetName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    
    _meetTime.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    _meetTime.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1/1.0];

    _meetAttention.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    _meetAttention.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1/1.0];
    
    _meetPlace.font = [UIFont fontWithName:@"PingFangSC-Thin" size:13];
    _meetPlace.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1/1.0];
    
    _meetHost.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _meetHost.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _meetHost.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    
    _meetCode.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _meetCode.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _meetCode.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    
    _code.backgroundColor = [UIColor whiteColor];
    _code.layer.masksToBounds = YES;
    _code.layer.cornerRadius = 20;
    _signBtn.layer.masksToBounds = YES;
    _signBtn.layer.cornerRadius = 20;
    
    _peopleNum.layer.masksToBounds = YES;
    _peopleNum.layer.cornerRadius = 8;
    _peopleNum.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1/1.0];
    _peopleNum.textColor = [UIColor whiteColor];
    // Initialization code
}
-(void)addFirstContentView:(MeetingModel *)meetModel{
    if ([UIUtils isBlankString:meetModel.meetingName]) {
        _meetName.text = @"会议名称：";
    }else{
        _meetName.text = [NSString stringWithFormat:@"会议名称：%@",meetModel.meetingName];
    }
    if ([UIUtils isBlankString:meetModel.meetingHost]) {
        _meetHost.text = @"创建者：";
    }else{
        _meetHost.text = [NSString stringWithFormat:@"创建者：%@",meetModel.meetingHost];
    }
    NSMutableString *strUrl = [NSMutableString stringWithFormat:@"%@",meetModel.meetingTime];
    
    
    [strUrl deleteCharactersInRange:NSMakeRange(0,5)];
    
    [strUrl deleteCharactersInRange:NSMakeRange(strUrl.length-3,3)];

    _meetTime.text = [NSString stringWithFormat:@"%@",strUrl];
    
    _meetCode.text = [NSString stringWithFormat:@"邀请码：%@",meetModel.meetingId];
    
    _meetPlace.text = [NSString stringWithFormat:@"地址：%@",meetModel.meetingPlace];
    
    _teacherPicture.image = [UIImage imageNamed:@"meet"];
    
    if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",meetModel.signStatus]]) {
        if (![[NSString stringWithFormat:@"%@",meetModel.signStatus] isEqualToString:@"1"]) {
            _signCode.frame = CGRectMake(APPLICATION_WIDTH/2, 20, 80, 80);
            _signCode.image = [UIImage imageNamed:@"ic_sgin_success"];
            [self.contentView addSubview:_signCode];
        }
    }
    NSMutableArray * ary = [NSMutableArray arrayWithArray:meetModel.signAry];
    
    [ary addObjectsFromArray:meetModel.signNo];
    
    [_peopleListView addContentView:ary];
    
    _peopleNum.text = [NSString stringWithFormat:@"%ld人",meetModel.signAry.count];
}
-(void)addFirstCOntentViewWithClassModel:(ClassModel *)classModel{
    _classImageWide.constant -= (APPLICATION_WIDTH/2-40);
    _meetName.text = [NSString stringWithFormat:@"课程名：%@",classModel.name];
    NSMutableString *strUrl = [NSMutableString stringWithFormat:@"%@",classModel.time];
    [strUrl deleteCharactersInRange:NSMakeRange(strUrl.length-3, 3)];
    _meetTime.text = [NSString stringWithFormat:@"时间：%@",strUrl];
    _meetPlace.text = [NSString stringWithFormat:@"教室：%@",classModel.typeRoom];
    _meetHost.text = [NSString stringWithFormat:@"老师：%@",classModel.teacherName];
    _meetCode.text = [NSString stringWithFormat:@"邀请码：%@",classModel.sclassId];
    if (![UIUtils isBlankString:classModel.teacherPictureId]) {
        UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
        
        NSString * baseURL = user.host;
        
        [_teacherPicture sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",baseURL,FileDownload,classModel.teacherPictureId]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    }else{
        _teacherPicture.image = [UIImage imageNamed:@"course"];
    }
    if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",classModel.signStatus]]) {
        if (![[NSString stringWithFormat:@"%@",classModel.signStatus] isEqualToString:@"1"]) {
            _signCode.frame = CGRectMake(APPLICATION_WIDTH/2, 20, 80, 80);
            _signCode.image = [UIImage imageNamed:@"ic_sgin_success"];
            [self.contentView addSubview:_signCode];
        }
    }
    _peopleNum.text = [NSString stringWithFormat:@"%d人",classModel.n+classModel.m];
    
    [_peopleListView addContentView:classModel.signAry];

}

-(void)addSecondContentView:(MeetingModel *)meetModel{
    [_singNumber setTitle:[NSString stringWithFormat:@"已签/未签：%ld/%ld",(long)meetModel.n,(long)meetModel.m] forState:UIControlStateNormal];
}
-(void)addSecondContentViewWithClassModel:(ClassModel *)classModel{
    [_singNumber setTitle:[NSString stringWithFormat:@"已签/未签：%ld/%ld",(long)classModel.n,(long)classModel.m] forState:UIControlStateNormal];

}
-(void)addFourthContentView:(MeetingModel *)meetModel{
    NSArray * array = @[
                         InteractionType_Data,
                         InteractionType_Vote,
                         InteractionType_Responder,
                         InteractionType_Sit
                         ];
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    if ([[NSString stringWithFormat:@"%@",user.peopleId] isEqualToString:[NSString stringWithFormat:@"%@",meetModel.meetingHostId]]) {
        array = @[
                  InteractionType_Data,
                  InteractionType_Vote,
                  InteractionType_Responder,
                  InteractionType_Discuss,
                  ];
    }
    //水平间距
    int marginWidth = (APPLICATION_WIDTH - buttonW * columns) / (columns + 1);
    //起始XY坐标
    int oneX = marginWidth;
    int oneY = marginHeight;
    
    for (int i = 0; i < array.count; i++)
    {
        //行
        int row = i / columns;
        //列
        int column = i % columns;
        
        int x = oneX + (buttonW + marginWidth) * column;
        int y = oneY + (buttonH + marginWidth) * row;
        
        DetailsButton * button = [[DetailsButton alloc] initWithFrame:CGRectMake(x, y, buttonW, buttonH) andType:array[i]];
        [button addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
    }
}
-(void)addFourthContentViewWithClassModel:(ClassModel *)classModel{
    NSArray * array = @[
                        InteractionType_Data,
                        InteractionType_Test,
                        InteractionType_Picture,
                        InteractionType_Vote,
                        InteractionType_Responder,
                        InteractionType_Sit,
                        InteractionType_Homework
                              ];
    
    //水平间距
    int marginWidth = (APPLICATION_WIDTH - buttonW * columns) / (columns + 1);
    //起始XY坐标
    int oneX = marginWidth;
    int oneY = marginHeight;
    
    for (int i = 0; i < array.count; i++)
    {
        //行
        int row = i / columns;
        //列
        int column = i % columns;
        
        int x = oneX + (buttonW + marginWidth) * column;
        int y = oneY + (buttonH + marginWidth) * row;
        
        DetailsButton * button = [[DetailsButton alloc] initWithFrame:CGRectMake(x, y, buttonW, buttonH) andType:array[i]];
        
        [button addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
    }
}
//会议
-(void)addThirdContentView:(MeetingModel *)meetModel isEnable:(BOOL)isEnable{
    if ([[NSString stringWithFormat:@"%@",meetModel.signStatus] isEqualToString:@"1"]) {
        [_signBtn setTitle:@"一键签到" forState:UIControlStateNormal];
        [_code setTitle:@"扫码签到" forState:UIControlStateNormal];
        [_signBtn setEnabled:YES];
        if (!isEnable) {
            [_code setEnabled:NO];
            [_code setBackgroundColor:[UIColor grayColor]];
        }else{
            [_code setEnabled:YES];
            [_code setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
        }
    }else if([[NSString stringWithFormat:@"%@",meetModel.signStatus] isEqualToString:@"2"]){
        [_signBtn setTitle:@"签到状态：已签到" forState:UIControlStateNormal];
        [_code setTitle:@"生成二维码" forState:UIControlStateNormal];
        [_signBtn setEnabled:YES];
        if (!isEnable) {
            [_code setEnabled:NO];
            [_code setBackgroundColor:[UIColor grayColor]];
        }else{
            [_code setEnabled:YES];
            [_code setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
        }
    }else if ([[NSString stringWithFormat:@"%@",meetModel.signStatus] isEqualToString:@"300"]){
        [_signBtn setTitle:@"签到状态：正在签到……" forState:UIControlStateNormal];
        [_code setTitle:@"扫码签到" forState:UIControlStateNormal];
        [_signBtn setEnabled:NO];
        if (!isEnable) {
            [_code setEnabled:NO];
            [_code setBackgroundColor:[UIColor grayColor]];
        }else{
            [_code setEnabled:YES];
            [_code setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
        }
    }else if ([[NSString stringWithFormat:@"%@",meetModel.signStatus] isEqualToString:@"400"]){
        [_signBtn setTitle:@"连接数据流量再点击" forState:UIControlStateNormal];
        [_code setTitle:@"扫码签到" forState:UIControlStateNormal];
        [_signBtn setEnabled:YES];
        if (!isEnable) {
            [_code setEnabled:NO];
            [_code setBackgroundColor:[UIColor grayColor]];
        }else{
            [_code setEnabled:YES];
            [_code setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
        }
    }else if ([[NSString stringWithFormat:@"%@",meetModel.signStatus] isEqualToString:@"3"]){
        [_signBtn setTitle:@"签到状态：请假" forState:UIControlStateNormal];
        [_code setTitle:@"扫码签到" forState:UIControlStateNormal];
        [_signBtn setEnabled:NO];
        if (!isEnable) {
            [_code setEnabled:NO];
            [_code setBackgroundColor:[UIColor grayColor]];
        }else{
            [_code setEnabled:YES];
            [_code setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
        }
    }else if ([[NSString stringWithFormat:@"%@",meetModel.signStatus] isEqualToString:@"4"]){
        [_signBtn setTitle:@"签到状态：迟到" forState:UIControlStateNormal];
        [_code setTitle:@"扫码签到" forState:UIControlStateNormal];
        [_signBtn setEnabled:NO];
        if (!isEnable) {
            [_code setEnabled:NO];
            [_code setBackgroundColor:[UIColor grayColor]];
        }else{
            [_code setEnabled:YES];
            [_code setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
        }
    }else if ([[NSString stringWithFormat:@"%@",meetModel.signStatus] isEqualToString:@"5"]){
        [_signBtn setTitle:@"签到状态：早退" forState:UIControlStateNormal];
        [_code setTitle:@"扫码签到" forState:UIControlStateNormal];
        [_signBtn setEnabled:NO];
        if (!isEnable) {
            [_code setEnabled:NO];
            [_code setBackgroundColor:[UIColor grayColor]];
        }else{
            [_code setEnabled:YES];
            [_code setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
        }
    }else{
        [_signBtn setTitle:@"一键签到" forState:UIControlStateNormal];
        [_code setTitle:@"扫码签到" forState:UIControlStateNormal];
        [_signBtn setEnabled:YES];
        if (!isEnable) {
            [_code setEnabled:NO];
            [_code setBackgroundColor:[UIColor grayColor]];
        }else{
            [_code setEnabled:YES];
            [_code setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
        }
    }
}
//课程
-(void)addThirdContentViewWithClassModel:(ClassModel *)classModel isEnable:(BOOL)isEnable{
    if ([[NSString stringWithFormat:@"%@",classModel.signStatus] isEqualToString:@"1"]) {
        [_signBtn setTitle:@"一键签到" forState:UIControlStateNormal];
        [_code setTitle:@"扫码签到" forState:UIControlStateNormal];
        [_signBtn setEnabled:YES];
        if (!isEnable) {
            [_code setEnabled:NO];
            [_code setBackgroundColor:[UIColor grayColor]];
        }else{
            [_code setEnabled:YES];
            [_code setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
        }
    }else if([[NSString stringWithFormat:@"%@",classModel.signStatus] isEqualToString:@"2"]){
        [_signBtn setTitle:@"签到状态：已签到" forState:UIControlStateNormal];
        [_code setTitle:@"生成二维码" forState:UIControlStateNormal];
        [_signBtn setEnabled:YES];
        if (!isEnable) {
            [_code setEnabled:NO];
            [_code setBackgroundColor:[UIColor grayColor]];
        }else{
            [_code setEnabled:YES];
            [_code setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
        }
    }else if ([[NSString stringWithFormat:@"%@",classModel.signStatus] isEqualToString:@"300"]){
        [_signBtn setTitle:@"正在签到，请不要退出界面" forState:UIControlStateNormal];
        [_code setTitle:@"扫码签到" forState:UIControlStateNormal];

        [_signBtn setEnabled:NO];
        if (!isEnable) {
            [_code setEnabled:NO];
            [_code setBackgroundColor:[UIColor grayColor]];
        }else{
            [_code setEnabled:YES];
            [_code setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
        }
    }else if ([[NSString stringWithFormat:@"%@",classModel.signStatus] isEqualToString:@"400"]){
        [_signBtn setTitle:@"签到状态：连接数据流量后再次点击" forState:UIControlStateNormal];
        [_code setTitle:@"扫码签到" forState:UIControlStateNormal];
        [_signBtn setEnabled:YES];
        if (!isEnable) {
            [_code setEnabled:NO];
            [_code setBackgroundColor:[UIColor grayColor]];
        }else{
            [_code setEnabled:YES];
            [_code setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
        }
    }else if ([[NSString stringWithFormat:@"%@",classModel.signStatus] isEqualToString:@"3"]){
        [_signBtn setTitle:@"签到状态：请假" forState:UIControlStateNormal];
        [_code setTitle:@"生成二维码" forState:UIControlStateNormal];
        [_signBtn setEnabled:YES];
        if (!isEnable) {
            [_code setEnabled:NO];
            [_code setBackgroundColor:[UIColor grayColor]];
        }else{
            [_code setEnabled:YES];
            [_code setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
        }
    }else if ([[NSString stringWithFormat:@"%@",classModel.signStatus] isEqualToString:@"4"]){
        [_signBtn setTitle:@"签到状态：迟到" forState:UIControlStateNormal];
        [_code setTitle:@"生成二维码" forState:UIControlStateNormal];
        [_signBtn setEnabled:YES];
        if (!isEnable) {
            [_code setEnabled:NO];
            [_code setBackgroundColor:[UIColor grayColor]];
        }else{
            [_code setEnabled:YES];
            [_code setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
        }
    }else if ([[NSString stringWithFormat:@"%@",classModel.signStatus] isEqualToString:@"5"]){
        [_signBtn setTitle:@"签到状态：早退" forState:UIControlStateNormal];
        [_code setTitle:@"生成二维码" forState:UIControlStateNormal];
        [_signBtn setEnabled:YES];
        if (!isEnable) {
            [_code setEnabled:NO];
            [_code setBackgroundColor:[UIColor grayColor]];
        }else{
            [_code setEnabled:YES];
            [_code setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
        }
    }else{
        [_signBtn setTitle:@"一键签到" forState:UIControlStateNormal];
        [_code setTitle:@"生成二维码" forState:UIControlStateNormal];
        [_signBtn setEnabled:YES];
        if (!isEnable) {
            [_code setEnabled:NO];
            [_code setBackgroundColor:[UIColor grayColor]];
        }else{
            [_code setEnabled:YES];
            [_code setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
        }
    }
}
-(void)shareButtonClicked:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(shareButtonClickedDelegate:)]) {
        [self.delegate shareButtonClickedDelegate:btn.titleLabel.text];
    }
}
- (IBAction)peopleManagement:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(peopleManagementDelegate)]) {
        [self.delegate peopleManagementDelegate];
    }
}
- (IBAction)signNOPeople:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(signNOPeopleDelegate)]) {
        [self.delegate signNOPeopleDelegate];
    }
}
- (IBAction)signBtnPressed:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(signBtnPressedDelegate:)]) {
        [self.delegate signBtnPressedDelegate:sender];
    }
}
- (IBAction)codePressed:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(codePressedDelegate:)]) {
        [self.delegate codePressedDelegate:sender];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
