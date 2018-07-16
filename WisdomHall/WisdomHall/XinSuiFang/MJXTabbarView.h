//
//  MJXTabbarView.h
//  XinSuiFang
//
//  Created by majinxing on 16/8/10.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJXTabbarItem.h"
#define TAB_BAR_HEIGHT 48.0f

@protocol MJXTaBarDelegate;

@interface MJXTabbarView : UIView
@property(nonatomic,strong)NSArray *tabItems;
@property(nonatomic,assign)id<MJXTaBarDelegate> delegate;
@property(nonatomic,assign) MJXTabbarItem *selectedItem;
- (void)setHighlightedItemSelected; // 使当前高亮的tabItem选中
- (void)setItemHilightedAndSelected:(MJXTabbarItem *)aItem;
- (void)setItemHilightedAndSelectedByTag:(NSUInteger )aItemTag;
- (void)setTabNew:(BOOL)isnew withIndex:(MJXTabbarItemType) viewType;

@end
@protocol MJXTaBarDelegate <NSObject>

- (void)tabBar:(MJXTabbarView *)tabBar didSelectItem:(MJXTabbarItem *)item;

@end
