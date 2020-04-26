//
//  AudioSpectrumView_2.m
//  AudioSpectrum
//
//  Created by 苏沫离 on 2020/4/26.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "AudioSpectrumView_2.h"

@interface AudioSpectrumView_2 ()

{
    CGFloat _lineWidth;//线宽
    CGFloat _lineSpace;//线间距
}

@property (nonatomic, strong) NSMutableArray *levelArray;
@property (nonatomic, strong) NSMutableArray *itemLineLayers;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AudioSpectrumView_2

//frame.width = 3.0f * 7 + 4.0 * 5 = 42
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _lineWidth = 2.0f;
        _lineSpace = 3.0f;
        [self updateLineLayers];
    }
    return self;
}

#pragma mark - update

- (void)updateLineLayers{
    UIGraphicsBeginImageContext(self.frame.size);
    CGFloat space = (_lineSpace + _lineWidth) * 1.0;
    CGFloat middlePoint = CGRectGetWidth(self.bounds) / 2.0;
    int middleIndex = (int)self.levelArray.count - 1;
    int leftX = middlePoint - space;
    int rightX = middlePoint + space;
    
    for(int i = 0; i < self.levelArray.count; i++) {
        CGFloat lineHeight = [self.levelArray[i] floatValue] / 160.0 * CGRectGetHeight(self.frame);//线的高度
        CGFloat lineTop = (CGRectGetHeight(self.bounds) - lineHeight) / 2.f;
        CGFloat lineBottom = (CGRectGetHeight(self.bounds) + lineHeight) / 2.f;
        
        if (i == 0) {
            UIBezierPath *middlePath = [UIBezierPath bezierPath];
            [middlePath moveToPoint:CGPointMake(middlePoint, lineTop)];
            [middlePath addLineToPoint:CGPointMake(middlePoint, lineBottom)];
            CAShapeLayer *itemLine2 = [self.itemLineLayers objectAtIndex:middleIndex];
            itemLine2.path = [middlePath CGPath];
        }else{
            UIBezierPath *linePathLeft = [UIBezierPath bezierPath];
            [linePathLeft moveToPoint:CGPointMake(leftX, lineTop)];
            [linePathLeft addLineToPoint:CGPointMake(leftX, lineBottom)];
            CAShapeLayer *itemLine2 = [self.itemLineLayers objectAtIndex:middleIndex + i];
            itemLine2.path = [linePathLeft CGPath];
            leftX -= space;
            
            UIBezierPath *linePathRight = [UIBezierPath bezierPath];
            [linePathRight moveToPoint:CGPointMake(rightX, lineTop)];
            [linePathRight addLineToPoint:CGPointMake(rightX, lineBottom)];
            CAShapeLayer *itemLine = [self.itemLineLayers objectAtIndex:middleIndex - i];
            itemLine.path = [linePathRight CGPath];
            rightX += space;
        }
    }
    UIGraphicsEndImageContext();
}

- (void)startSpectrum {
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
    [NSRunLoop.currentRunLoop addTimer:_timer forMode:NSRunLoopCommonModes];
    [self timerClick];
}

- (void)stopSpectrum {
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - private method

- (void)timerClick{
        CGFloat level = fabs(self.itemLevelBlock());
    level = MIN(160, fabs(level));
    level = MAX(arc4random() % 50 + 30, level);//随机控制最小值

    [self.levelArray removeLastObject];
    [self.levelArray insertObject:@(level) atIndex:0];
    [self updateLineLayers];
    
    [self updateLineLayers];
}

#pragma mark - setter and getters

- (void)setLevel:(CGFloat)level {
    level = MIN(160, fabs(level));
    level = MAX(arc4random() % 30 + 50, level);//设置个最小值
    [self.levelArray removeLastObject];
    [self.levelArray insertObject:@(level) atIndex:0];
    [self updateLineLayers];
}

- (NSMutableArray *)levelArray{
    if (_levelArray == nil) {
        _levelArray = [[NSMutableArray alloc]initWithObjects:@(60),@(120),@(90),@(160), nil];
    }
    return _levelArray;
}

- (NSMutableArray *)itemLineLayers{
    if (_itemLineLayers == nil) {
        NSMutableArray *array = [NSMutableArray array];
        for(int i = 0; i < self.levelArray.count * 2.0 - 1; i++) {
            CAShapeLayer *itemLine = [CAShapeLayer layer];
            itemLine.lineCap       = kCALineCapButt;
            itemLine.lineJoin      = kCALineJoinRound;
            itemLine.strokeColor   = UIColor.clearColor.CGColor;
            itemLine.fillColor     = UIColor.clearColor.CGColor;
            itemLine.strokeColor   = [UIColor colorWithRed:233/255.f green:139/255.f blue:163/255.f alpha:1.0].CGColor;
            itemLine.lineWidth     = _lineWidth;
            [self.layer addSublayer:itemLine];
            [array addObject:itemLine];
        }
        _itemLineLayers = array;
    }
    return _itemLineLayers;
}
@end
