//
//  MJXCourseOfDiseaseTableViewCell.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/2.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXCourseOfDiseaseTableViewCell.h"
#import "MJXBrowsePicturesCollectionViewCell.h"
#import "MJXMyselfFlowLayout.h"
#import "UIImageView+WebCache.h"
#import "ImageBrowserViewController.h"

static NSString *cellIdentifier = @"cellIdentifier";

@interface MJXCourseOfDiseaseTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,MJXBrowsePicturesCollectionViewCellDelegate,ImageBrowserViewControllerDelegate>
{
    BOOL Nbool[100];
    BOOL NN;
}
@property (nonatomic,strong)NSMutableArray *picturesArry;//存储照片组信息
@property (nonatomic,strong)UIButton *addButton;
@property (nonatomic,strong)UICollectionView *collect;
@property (nonatomic,strong) UIView * lineH;//左边的竖线
@property (nonatomic,strong)UIImageView *camera;//添加按钮的背景图片
@property (nonatomic,strong)UILabel * add;
@property (nonatomic,assign) int tagButton;
@property (nonatomic,strong) UIView *contentViewfather;//父类视图
@property (nonatomic,strong)UIView *medicalHistory;//病史的父类视图
@property (nonatomic,strong)UIButton * history;//历史的按钮
@property (nonatomic,strong)UIImageView * imagebsxq;
@property (nonatomic,strong)UIImageView *head;//头像
@property (nonatomic,strong)UIImageView *imageList;//出院之类的
@end
@implementation MJXCourseOfDiseaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        _picturesArry=[NSMutableArray arrayWithCapacity:10];
        _collect=[[UICollectionView alloc] initWithFrame:CGRectMake(10, 10,APPLICATION_WIDTH-28-10, 75) collectionViewLayout:[[MJXMyselfFlowLayout alloc] init]];
        //注册
        [_collect registerClass:[MJXBrowsePicturesCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
        
        _collect.delegate = self;
        _collect.dataSource = self;
        _collect.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
        _collect.allowsMultipleSelection = YES;
        _collect.showsHorizontalScrollIndicator = NO;//取消滑动的滚动条
        _collect.decelerationRate = UIScrollViewDecelerationRateNormal;
        //创建长按手势监听
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(myHandleTableviewCellLongPressed:)];
        longPress.minimumPressDuration = 1.0;
        //将长按手势添加到需要实现长按操作的视图里
        [_collect addGestureRecognizer:longPress];
        
        _descriptionTextView = [[UITextView alloc] init];
        _descriptionTextView.backgroundColor = [UIColor colorWithHexString:@""];
        _descriptionTextView.scrollEnabled = NO;
        _descriptionTextView.showsVerticalScrollIndicator = NO;
        _descriptionTextView.showsHorizontalScrollIndicator = NO;
        _descriptionTextView.font = [UIFont systemFontOfSize:15];
        _descriptionTextView.backgroundColor = [UIColor whiteColor];
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
         [_addButton addTarget:self action:@selector(vistCamera:) forControlEvents:UIControlEventTouchUpInside];
        
        _lineH = [[UIView alloc] init];
        
         _camera = [[UIImageView alloc] init];
        _add = [[UILabel alloc] init];
        
        _contentViewfather = [[UIView alloc] init];
        _contentViewfather.layer.cornerRadius = 5;
        _contentViewfather.layer.masksToBounds = YES;
        _contentViewfather.backgroundColor = [UIColor whiteColor];
        _medicalHistory = [[UIView alloc] init];
        _medicalHistory.backgroundColor = [UIColor whiteColor];
        _history = [UIButton buttonWithType:UIButtonTypeCustom];
        _imagebsxq = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 11, 11)];
        _head = [[UIImageView alloc] init];
        _imageList = [[UIImageView alloc] init];
    }
    return self;
}
-(void)setHeadImageWithName:(NSString *)imageUrl withName:(NSString *)name withSex:(NSString *)sex{
    _head.frame = CGRectMake(12, 12, 36, 36);
    _head.layer.cornerRadius = 5;
    _head.layer.masksToBounds = YES;
    [_head sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"woman"]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_head.frame)+12, 23, 200, 15)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.text = name;
    //算文字长度的
    CGSize detailSize1 = [name sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    UIImageView * sexImage = [[UIImageView alloc] initWithFrame:CGRectMake(50+detailSize1.width+15, 23, 15, 15)];
    if ([sex isEqualToString:@"女"]) {
        sexImage.image = [UIImage imageNamed:@"girl"];
    }else{
        sexImage.image = [UIImage imageNamed:@"boy"];
    }
    [self.contentView addSubview:sexImage];
    
    [self.contentView addSubview:_head];
    
    [self.contentView addSubview:label];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(10.0/375.0*APPLICATION_WIDTH, 59, APPLICATION_WIDTH-2*10.0/375.0*APPLICATION_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [self.contentView addSubview:line];
    self.height = 60;
}
-(void)setDiagnosisTextWithString:(NSString *)str{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 23, 35, 15)];
    label.text = @"诊 断";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithHexString:@"#666666"];
    UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+15, 23, APPLICATION_WIDTH-CGRectGetMaxX(label.frame)-35, 15)];
    text.text = str;
    text.font = [UIFont systemFontOfSize:15];
    text.textColor = [UIColor colorWithHexString:@"#666666"];
    text.userInteractionEnabled = NO;
    UIImageView * bianji = [[UIImageView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-30, 25, 10, 10)];
    bianji.image = [UIImage imageNamed:@"bianji"];
    
    [self.contentView addSubview:label];
    [self.contentView addSubview:text];
    [self.contentView addSubview:bianji];
    
    UIButton * bj = [UIButton buttonWithType:UIButtonTypeCustom];
    bj.frame = CGRectMake(0, 0, APPLICATION_WIDTH, 50);
    [bj addTarget:self action:@selector(bjButton) forControlEvents:UIControlEventTouchUpInside];
    //[self.contentView addSubview:bj];
    

}
-(void)bjButton{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(bjButtonPressed)]) {
        [self.delegate bjButtonPressed];
    }

}
-(void)setFirstOptionWith:(NSString *)str{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(23, 0, APPLICATION_WIDTH-28, 46)];
    view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    [self.contentView addSubview:view];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(13, 15, 40, 20)];
    lable.text = str;
    lable.textColor = [UIColor colorWithHexString:@"#666666"];
    lable.font = [UIFont systemFontOfSize:15];
    [view addSubview:lable];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(13, 0, 1,40+6)];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.contentView addSubview:line];
    self.height = 40;
}

