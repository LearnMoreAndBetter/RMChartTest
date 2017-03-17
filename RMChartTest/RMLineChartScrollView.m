//
//  RMLineChartScrollView.m
//  RMChartTest
//
//  Created by CETC-Server on 17/3/17.
//  Copyright © 2017年 CETC-Server. All rights reserved.
//

#import "RMLineChartScrollView.h"
#import "RMLineChartView.h"
#import "RMChartModel.h"
#import "CommonHeader.h"

@interface RMLineChartScrollView()<UIScrollViewDelegate>
{
    //左中右折线视图
    RMLineChartView *_leftLineView;
    RMLineChartView *_midLineView;
    RMLineChartView *_rightLineView;
    
    
    NSInteger _chartCount;         //图标数量
    
    NSInteger _currentIndex;       //当前滑动的index

}

@property (nonatomic, strong)UIScrollView *chartScrollView;  //折线滚动视图
@property (nonatomic, strong)UIPageControl *pageCtrl;    //页码控制
@property (nonatomic, strong)UILabel *titleLabel;      //标题

@end

@implementation RMLineChartScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)setDataLists:(NSArray *)dataLists{
    _dataLists = dataLists;
    _chartCount = [dataLists count];
    self.pageCtrl.numberOfPages = [dataLists count];
    self.pageCtrl.currentPage = 0;
    [self loadChartData];
}

- (void)createUI{
    //左button
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftBtn setImage:[UIImage imageNamed:@"btn_previous"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"btn_previous"] forState:UIControlStateDisabled];
    [leftBtn addTarget:self action:@selector(onLeft) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftBtn];
    
    //右button
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - 40, 0, 40, 40);
    [rightBtn setImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateDisabled];
    [rightBtn addTarget:self action:@selector(onRight) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    
    //标题
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(leftBtn.frame), 0, CGRectGetWidth(self.frame) - CGRectGetMaxX(leftBtn.frame) * 2, 40);
    [self addSubview:self.titleLabel];
    
    //scrollView
    CGFloat pageHeight = 20;
    self.chartScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + 10, CGRectGetWidth(self.frame),
            CGRectGetHeight(self.frame) - CGRectGetMaxY(self.titleLabel.frame) - pageHeight - 10);
    self.chartScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.chartScrollView.frame) * 3, CGRectGetHeight(self.chartScrollView.frame));
    self.chartScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.chartScrollView.frame), 0);
    [self addSubview:self.chartScrollView];
    [self addChartLineView];
    
    //pageCtrl
    self.pageCtrl.frame = CGRectMake(0, CGRectGetMaxY(self.chartScrollView.frame), CGRectGetWidth(self.chartScrollView.frame), pageHeight);
    [self addSubview:self.pageCtrl];
}

//图表
- (void)addChartLineView{
    CGFloat hpadding = 10;
    _leftLineView = [[RMLineChartView alloc] initWithFrame:CGRectMake(hpadding, 0,
            CGRectGetWidth(self.chartScrollView.frame) - hpadding * 2,
                CGRectGetHeight(self.chartScrollView.frame))];
    
    _midLineView = [[RMLineChartView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.chartScrollView.frame) + hpadding,
                            0, CGRectGetWidth(self.chartScrollView.frame) - hpadding * 2,
                                CGRectGetHeight(self.chartScrollView.frame))];
    
    _rightLineView = [[RMLineChartView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.chartScrollView.frame)*2 + hpadding,
                            0, CGRectGetWidth(self.chartScrollView.frame) - hpadding * 2,
                                CGRectGetHeight(self.chartScrollView.frame))];
    
    [self.chartScrollView addSubview:_leftLineView];
    [self.chartScrollView addSubview:_midLineView];
    [self.chartScrollView addSubview:_rightLineView];
}


- (void)onRight{
    [UIView animateWithDuration:0.5 animations:^{
        self.chartScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.chartScrollView.frame) * 2, 0);
    } completion:^(BOOL finished) {
        [self loadChartData];
    }];
}

- (void)onLeft{
    [UIView animateWithDuration:0.5 animations:^{
        self.chartScrollView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        [self loadChartData];
    }];
}

#pragma mark - scrollView

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self loadChartData];
}

- (NSInteger)preIndexWith:(NSInteger)index{
    return (index + _chartCount - 1) % _chartCount;
}

- (NSInteger)nextIndexWith:(NSInteger)index{
    return (_currentIndex + 1) % _chartCount;
}

- (void)loadChartData{
    //右滑
    if (self.chartScrollView.contentOffset.x > CGRectGetWidth(self.chartScrollView.frame)) {
        _currentIndex = [self nextIndexWith:_currentIndex];
    }else if (self.chartScrollView.contentOffset.x < CGRectGetWidth(self.chartScrollView.frame)){//左滑
        _currentIndex = [self preIndexWith:_currentIndex];
    }
    
    NSInteger preIndex = [self preIndexWith:_currentIndex];
    NSInteger nextIndex = [self nextIndexWith:_currentIndex];
    
    _leftLineView.dataLists = _dataLists[preIndex][@"list"];
    _midLineView.dataLists = _dataLists[_currentIndex][@"list"];
    _rightLineView.dataLists = _dataLists[nextIndex][@"list"];
    
    self.pageCtrl.currentPage = _currentIndex;
    self.titleLabel.text = _dataLists[_currentIndex][@"title"];
    
    self.chartScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.chartScrollView.frame), 0);
}




#pragma mark- getter

- (UIScrollView *)chartScrollView{
    if (!_chartScrollView) {
        _chartScrollView = [[UIScrollView alloc] init];
        _chartScrollView.pagingEnabled = YES;
        _chartScrollView.delegate = self;
        _chartScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _chartScrollView;
}

- (UIPageControl *)pageCtrl{
    if (!_pageCtrl) {
        _pageCtrl = [[UIPageControl alloc] init];
        _pageCtrl.pageIndicatorTintColor = RMGRAYLINECOLOR;
        _pageCtrl.currentPageIndicatorTintColor = RM_MAIN_COLOR;
    }
    return _pageCtrl;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = RMFONT(16);
        _titleLabel.textColor = RMBLACKCOLOR;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
