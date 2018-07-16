//
//  MJXTabbarView.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/10.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXTabbarView.h"
#import "UIColor+HexString.h"

#define ITEM_ICON_WIDTH 25.f
#define scal SYSTEM_SCREEN_WIDTH/320
#define TTCommonFont(t) ([UIFont fontWithName:@"MFYueHei_Noncommercial-Regular" size:t])
@interface MJXTabbarView ()
@property(nonatomic,strong)UIButton *highlighted;//当前高亮视图
@end
@implementation MJXTabbarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [self setFrame:frame];
        [self layoutViews];
        
    }
    return self;
}
- (void)layoutViews
{
    self.backgroundColor = [UIColor whiteColor];//mjx
    
    UIToolbar *tabToolBar = [[UIToolbar alloc] initWithFrame:self.bounds];
    tabToolBar.translucent = YES;
    [self addSubview:tabToolBar];
    
    // 删除UIToolBar的默认阴影
    for (UIView *subView in tabToolBar.subviews)
    {
        Class _UIToolbarBackground = NSClassFromString(@"_UIToolbarBackground");
        if ([subView isKindOfClass:[UIImageView class]] && ![subView isKindOfClass:_UIToolbarBackground])
        {
            [subView removeFromSuperview];
        }
    }
    // 添加自定义阴影视图
    UIImageView *shadowImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bookshelf_tabbar_shadow"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f) resizingMode:UIImageResizingModeStretch]];
    shadowImageView.frame = CGRectMake(0.0f, -10.0f, tabToolBar.frame.size.width, 10.0f);
    [tabToolBar addSubview:shadowImageView];
    self.clipsToBounds = NO;
    tabToolBar.clipsToBounds = NO;
}

