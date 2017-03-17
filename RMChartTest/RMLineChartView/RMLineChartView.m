//
//  RMLineChartView.m
//  RMChartTest
//
//  Created by CETC-Server on 17/3/16.
//  Copyright © 2017年 CETC-Server. All rights reserved.
//

#import "RMLineChartView.h"
#import "CommonHeader.h"
#import "RMChartModel.h"

const CGFloat RMLineChartViewLeftTextWidth = 30.f;//左边标示文本宽度
const CGFloat RMLineChartViewBottomTextHeight = 20.f;//底部标示文本高度
const CGFloat RMLineChartViewPadding = 10.f;//边距
const NSUInteger RMLineChartViewHorizontalLineCount = 5;//水平线数

@interface RMLineChartView()
{
    CGFloat _validWidth;
    CGFloat _validHeight;
    NSArray *_leftRuleTextArray;//左边文本列表数据
    NSInteger _maxRule;
    NSInteger _midRule;
    NSInteger _minRule;
    UIView *_popView;//浮层
    RMCircleButton *_selectButton;
}
@property (nonatomic, copy)NSMutableArray *circleButtonArray;//存放button的数组

@end

@implementation RMLineChartView

- (NSMutableArray *)circleButtonArray{
    if (!_circleButtonArray) {
        _circleButtonArray = [NSMutableArray array];
    }
    return _circleButtonArray;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _validHeight = CGRectGetHeight(self.frame) - RMLineChartViewBottomTextHeight;
        _validWidth = CGRectGetWidth(self.frame) - RMLineChartViewLeftTextWidth - RMLineChartViewPadding;
        
    }
    return self;
}

//数据处理,刷新页面
- (void)setDataLists:(NSArray *)dataLists{
    _dataLists = dataLists;
    //移除浮层
    [_popView removeFromSuperview];
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


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self drawRulerLine];
    [self drawText];
    [self drawFoldLine];
}

//画标尺线
- (void)drawRulerLine{
    //画竖线
    UIBezierPath *verticalLinePath = [UIBezierPath bezierPath];
    [verticalLinePath moveToPoint:CGPointMake(RMLineChartViewLeftTextWidth, 0)];
    [verticalLinePath addLineToPoint:CGPointMake(RMLineChartViewLeftTextWidth, _validHeight)];
    [RMGRAYLINECOLOR setStroke];
    [verticalLinePath stroke];
    
    //画横线
    CGFloat lineY = RMLineChartViewPadding;
    CGFloat linePadding = (_validHeight - RMLineChartViewPadding)/(RMLineChartViewHorizontalLineCount - 1);
    for (NSInteger i = 0; i < RMLineChartViewHorizontalLineCount; i++) {
        UIBezierPath *horizontalLinePath = [UIBezierPath bezierPath];
        [horizontalLinePath moveToPoint:CGPointMake(RMLineChartViewLeftTextWidth, lineY)];
        [horizontalLinePath addLineToPoint:CGPointMake(CGRectGetWidth(self.frame) - RMLineChartViewPadding, lineY)];
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
        [ruleText drawInRect:CGRectMake(0, textY, RMLineChartViewLeftTextWidth - 5, 10) withAttributes:attributeDict];
        textY += vPadding;
    }
    //水平文本
    CGFloat hPadding = _validWidth/([_dataLists count]);
    for (NSInteger i = 0; i < [_dataLists count]; i ++ ) {
        RMChartModel *model = _dataLists[i];
        NSString *hRuleText = model.dateTime;
        [hRuleText drawInRect:CGRectMake(RMLineChartViewLeftTextWidth + hPadding * i, _validHeight + 5, hPadding, RMLineChartViewBottomTextHeight - 5)
                withAttributes:attributeDict];
    }
}