-(void)setTimeClassificationWithTitle:(NSString *)title withImageName:(NSString *)name{
    _imageList.frame = CGRectMake(3, 15, 20, 20);
    _imageList.image = [UIImage imageNamed:name];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageList.frame)+10, 18, 270, 13)];
    titleLab.text = title;
    titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
    titleLab.font = [UIFont systemFontOfSize:15];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(13,20, 1,40+6)];
    if ([name isEqualToString:@"首"]) {
        line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    }else{
        line.backgroundColor = [UIColor clearColor];
    }
    
    [self.contentView addSubview:line];
    [self.contentView addSubview:_imageList];
    [self.contentView addSubview:titleLab];
}
-(void)setTitle:(NSString *) title Button:(bool)B withButtonTag:(NSInteger)t ImageUrlArray:(NSArray *)ary Description:(NSString *)description  history:(NSString *)historyStr{
    if (B) {
        NN = YES;
    }else{
        NN = NO;
    }
    self.tagButton = (int)t;
    _lineH.frame = CGRectMake(13, 0, 1, 50);
    
    _lineH.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    
    [self.contentView addSubview:_lineH];
    
    NSString *str = [NSString stringWithFormat:@"%@",[self getImageNSStringWithTitle:title]];
    
    [self setTimeClassificationWithTitle:title withImageName:str];
    

    _camera.image = [UIImage imageNamed:@"tianjia"];
    
    _add.text = @"添加";
    _add.font = [UIFont systemFontOfSize:12];
    _add.textColor = [UIColor colorWithHexString:@"#01aeff"];
    
    [self.contentView addSubview:_camera];
    [self.contentView addSubview:_add];
    [self.contentView addSubview:_addButton];

    if (B) {
        _addButton.tag=t;
        _addButton.frame = CGRectMake(APPLICATION_WIDTH-70,0,70,40);
        _camera.frame = CGRectMake(APPLICATION_WIDTH-63, 19, 13, 13);
        _add.frame = CGRectMake(CGRectGetMaxX(_camera.frame)+5, 19, 30, 15);
    }else{
        _addButton.frame = CGRectMake(0,0,0,0);
        _camera.frame = CGRectMake(0,0,0,0);
        _add.frame = CGRectMake(0,0,0,0);
    }
    
   
    _contentViewfather.frame = CGRectMake(23,40, APPLICATION_WIDTH-28,10);
   
    
   [self.contentView addSubview:_contentViewfather];
    
    
    
    if ((long)[ary count]<0||ary==nil||ary.count==nil) {
        _collect.frame=CGRectMake(0, 0, 0, 0);
    }else{
        _collect.frame=CGRectMake(10, 10, _contentViewfather.frame.size.width-10, 73);
        [_picturesArry addObjectsFromArray:ary];
        [_collect reloadData];
    }

    if (description.length>0) {
        
    }else{
        description =@"";
    }
    NSString *str1 = [NSString stringWithFormat:@"病情描述：%@",description];
    CGSize detailSize1 = [self heightForString:str1 fontSize:15 andWidth:APPLICATION_WIDTH-28-20];
    
    _descriptionTextView.frame = CGRectMake(10,CGRectGetMaxY(_collect.frame)+10, _contentViewfather.frame.size.width-20,detailSize1.height);
    
    _descriptionTextView.tag = t;
   
    NSMutableAttributedString * attributedTextString = [[NSMutableAttributedString alloc] initWithString:str1];
    //设置的是字的颜色
    [attributedTextString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:NSMakeRange(0, 4)];
    NSRange rang=[str1 rangeOfString:str1];
    if (rang.length>5) {
        //设置的是字的颜色
        [attributedTextString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:NSMakeRange(5,rang.length-5)];
    }
    
    //设置的时字的字体及大小
    [attributedTextString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, rang.length)];
    _descriptionTextView.attributedText = attributedTextString;
    [_contentViewfather addSubview:_collect];
    [_contentViewfather addSubview:_descriptionTextView];
    
    int a = 0;
    if (!B) {
        _descriptionTextView.userInteractionEnabled = NO;
        a = 0;
    }else{
        _descriptionTextView.userInteractionEnabled = YES;
        _descriptionTextView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];

        a = 10;
    }
    
    if (_collect.frame.size.height>0) {
        //self.height = 146+detailSize1.height+a;
       // lineH.frame = CGRectMake(13, 0, 1,166+15+detailSize1.height);
        _contentViewfather.frame = CGRectMake(23,40, APPLICATION_WIDTH-28, 100+detailSize1.height+a);
    }else{
       _contentViewfather.frame = CGRectMake(23,40, APPLICATION_WIDTH-28,10+detailSize1.height+a);
       // self.height=56+detailSize1.height+a;
       // lineH.frame = CGRectMake(13, 0, 1,76+10+detailSize1.height);
    }
    
    _imagebsxq.image = [UIImage imageNamed:@"bsxq"];
    
    [_medicalHistory addSubview:_imagebsxq];
    

    
    _history.frame = CGRectMake(27, 0, APPLICATION_WIDTH-60, 40);
    
    [_history setTitle:[NSString stringWithFormat:@"添加病史详情 %@",historyStr] forState:UIControlStateNormal];
    [_history setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    
    _history.titleLabel.font = [UIFont systemFontOfSize:15];
    [_history addTarget:self action:@selector(historyButton) forControlEvents:UIControlEventTouchUpInside];
    _history.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [_medicalHistory addSubview:_history];
    
   
    if ([title isEqualToString:@"病史"]) {
        _medicalHistory.frame = CGRectMake(23,CGRectGetMaxY(_contentViewfather.frame)-10,APPLICATION_WIDTH-25,40);
        if (_collect.frame.size.height>0) {
            //self.height = 170+detailSize1.height+a;
           // lineH.frame = CGRectMake(13, 0, 1,213+6+detailSize1.height);

        }else{
            //self.height=110+detailSize1.height+a;
           // lineH.frame = CGRectMake(13, 0, 1,133+6+detailSize1.height);
        }
    }else{
        _medicalHistory.frame = CGRectMake(0, 0, 0, 0);
        _imagebsxq.frame = CGRectMake(0, 0, 0, 0);
        _history.frame = CGRectMake(0, 0, 0, 0);
        
    }
    if (B) {
//        medicalHistory.frame = CGRectMake(23,CGRectGetMaxY(contentView.frame)+10,APPLICATION_WIDTH-25,40);
        _contentViewfather .backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
        _medicalHistory.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    }
    [self.contentView addSubview:_medicalHistory];
    
    self.height = 40+_contentViewfather.frame.size.height+_medicalHistory.frame.size.height;
    _lineH.frame = CGRectMake(13, 0, 1,self.height+10);
    
}
-(CGSize)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize;
}