- (void)setTabItems:(NSArray *)tabItems
{
    if(_tabItems != tabItems)
    {
        _tabItems = tabItems;
        
        if (self.tabItems)
        {
            NSInteger tabCount = [self.tabItems count];
            if (tabCount > 0)
            {
                NSInteger top = 0.0f;
                CGRect tabFrame = CGRectMake(0.0f, top, self.frame.size.width / tabCount, self.frame.size.height);
                
                for (int i = 0; i < tabCount; i++)
                {
                    id curTab = [self.tabItems objectAtIndex:i];
                    if ([curTab isKindOfClass:[MJXTabbarItem class]])
                    {
                        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        itemButton.frame = tabFrame;
                        MJXTabbarItem *tabItem = (MJXTabbarItem *)curTab;
                        itemButton.tag = tabItem.tag;
                        itemButton.backgroundColor = [UIColor clearColor];
                        [itemButton setImage:tabItem.image forState:UIControlStateNormal];
                        [itemButton setImage:tabItem.selectedImage forState:UIControlStateHighlighted];
                        
                        itemButton.titleLabel.font = [UIFont systemFontOfSize:12] ;//TTCommonFont(10);
                        [itemButton setTitle:tabItem.title forState:UIControlStateNormal];
                        [itemButton setTitleColor:[UIColor colorWithHexString:@"#666666" alpha:1.0f]
                                         forState:UIControlStateNormal];
                        [itemButton setTitleColor:[UIColor colorWithHexString:@"#01aeff"]
                                         forState:UIControlStateHighlighted];
//                        itemButton.backgroundColor=[UIColor blueColor];
                        // 默认第一个选中
                        if (tabItem.tag == ETabBarItemTypeHomeRecommend)
                        {
                            // 高亮选中
                            
                            [itemButton setImage:tabItem.selectedImage forState:UIControlStateNormal];
                            [itemButton setTitleColor:[UIColor colorWithHexString:@"#01aeff"]
                                             forState:UIControlStateNormal];
                            _highlighted = itemButton;
                            _selectedItem = curTab;
                        }
                        //                        itemButton.imageView.frame=itemButton.titleLabel.frame;
                        // 重新布局,微调image和title
                        
                        CGPoint imageCenter = itemButton.imageView.center;
                        CGPoint titleCenter = itemButton.titleLabel.center;
                        itemButton.titleEdgeInsets = UIEdgeInsetsMake(28.f + top, itemButton.frame.size.width - 2*titleCenter.x + itemButton.tag / 2, 0.0,0 );
                        
                        //                        itemButton.titleLabel.backgroundColor=[UIColor redColor];
                        if (i==0) {
                            //                            itemButton.imageView.backgroundColor=[UIColor redColor];
                            //调整练琴房吉他图片的位置
                            itemButton.imageEdgeInsets = UIEdgeInsetsMake(-14.f - top, itemButton.frame.size.width - titleCenter.x-5.7, 0.0, 0.f);
                        }else{
                            itemButton.imageEdgeInsets = UIEdgeInsetsMake(-14.f - top, itemButton.frame.size.width - 2*imageCenter.x, 0.0, 0.f);
                        }
                        
                        
                        
                        
                        [itemButton addTarget:self action:@selector(tabItemClicked:) forControlEvents:UIControlEventTouchUpInside];
                        [self addSubview:itemButton];
                        tabFrame.origin.x += self.frame.size.width / tabCount;
                    }
                }
            }
        }
    }
}
//响应按钮事件，出来按钮图片的转换
- (void)tabItemClicked:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]])
    {
        UIButton *selectedButton = (UIButton *)sender;
        MJXTabbarItem *curItem = [self.tabItems objectAtIndex:selectedButton.tag];
        MJXTabbarItem *highlightedItem = [self.tabItems objectAtIndex:_highlighted.tag];
        // 恢复常规态
        [_highlighted setImage:highlightedItem.image forState:UIControlStateNormal];
        [_highlighted setTitleColor:[UIColor colorWithHexString:@"#666666" alpha:1.0f]
                           forState:UIControlStateNormal];
        
        _highlighted = selectedButton; // 需高亮
        [_highlighted setImage:curItem.selectedImage forState:UIControlStateNormal];
        [_highlighted setTitleColor:[UIColor colorWithHexString:@"#01aeff"]
                           forState:UIControlStateNormal];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:didSelectItem:)])
        {
            [self.delegate tabBar:self didSelectItem:curItem];
            _selectedItem = curItem;
        }
    }
}
- (void)setItemHilightedAndSelected:(MJXTabbarItem *)aItem
{
    for (UIView *subView in self.subviews)
    {
        if ([subView isKindOfClass:[UIButton class]])
        {
            UIButton *curButton = (UIButton *)subView;
            if (curButton.tag == aItem.tag)
            {
                // 恢复常规态
                MJXTabbarItem *highlightedItem = [self.tabItems objectAtIndex:_highlighted.tag];
                [_highlighted setImage:highlightedItem.image forState:UIControlStateNormal];
                [_highlighted setTitleColor:[UIColor colorWithHexString:@"#666666" alpha:1.0f]
                                   forState:UIControlStateNormal];
                
                _highlighted = curButton; // 需高亮
                [_highlighted setImage:aItem.selectedImage forState:UIControlStateNormal];
                [_highlighted setTitleColor:[UIColor colorWithHexString:@"#01aeff"]
                                   forState:UIControlStateNormal];
                
                self.selectedItem = aItem;
                break;
            }
        }
    }
}
- (void)setItemHilightedAndSelectedByTag:(NSUInteger)aItemTag
{
    MJXTabbarItem *selectedItem = [self.tabItems objectAtIndex:aItemTag];
    
    [self setItemHilightedAndSelected:selectedItem];
}

- (void)setHighlightedItemSelected
{
    if (_highlighted)
    {
        _selectedItem = [self.tabItems objectAtIndex:_highlighted.tag];
    }
}
- (void)setTabNew:(BOOL)isnew withIndex:(MJXTabbarItemType) viewType
{
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
