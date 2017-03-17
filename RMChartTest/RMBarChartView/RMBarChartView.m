//
//  RMBarChartView.m
//  RMChartTest
//
//  Created by CETC-Server on 17/3/17.
//  Copyright © 2017年 CETC-Server. All rights reserved.
//

#import "RMBarChartView.h"
#import "RMChartModel.h"
#import "CommonHeader.h"

const CGFloat RMBarChartViewLeftTextWidth = 30.f;//左边标示文本宽度
const CGFloat RMBarChartViewBottomTextHeight = 20.f;//底部标示文本高度
const CGFloat RMBarChartViewPadding = 10.f;//边距
const NSUInteger RMBarChartViewHorizontalLineCount = 5;//水平线数

@interface RMBarChartView()
{
    CGFloat _validWidth;
    CGFloat _validHeight;
    NSArray *_leftRuleTextArray;//左边文本列表数据
    NSInteger _maxRule;
    NSInteger _midRule;
    NSInteger _minRule;
}

@end

@implementation RMBarChartView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _validHeight = CGRectGetHeight(self.frame) - RMBarChartViewBottomTextHeight;
        _validWidth = CGRectGetWidth(self.frame) - RMBarChartViewLeftTextWidth - RMBarChartViewPadding;
        
    }
    return self;
}


- (void)setDataLists:(NSArray *)dataLists{
    _dataLists = dataLists;
    //重绘标尺和折线
    _minRule = MAXFLOAT;
    _maxRule = -_minRule;
    [dataLists enumerateObjectsUsingBlock:^(RMChartModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger val = [obj.value integerValue];
       if (val < _minRule) {
           _minRule = val;
        }
        if (val > _maxRule) {
            _maxRule = val + 1;
        }
    }];
    //容错处理
    if(_maxRule <= 10){
        _maxRule = 10;
    }
    if (_minRule == _maxRule) {
        _minRule = 0;
    }
    
    _midRule = (_minRule + _maxRule)/2;
    _leftRuleTextArray = @[[self stringWithInteger:_minRule],
                          [self stringWithInteger:_midRule],
                          [self stringWithInteger:_maxRule]];

    [self setNeedsDisplay];
}

- (NSString *)stringWithInteger:(NSInteger)val{
    return  [NSString stringWithFormat:@"%ld", val];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self drawRulerLine];
    [self drawText];
    [self drawBarGraph];
}

//画标尺线
- (void)drawRulerLine{
    //画竖线
    UIBezierPath *verticalLinePath = [UIBezierPath bezierPath];
    [verticalLinePath moveToPoint:CGPointMake(RMBarChartViewLeftTextWidth, 0)];
    [verticalLinePath addLineToPoint:CGPointMake(RMBarChartViewLeftTextWidth, _validHeight)];
    [RMGRAYLINECOLOR setStroke];
    [verticalLinePath stroke];
    
    //画横线
    CGFloat lineY = RMBarChartViewPadding;
    CGFloat linePadding = (_validHeight - RMBarChartViewPadding)/(RMBarChartViewHorizontalLineCount - 1);
    for (NSInteger i = 0; i < RMBarChartViewHorizontalLineCount; i++) {
        UIBezierPath *horizontalLinePath = [UIBezierPath bezierPath];
        [horizontalLinePath moveToPoint:CGPointMake(RMBarChartViewLeftTextWidth, lineY)];
        [horizontalLinePath addLineToPoint:CGPointMake(CGRectGetWidth(self.frame) - RMBarChartViewPadding, lineY)];
        [RMGRAYLINECOLOR setStroke];
        [horizontalLinePath stroke];
        lineY += linePadding;
    }
}

//文本
- (void)drawText{
    //设置文本样式属性
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle]mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributeDict = @{NSFontAttributeName : RMFONT(10),
                        NSForegroundColorAttributeName : RMBLACKCOLOR,
                        NSParagraphStyleAttributeName : paragraphStyle};
    //垂直文本 (从上往下)
    CGFloat vPadding = _validHeight/([_leftRuleTextArray count] - 1);
    CGFloat textY = 0;
    for (NSInteger i = [_leftRuleTextArray count] - 1; i >= 0; i -- ) {
        NSString *ruleText = _leftRuleTextArray[i];
        if (i == 0) {
            textY -= 10;
        }
        [ruleText drawInRect:CGRectMake(0, textY, RMBarChartViewLeftTextWidth - 5, 10) withAttributes:attributeDict];
        textY += vPadding;
    }
    //水平文本
    CGFloat hPadding = _validWidth/([_dataLists count]);
    for (NSInteger i = 0; i < [_dataLists count]; i ++ ) {
        RMChartModel *model = _dataLists[i];
        NSString *hRuleText = model.dateTime;
        [hRuleText drawInRect:CGRectMake(RMBarChartViewLeftTextWidth + hPadding * i, _validHeight, hPadding, RMBarChartViewBottomTextHeight)
                withAttributes:attributeDict];
    }
}

//柱状图
- (void)drawBarGraph{
    CGFloat scaleY = 1.0/(_maxRule - _minRule)*(_validHeight);
    CGFloat hPadding = _validWidth/_dataLists.count;
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < _dataLists.count; i++) {
        CGFloat startX = RMBarChartViewLeftTextWidth + hPadding/2 + hPadding * i;
        RMChartModel *model = _dataLists[i];
        [path moveToPoint:CGPointMake(startX, _validHeight)];
        [path addLineToPoint:CGPointMake(startX, _validHeight - [model.value floatValue]*scaleY)];
    }
    path.lineWidth = 10.f;
    [[UIColor blueColor] setStroke];
    [path stroke];
}


@end