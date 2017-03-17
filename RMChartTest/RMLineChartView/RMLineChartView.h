//
//  RMLineChartView.h
//  RMChartTest
//
//  Created by CETC-Server on 17/3/16.
//  Copyright © 2017年 CETC-Server. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RMCircleButton;
@interface RMLineChartView : UIView

@property (nonatomic, copy)NSArray *dataLists;

@end

@interface RMCircleButton : UIButton

@property (nonatomic, strong)UIColor *fillColor;//填充色
@property (nonatomic, strong)UIColor *strokeColor;//线条色
@property (nonatomic, assign)BOOL buttonSelected;//按钮选中状态

@end