//画折线，和拐角button
- (void)drawFoldLine{
    [self.circleButtonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.circleButtonArray removeAllObjects];
    CGFloat scaleY = 1.0/(_maxRule - _minRule)*(_validHeight);
    CGFloat hPadding = _validWidth/_dataLists.count;
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < [_dataLists count]; i ++) {
        RMChartModel *model = _dataLists[i];
        CGPoint startPoint = CGPointMake(RMLineChartViewLeftTextWidth + hPadding/2 + hPadding * i, _validHeight - ([model.value floatValue] - _minRule)* scaleY);
        if (i != [_dataLists count] - 1) {
            RMChartModel *nextModel = _dataLists[i + 1];
            CGPoint endPoint = CGPointMake(RMLineChartViewLeftTextWidth + hPadding/2 + hPadding * (i+1), _validHeight - ([nextModel.value floatValue] - _minRule)* scaleY);
            [path moveToPoint:startPoint];
            [path addLineToPoint:endPoint];
        }
        
        //添加拐角button
        RMCircleButton *circleBtn = [[RMCircleButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        circleBtn.backgroundColor =  [UIColor clearColor];
        circleBtn.strokeColor = RMBLACKCOLOR;
        circleBtn.fillColor =  [UIColor whiteColor];
        circleBtn.center = startPoint;
        circleBtn.tag = i + 101;
        [circleBtn addTarget:self action:@selector(clickCircle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:circleBtn];
        [self.circleButtonArray addObject:circleBtn];
    }
    //path.lineWidth = 2;
    [RMBLACKCOLOR setStroke];
    [path stroke];
}

//点击效果
- (void)clickCircle:(RMCircleButton *)button{
    _selectButton = button;
    [_popView removeFromSuperview];
    for (RMCircleButton *btn in self.circleButtonArray) {
        btn.buttonSelected = NO;
    }
    button.buttonSelected = !button.buttonSelected;
    RMChartModel *model = _dataLists[button.tag - 101];
    _popView = [self drawPopViewAtPoint:button.center withText:model.value];
    [self addSubview:_popView];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_popView removeFromSuperview];
    _selectButton.buttonSelected = NO;
}

//画浮层
- (UIView *)drawPopViewAtPoint:(CGPoint)point withText:(NSString *)text{
    CGFloat vPadding = 10.f;
    UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    popView.center = CGPointMake(point.x, point.y - 30/2 - vPadding);
    
    UILabel *dataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    dataLabel.text = text;
    dataLabel.textAlignment = NSTextAlignmentCenter;
    dataLabel.font = RMFONT(10);
    dataLabel.textColor = [UIColor whiteColor];
    dataLabel.backgroundColor = RM_MAIN_COLOR;
    dataLabel.layer.cornerRadius = 6;
    dataLabel.clipsToBounds = YES;
    [popView addSubview:dataLabel];
    
    //画三角号
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(50/2, 30)];
    [path addLineToPoint:CGPointMake(50/2 - 5, 20)];
    [path addLineToPoint:CGPointMake(50/2 + 5, 20)];
    [path closePath];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = RM_MAIN_COLOR.CGColor;
    [popView.layer addSublayer:layer];
  
    //超出边界 旋转 180
    if (CGRectGetMinY(popView.frame) < 0) {
        popView.center = CGPointMake(point.x, point.y + 30/2 + vPadding);
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
        popView.transform = transform;
        dataLabel.transform = transform;
    }
    
    return popView;
}

@end

#pragma mark- 拐点圆圈button
@implementation RMCircleButton

- (void)drawRect:(CGRect)rect{
    CGFloat diam = 5;
    CGFloat insetStart = (CGRectGetWidth(rect) - diam)/2;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, insetStart, insetStart)];
    path.lineWidth = 2;
    [self.fillColor setFill];
    [self.strokeColor setStroke];
    [path stroke];
    [path fill];
}

- (void)setButtonSelected:(BOOL)buttonSelected{
    _buttonSelected = buttonSelected;
    if (buttonSelected) {
        self.fillColor = RM_MAIN_COLOR;
        self.strokeColor = RM_MAIN_COLOR;
    }else{
        self.fillColor = [UIColor clearColor];
        self.strokeColor = RMBLACKCOLOR;
    }
}

@end

