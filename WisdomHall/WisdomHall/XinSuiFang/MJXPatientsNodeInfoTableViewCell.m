//
//  MJXPatientsNodeInfoTableViewCell.m
//  XinSuiFang
//
//  Created by majinxing on 16/10/12.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXPatientsNodeInfoTableViewCell.h"
#import "MJXPatients.h"
#import "UIImageView+WebCache.h"
#import "MJXBrowsePicturesCollectionViewCell.h"
#import "MJXMyselfFlowLayout.h"
#import "ImageBrowserViewController.h"

static NSString *cellIdentifier = @"cellIdentifier";

@interface MJXPatientsNodeInfoTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,ImageBrowserViewControllerDelegate>
@property (nonatomic,strong)NSMutableArray * aryImage;
@property (nonatomic,assign)int sign;
@property (nonatomic,strong)UICollectionView * collectionView;
@end

@implementation MJXPatientsNodeInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        _aryImage = [NSMutableArray arrayWithCapacity:10];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 50, APPLICATION_WIDTH-40, 73)collectionViewLayout:[[MJXMyselfFlowLayout alloc] init]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //注册
        [_collectionView registerClass:[MJXBrowsePicturesCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;//取消滑动的滚动条
        _collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 90, APPLICATION_WIDTH-40, 80)];


    }
    return self;
}
-(void)setTemplate:(NSString *)template status:(NSString *)status{
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(10.0/375.0*APPLICATION_WIDTH, 20, 15, 15)];
    image.image = [UIImage imageNamed:@"suifmingc-0"];
    [self.contentView addSubview:image];
    UILabel * templateName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+3, 20, 200, 15)];
    templateName.font = [UIFont systemFontOfSize:15];
    templateName.textColor = [UIColor colorWithHexString:@"#333333"];
    templateName.text = [NSString stringWithFormat:@"随访名称：%@",template];
    [self.contentView addSubview:templateName];
    UILabel * s = [[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-15-40, 20, 40, 15)];
    s.font = [UIFont systemFontOfSize:13];
    s.textColor = [UIColor colorWithHexString:@"#999999"];
    
    if ([status isEqualToString:@"010"]) {
        s.text = @"未提醒";
    }else if ([status isEqualToString:@"101"]){
        s.text = @"已提醒";
    }else if ([status isEqualToString:@"110"]){
        s.text = @"已完成";
    }
    [self.contentView addSubview:s];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, APPLICATION_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [self.contentView addSubview:line];
    
}
-(void)addPatientsInfoWithPatiens:(MJXPatients *)patients{
    UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(12.0/375.0*APPLICATION_WIDTH, 12, 150, 14)];
    name.font = [UIFont systemFontOfSize:14];
    name.textColor = [UIColor colorWithHexString:@"#333333"];
    name.text = patients.patientsName;
    [self.contentView addSubview:name];
    CGSize titleSize = [name.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MAXFLOAT, 14)];
    UILabel * age = [[UILabel alloc] initWithFrame:CGRectMake(name.frame.origin.x+titleSize.width+12, 12, 40, 14)];
    age.font = [UIFont systemFontOfSize:14];
    age.textColor = [UIColor colorWithHexString:@"#333333"];
    if (patients.patientAge.length>0) {
        age.text = [NSString stringWithFormat:@"%@岁",patients.patientAge];
    }
    [self.contentView addSubview:age];
    CGSize titleSize1 = [age.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MAXFLOAT, 14)];
    UIImageView * sex = [[UIImageView alloc] initWithFrame:CGRectMake(age.frame.origin.x+titleSize1.width, 12, 15, 15)];
    if (![patients.patientSex isKindOfClass:[NSNull class]]) {
        if ([patients.patientSex isEqualToString:@"1"]) {
            sex.image=[UIImage imageNamed:@"woman"];
        }else if([patients.patientSex isEqualToString:@"0"]){
            sex.image=[UIImage imageNamed:@"man"];
        }
    }
    
    [self.contentView addSubview:sex];
    
    UILabel * templateName = [[UILabel alloc] initWithFrame:CGRectMake(12.0/375.0*APPLICATION_WIDTH, CGRectGetMaxY(sex.frame)+16, 150, 15)];
    templateName.font = [UIFont systemFontOfSize:13];
    templateName.textColor = [UIColor colorWithHexString:@"#b2b2b2"];
    templateName.text = [NSString stringWithFormat:@"随访方案：%@",patients.tempLateName];
    [self.contentView addSubview:templateName];
    
    UILabel * time = [[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-15-70, 12, 70, 12)];
    time.text = patients.nodeTime;
    time.font = [UIFont systemFontOfSize:12];
    time.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.contentView addSubview:time];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(10.0/375.0*APPLICATION_WIDTH, 59, APPLICATION_WIDTH-2*10.0/375.0*APPLICATION_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [self.contentView addSubview:line];
}
-(void)addContenViewWithFollowUpTime:(NSString *)time withContent:(NSString *)content withRemindstate:(NSString *)state1 withButtonTag:(int)tagInt{
    UITextView *titleTime = [[UITextView alloc] initWithFrame:CGRectMake(11.0/375.0*APPLICATION_WIDTH,5,200, 25)];
    titleTime.font = [UIFont systemFontOfSize:13];
    titleTime.textColor = [UIColor colorWithHexString:@"#333333"];
    titleTime.autoresizesSubviews = NO;
    titleTime.userInteractionEnabled = NO;
    titleTime.text = [NSString stringWithFormat:@"随访时间：%@",time];
    [self.contentView addSubview:titleTime];
    
    CGFloat titleHeight = [self getTextViewHeight:content font:[UIFont systemFontOfSize:13] width:APPLICATION_WIDTH-22];
    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(11.0/375.0*APPLICATION_WIDTH, CGRectGetMaxY(titleTime.frame)+10, APPLICATION_WIDTH-22, titleHeight+20)];
    textView.returnKeyType = UIReturnKeyDone;
    //    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:13];
    textView.textColor = [UIColor colorWithHexString:@"#666666"];
    textView.text = [NSString stringWithFormat:@"医嘱内容 ：%@",content];
    textView.userInteractionEnabled = NO;
    [self.contentView addSubview:textView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = tagInt;
    btn.frame = CGRectMake(21.0/375.0*APPLICATION_WIDTH, CGRectGetMaxY(textView.frame)+58, APPLICATION_WIDTH-21.0/375.0*APPLICATION_WIDTH*2, 44);
    
    [btn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [[UIColor colorWithHexString:@"#999999"] CGColor];
    [self.contentView addSubview:btn];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];//取消发送按钮
    cancel.frame = CGRectMake(0,0,0,0);
    cancel.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancel setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [cancel setTitle:@"取消发送" forState:UIControlStateNormal];
    cancel.tag = tagInt+1000;
    cancel.backgroundColor = [UIColor whiteColor];
    cancel.layer.cornerRadius = 5;
    cancel.layer.masksToBounds = YES;
    cancel.layer.borderWidth = 1;
    cancel.layer.borderColor = [[UIColor colorWithHexString:@"#999999"] CGColor];
    [cancel addTarget:self action:@selector(cancelSend:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancel];
    
    UIButton *immediatelySend = [UIButton buttonWithType:UIButtonTypeCustom];//立即发送按钮
    immediatelySend.tag = tagInt+2000;
    immediatelySend.frame = CGRectMake(0,0, 0,0);
    immediatelySend.titleLabel.font = [UIFont systemFontOfSize:13];
    [immediatelySend setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [immediatelySend setTitle:@"立即发送发送" forState:UIControlStateNormal];
    [immediatelySend addTarget:self action:@selector(immediatelySend:) forControlEvents:UIControlEventTouchUpInside];
    immediatelySend.backgroundColor = [UIColor whiteColor];
    immediatelySend.layer.cornerRadius = 5;
    immediatelySend.layer.masksToBounds = YES;
    immediatelySend.layer.borderWidth = 1;
    immediatelySend.layer.borderColor = [[UIColor colorWithHexString:@"#999999"] CGColor];
    [self.contentView addSubview:immediatelySend];
    
    if ([state1 isEqualToString:@"001"]) {
        [btn setTitle:@"恢复发送" forState:UIControlStateNormal];
    }else if ([state1 isEqualToString:@"010"]){
        btn.frame = CGRectMake(0, 0, 0,0);
        cancel.frame = CGRectMake(20.0/375.0*APPLICATION_WIDTH,CGRectGetMaxY(textView.frame)+58, APPLICATION_WIDTH/2-10-20.0/375.0*APPLICATION_WIDTH, 44);
        immediatelySend.frame = CGRectMake(APPLICATION_WIDTH/2+10,CGRectGetMaxY(textView.frame)+58, APPLICATION_WIDTH/2-10-20.0/375.0*APPLICATION_WIDTH, 44);
        
    }else if ([state1 isEqualToString:@"101"]){
        [btn setTitle:@"重新发送" forState:UIControlStateNormal];
    }else if ([state1 isEqualToString:@"110"]||[state1 isEqualToString:@"111"]){
        [btn setTitle:@"查看复查结果" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
    }
    self.height = 10+15+13+textView.frame.size.height+58+44+50;
}
//立即发送
-(void)immediatelySend:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(immediatelySendPressed:)]) {
        [self.delegate immediatelySendPressed:btn];
    }
}
//取消发送
-(void)cancelSend:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(cancelSendPressed:)]) {
        [self.delegate cancelSendPressed:btn];
    }
}
//恢复发送 重新发送 查看复查结果
-(void)sendMessage:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(sendMessagePressed:)]) {
        [self.delegate sendMessagePressed:btn];
    }
    
}
-(CGFloat)getTextViewHeight:(NSString *)text font:(UIFont*)font width:(CGFloat)width;
{
    UITextView *textView = [[UITextView alloc] init];
    [textView setText:text];
    [textView setFont:font];
    
    CGSize size = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return size.height;
}
-(void)setInitializeDataWithPatient:(MJXPatients *)patient{
    
    UIImageView * headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 45, 45)];
    if (![patient.patientHeadImageUrl isKindOfClass:[NSNull class]]&&![patient.patientHeadImageUrl isEqualToString:@""]) {
        [headImageView sd_setImageWithURL:[NSURL URLWithString:patient.patientHeadImageUrl] placeholderImage:[UIImage imageNamed:@"woman"]];
        
    }else{
        if (![patient.patientSex isKindOfClass:[NSNull class]]&&[patient.patientSex isEqualToString:@"1"]) {
            headImageView.image=[UIImage imageNamed:@"woman"];
        }else{
            headImageView.image=[UIImage imageNamed:@"man"];
        }
        
    }
    UILabel * nameWithAge = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+13, 11, 200, 13)];
    nameWithAge.text =[NSString stringWithFormat:@"%@",patient.patientsName]; //patient.patientAge;
    [nameWithAge setTextColor:[UIColor colorWithHexString:@"#333333"]];
    nameWithAge.font = [UIFont systemFontOfSize:14];
    //算文字长度的
    CGSize detailSize1 = [nameWithAge.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    UILabel *age=[[UILabel alloc] initWithFrame:CGRectMake(nameWithAge.frame.origin.x+detailSize1.width, 11,60, 13)];
    age.text=[NSString stringWithFormat:@"    %@岁",patient.patientAge];
    [age setTextColor:[UIColor colorWithHexString:@"#333333"]];
    age.font = [UIFont systemFontOfSize:14];
    
    UILabel *diagnosis=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+13, CGRectGetMaxY(nameWithAge.frame)+16, 150, 13)];
    [diagnosis setTextColor:[UIColor colorWithHexString:@"#777777"]];
    diagnosis.font=[UIFont systemFontOfSize:13];
    diagnosis.text=[NSString stringWithFormat:@"%@",patient.patientNumberPhone];//@"诊断：啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊";
    //算文字长度的
    CGSize detailSize = [age.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(260, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    UIImageView * sexImageView=[[UIImageView alloc] initWithFrame:CGRectMake(age.frame.origin.x+detailSize.width, 11, 13, 13)];
    if (![patient.patientSex isKindOfClass:[NSNull class]]&&[patient.patientSex isEqualToString:@"女"]) {
        sexImageView.image=[UIImage imageNamed:@"girl"];
    }else{
        sexImageView.image=[UIImage imageNamed:@"boy"];
    }
    
    [self.contentView addSubview:age];
    [self.contentView addSubview:headImageView];
    [self.contentView addSubview:nameWithAge];
    [self.contentView addSubview:diagnosis];
    [self.contentView addSubview:sexImageView];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
//医生信息反馈
-(void)feedback{
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 11, 16)];
    image.image = [UIImage imageNamed:@"hua"];
    
    [self.contentView addSubview:image];
    
    UILabel * doct = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+5,12,70, 15)];
    doct.font = [UIFont systemFontOfSize:15];
    doct.textColor = [UIColor colorWithHexString:@"#333333"];
    doct.text = @"医嘱信息";
    
    [self.contentView addSubview:doct];
    
    UILabel * care = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(doct.frame), 13, 110, 15)];
    care.font = [UIFont systemFontOfSize:11];
    care.textColor = [UIColor colorWithHexString:@"#999999"];
    care.text = @"（关爱从反馈开始）";
    
    [self.contentView addSubview:care];
    
    UIView * lineW = [[UIView alloc] initWithFrame:CGRectMake(0, 40, APPLICATION_WIDTH, 1)];
    lineW.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    
    [self.contentView addSubview:lineW];
    
    NSArray * aryBtnText = [NSArray arrayWithObjects:@"本次复查完成",@"复查数据遗漏",@"复查结果异常", nil];
    for (int i = 0; i<3; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(APPLICATION_WIDTH/3*i, 40, APPLICATION_WIDTH/3, 40);
        [btn setTitle:aryBtnText[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn addTarget:self action:@selector(selectTheFeedback:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            btn.selected = YES;
            [btn setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
            _sign = 1;
        }
        btn.tag = i+1;
        [self.contentView addSubview:btn];
        
        if (i>0) {
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH/3*i, 50, 1, 20)];
            line.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
            
            [self.contentView addSubview:line];
        }
    }
    UIView * textBView = [[UIView alloc] initWithFrame:CGRectMake(10, 80, APPLICATION_WIDTH-20, 100)];
    textBView.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    
    [self.contentView addSubview:textBView];
    
    _textView.font = [UIFont systemFontOfSize:13];
    _textView.textColor = [UIColor colorWithHexString:@"#666666"];
    _textView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_textView];
    
    
    UIButton * sendInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    sendInfo.frame = CGRectMake(20, 40+100+40+30, APPLICATION_WIDTH-40, 40);
    [sendInfo setTitle:@"确定发送" forState:UIControlStateNormal];
    [sendInfo setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
    sendInfo.titleLabel.font = [UIFont systemFontOfSize:17];
    sendInfo.layer.cornerRadius = 5;
    sendInfo.layer.masksToBounds = YES;
    sendInfo.layer.borderWidth = 1;
    sendInfo.layer.borderColor = [[UIColor colorWithHexString:@"#01aeff"] CGColor];
    [sendInfo addTarget:self action:@selector(sendInfoBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:sendInfo];
    
    self.height = 40+40+100+30+50;
    
}
-(void)sendInfoBtn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(sendInfoBtnPressed)]) {
        [self.delegate sendInfoBtnPressed];
    }
}
-(void)selectTheFeedback:(UIButton *)btn{
    UIButton * t = [self viewWithTag:_sign];
    [t setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    _sign = (int)btn.tag;
    [btn setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectTheFeedbackPressed:)]) {
        [self.delegate selectTheFeedbackPressed:btn];
    }
    
}
//展示复查结果
-(void)addPatientsInfoWithTemplateName:(NSString *)templateName withTime:(NSString *)time withImageArray:(NSArray *)arrayImage withIllnessDescription:(NSString *)description{
    UILabel * labelTemplateName = [[UILabel alloc] initWithFrame:CGRectMake(15, 14, APPLICATION_WIDTH-100, 15)];
    labelTemplateName.font = [UIFont systemFontOfSize:15];
    labelTemplateName.textColor = [UIColor colorWithHexString:@"#333333"];
    labelTemplateName.text = [NSString stringWithFormat:@"方案名称：%@",templateName];
    [self.contentView addSubview:labelTemplateName];
    UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-85, 14, 85, 15)];
    timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.text = time;
    [self.contentView addSubview:timeLabel];
    UIView * lineW = [[UIView alloc] initWithFrame:CGRectMake(0, 40, APPLICATION_WIDTH, 1)];
    lineW.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [self.contentView addSubview:lineW];
    
    if (arrayImage.count>0&&arrayImage!=nil) {
        [_aryImage addObjectsFromArray:arrayImage];
        
    }else{
        _collectionView.frame = CGRectMake(0, 0, 0, 0);
    }
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [self.contentView addSubview:_collectionView];
    
    UILabel * dis = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_collectionView.frame)+15, APPLICATION_WIDTH-30, 0)];
    dis.font = [UIFont systemFontOfSize:13];
    dis.textColor = [UIColor colorWithHexString:@"#666666"];
    [dis setNumberOfLines:0];
    [self.contentView addSubview:dis];
    if (description.length>0&&description!=nil) {
        CGSize  h = [self heightForString:[NSString stringWithFormat:@"病情描述：%@",description] fontSize:13 andWidth:APPLICATION_WIDTH-30];
        dis.frame = CGRectMake(15,CGRectGetMaxY(_collectionView.frame), APPLICATION_WIDTH-30,h.height);
        dis.text = [NSString stringWithFormat:@"病情描述：%@",description];
    }else{
        dis.frame = CGRectMake(0, 0, 0, 0);
    }
    self.height = 40+10+_collectionView.frame.size.height+12+dis.frame.size.height+20;
}
//计算文字高度
-(CGSize)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_aryImage.count>0) {
        return _aryImage.count;
    }else
        return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MJXBrowsePicturesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    //cell.delegate = self;
    
    [cell addImageViewWithString:_aryImage[indexPath.row] withD:NO withTag:(int)indexPath.row];
    
    return cell;
}
#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(73, collectionView.bounds.size.height);
}

#pragma mark UICollectionViewDelegate
//初次点击走
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"%s",__func__);
    __weak typeof(self) weakSelf = self;
    ImageBrowserViewController * i = [[ImageBrowserViewController alloc] init];
    i.delegate = self;
    [i show:self.handleVC type:PhotoBroswerVCTypeZoom index:indexPath.row  deleteImage:NO imagesBlock:^NSArray *{
        return weakSelf.aryImage;
    }];
}
//有了初次点击再走这个
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf=self;
    
    ImageBrowserViewController * i = [[ImageBrowserViewController alloc] init];
    i.delegate = self;
    [i show:self.handleVC type:PhotoBroswerVCTypeZoom index:indexPath.row deleteImage:NO imagesBlock:^NSArray *{
        return weakSelf.aryImage;
    }];
}

@end