-(void)setPictureViewAndDescription{
    
}

-(void)descriptionButtonPressed:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(descriptionButtonPressedCD:)]) {
        [self.delegate descriptionButtonPressedCD:_addButton];
    }
    //return [NSString stringWithFormat:@"%ld", _addButton.tag];
}
//多媒体资料的添加
-(void)vistCamera:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(vistCameraButtonPressed:)]) {
        [self.delegate vistCameraButtonPressed:btn];
    }
}
-(void)historyButton{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(historyButtonPressed)]) {
        [self.delegate historyButtonPressed];
    }
}
-(NSString *)getImageNSStringWithTitle:(NSString *)title{

    if ([title isEqualToString:@"病史"]) {
       return @"bs";
    }else if ([title isEqualToString:@"化验"])
    {
        return @"hy";
    }else if ([title isEqualToString:@"影像"])
    {
        return @"影像";
    }else if ([title isEqualToString:@"用药"]){
        return @"yy";
    }
     return nil;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark UICollectionViewDataSource
//长按手势响应方法 删除图片
-(void)myHandleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer{
    if (!NN) {
        return;
    }
    CGPoint pointTouch = [gestureRecognizer locationInView:self.collect];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        NSIndexPath *indexPath = [self.collect indexPathForItemAtPoint:pointTouch];
        NSLog(@"%ld",indexPath.row);
        Nbool[indexPath.row] = YES;//是否展示删除按钮
        [_collect reloadData];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_picturesArry.count>0) {
//        if (_picturesArry.count>=8) {
//            return 8;
//        }
        return _picturesArry.count;
    }else
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MJXBrowsePicturesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    NSString *number = [NSString stringWithFormat:@"%d%ld",self.tagButton,indexPath.row];
    if ([[_picturesArry objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
        [cell addImageViewWithString:_picturesArry[indexPath.row] withD:Nbool[indexPath.row] withTag:[number intValue]];
    }else{
        [cell addImageViewWithImage:_picturesArry[indexPath.row] withD:Nbool[indexPath.row] withTag:[number intValue]];
    }
   
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
    __weak typeof(self) weakSelf=self;
    ImageBrowserViewController * i = [[ImageBrowserViewController alloc] init];
    i.delegate = self;
    [i show:self.handleVC type:PhotoBroswerVCTypeZoom index:indexPath.row deleteImage:NN imagesBlock:^NSArray *{
         return weakSelf.picturesArry;
    }];
}
//有了初次点击再走这个
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf=self;
    
    ImageBrowserViewController * i = [[ImageBrowserViewController alloc] init];
    i.delegate = self;
   
    [i show:self.handleVC type:PhotoBroswerVCTypeZoom index:indexPath.row deleteImage:NN imagesBlock:^NSArray *{
        return weakSelf.picturesArry;
    }];
}
#pragma mark 大图删除按钮
-(void)imageBrowserVCDeleteImageButtonPressed:(UIButton *) btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(delecateImagefromBrowsePicturesCollectionViewCellDelegated:)]) {
        btn.tag = [[NSString stringWithFormat:@"%d%ld",self.tagButton,btn.tag] intValue];
        [self.delegate delecateImagefromBrowsePicturesCollectionViewCellDelegated:btn];
    }
}
#pragma mark MJXBrowsePicturesCollectionViewCellDelegate
-(void)MJXBrowsePicturesCollectionViewCellDelegatedelecateImagePressed:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(delecateImagefromBrowsePicturesCollectionViewCellDelegated:)]) {
        [self.delegate delecateImagefromBrowsePicturesCollectionViewCellDelegated:btn];
    }
}
@end
