//
//  InteractiveViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/24.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "InteractiveViewController.h"
#import "CourseCollectionViewCell.h"
#import "CollectionFlowLayout.h"
#import "DYHeader.h"
static NSString * cellIdentifier = @"cellIdentifier";

@interface InteractiveViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView * collection;
@end

@implementation InteractiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle];
    // Do any additional setup after loading the view from its nib.
}
/**
 * 添加collection
 **/
-(void)addCollection{
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64,APPLICATION_WIDTH,APPLICATION_HEIGHT-64-48) collectionViewLayout:[[CollectionFlowLayout alloc] init]];
    //注册
    [_collection registerClass:[CourseCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.allowsMultipleSelection = YES;
    _collection.showsVerticalScrollIndicator = NO;
    _collection.showsHorizontalScrollIndicator = NO;
    //取消滑动的滚动条
    _collection.decelerationRate = UIScrollViewDecelerationRateNormal;
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
    self.title = @"会场";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UICollectionViewDataSource
//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 15);//分别为上、左、下、右
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CourseCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    //[cell addCourseInfo];
    return cell;
    //    CourseCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    //    return cell1;
    
    
}
#pragma mark UICollectionViewDelegate
//初次点击走
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__func__);
    
}
//有了初次点击再走这个
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__func__);
    
}
#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(APPLICATION_WIDTH/2-20, 209);
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
