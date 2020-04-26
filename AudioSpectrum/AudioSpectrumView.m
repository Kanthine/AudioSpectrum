//
//  AudioSpectrumView.m
//  AudioSpectrum
//
//  Created by 苏沫离 on 2020/4/26.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "AudioSpectrumView.h"

float const AudioSpectrumItemWidth = 5.0;//元素宽度
float const AudioSpectrumItemSpace = 1.0;//元素间隔

@interface AudioSpectrumView ()
{
    NSTimeInterval _timeInterval;
    NSInteger _timerIndex;
}

@property (nonatomic, strong) CAReplicatorLayer *contentLayer;
@property (nonatomic, strong) CALayer *currentLayer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat height_2_1;

@end


@implementation AudioSpectrumView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        UIView *view = [[UIView alloc] init];
        view.tag = 10;
        view.backgroundColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:0.5];
        [self addSubview:view];
        
        _currentLayer = CALayer.layer;
        _currentLayer.frame = CGRectMake(0, CGRectGetHeight(frame) / 2.0 - 25, 2, 50);
        _currentLayer.backgroundColor = [UIColor colorWithRed:255/255.0 green:59/255.0 blue:61/255.0 alpha:1.0].CGColor;
        [self.layer addSublayer:_currentLayer];
    }
    return self;
}

#pragma mark - public method

/** 重置该音谱
 * @param duration 音乐总时长
 */
- (void)resertSpectrumWithDuration:(CGFloat)duration{
    CGFloat maxNumber = CGRectGetWidth(self.frame) / (AudioSpectrumItemWidth + AudioSpectrumItemSpace);//view 所能容纳的最大数量
    CGFloat interval = duration / maxNumber;
    _timeInterval = MIN(1, interval);
    _timerIndex = 0;
        
    [_contentLayer removeFromSuperlayer];
    _contentLayer = nil;
    [self.layer addSublayer:self.contentLayer];
    maxNumber = duration / _timeInterval;
    _contentLayer.frame = CGRectMake(0, 0, maxNumber * (AudioSpectrumItemWidth + AudioSpectrumItemSpace), self.height_2_1);
    
    self.contentSize = CGSizeMake(CGRectGetWidth(_contentLayer.frame), CGRectGetHeight(self.frame));
    self.contentOffset = CGPointZero;
    
    _currentLayer.position = CGPointMake(0, self.height_2_1);
    _currentLayer.hidden = YES;
    [self viewWithTag:10].frame = CGRectMake(0, self.height_2_1 - 0.5, CGRectGetWidth(_contentLayer.frame), 0.5);
}

- (void)startSpectrum {
    _currentLayer.hidden = NO;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
    [NSRunLoop.currentRunLoop addTimer:_timer forMode:NSRunLoopCommonModes];
    [self timerClick];
}

- (void)stopSpectrum {
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - private method

- (void)timerClick{
    CGFloat lineHeight = [self getItemHeight];
    CAShapeLayer *itemLayer = [self itemLayerWithHeight:lineHeight];
    [self.contentLayer addSublayer:itemLayer];
    _currentLayer.position = CGPointMake(CGRectGetMaxX(itemLayer.frame), self.height_2_1);
    if (CGRectGetMaxX(itemLayer.frame) > CGRectGetWidth(self.frame) ) {
        self.contentOffset = CGPointMake(CGRectGetMaxX(itemLayer.frame) - CGRectGetWidth(self.frame), 0);
    }
    _timerIndex ++;
}

/** 获取当前音频的高度
 * @note level:{0,160}
 */
- (CGFloat)getItemHeight{
    CGFloat level = fabs(self.itemLevelBlock());
    level = MIN(160, fabs(level));
    level = MAX(arc4random() % 50 + 30, level);//随机控制最小值
    CGFloat lineHeight = level / 160.0 * self.height_2_1;//线的高度
    CGFloat remainder = (int)lineHeight % (int)(AudioSpectrumItemWidth + AudioSpectrumItemSpace);//求余数
    if (remainder > (AudioSpectrumItemWidth + AudioSpectrumItemSpace) / 2.0) {
        lineHeight = lineHeight + AudioSpectrumItemWidth + AudioSpectrumItemSpace - remainder - AudioSpectrumItemSpace;;
    }else{
        lineHeight = lineHeight - remainder - AudioSpectrumItemSpace;
    }
    return lineHeight;
}

- (CAShapeLayer *)itemLayerWithHeight:(CGFloat)height{
    CAShapeLayer *itemLine = [CAShapeLayer layer];
    itemLine.frame = CGRectMake((AudioSpectrumItemWidth + AudioSpectrumItemSpace) * _timerIndex, self.height_2_1 - height, AudioSpectrumItemWidth, height);
    itemLine.fillColor     = UIColor.clearColor.CGColor;
    itemLine.strokeColor   = [UIColor colorWithRed:90/255.f green:88/255.f blue:81/255.f alpha:0.7].CGColor;
    itemLine.lineWidth     = AudioSpectrumItemWidth;
    UIBezierPath *middlePath = [UIBezierPath bezierPath];
    [middlePath moveToPoint:CGPointMake(2.5, height)];
    [middlePath addLineToPoint:CGPointMake(2.5, 0.0)];
    itemLine.path = middlePath.CGPath;
    itemLine.lineDashPattern = @[@(AudioSpectrumItemWidth), @(AudioSpectrumItemSpace)];
    return itemLine;
}

- (CAReplicatorLayer *)contentLayer{
    if (_contentLayer == nil) {
        _contentLayer = CAReplicatorLayer.layer;
        _contentLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), self.height_2_1);
        _contentLayer.backgroundColor = UIColor.clearColor.CGColor;
        _contentLayer.instanceCount = 2;
        _contentLayer.instanceTransform = CATransform3DRotate(CATransform3DMakeTranslation(0, self.height_2_1, 0), M_PI, 1, 0, 0);
        _contentLayer.instanceAlphaOffset -= 0.3;
    }
    return _contentLayer;
}

- (CGFloat)height_2_1{
    return CGRectGetHeight(self.frame) / 2.0;
}

@end
