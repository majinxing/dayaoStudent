//
//  ClassManagementViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/4.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "ClassManagementViewController.h"
#import "PersonalCollectionViewCell.h"
#import "DYHeader.h"
#import "CollectionFlowLayout.h"
static NSString *cellIdentifier = @"cellIdentifierPersonal";

@interface ClassManagementViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView * collection;

@end

@implementation ClassManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle];
    [self addCollectionView];
    // Do any additional setup after loading the view from its nib.
}
-(void)addCollectionView{
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64,APPLICATION_WIDTH,APPLICATION_HEIGHT-64) collectionViewLayout:[[CollectionFlowLayout alloc] init]];
    //注册
    [_collection registerClass:[PersonalCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.allowsMultipleSelection = YES;
    _collection.showsVerticalScrollIndicator = NO;
    _collection.showsHorizontalScrollIndicator = NO;
    //取消滑动的滚动条
    _collection.decelerationRate = UIScrollViewDecelerationRateNormal;
    self.collection.alwaysBounceVertical = YES; //垂直方向遇到边框是否总是反弹

    _collection.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collection];

}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //[self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                                      NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.title = @"人员管理";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UICollectionViewDataSource
//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 5, 15, 5);//分别为上、左、下、右
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_manage == MeetingManageType) {
        if (_meeting.signAry.count>0) {
            return _meeting.signAry.count;
        }
    }else if (_manage == ClassManageType){
        if (_signAry.count>0) {
            return _signAry.count;
        }else{
            return 0;
        }
    }
    
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (_manage == MeetingManageType) {
        [cell setPersonalInfo:_meeting.signAry[indexPath.row]];
    }else{
        [cell setPersonalInfo:_signAry[indexPath.row]];
    }
    return cell;
    //    CourseCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    //    return cell1;
    
    
}
#pragma mark UICollectionViewDelegate
//初次点击走
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
//有了初次点击再走这个
- (void)collectionView:(UICollectionView *)collectionView
didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__func__);
    
}
//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
};
//两个cell之间的间距（同一行的cell的间距）
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
};

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString * str = [UIUtils deviceVersion];
    BOOL b = [str hasPrefix:@"iPhone 5"];
    if (b) {
        return CGSizeMake(APPLICATION_WIDTH/3-10, APPLICATION_WIDTH/3+10);
    }else
    return CGSizeMake(APPLICATION_WIDTH/4-10, APPLICATION_WIDTH/4+25);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
