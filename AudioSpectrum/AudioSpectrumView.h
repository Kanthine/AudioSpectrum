//
//  AudioSpectrumView.h
//  AudioSpectrum
//
//  Created by 苏沫离 on 2020/4/26.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 音谱
 */
@interface AudioSpectrumView : UIScrollView

/** 获取此刻的音量
 */
@property (nonatomic ,copy) CGFloat (^itemLevelBlock)(void);

/** 重置该音谱
 * @param duration 音乐总时长
 */
- (void)resertSpectrumWithDuration:(CGFloat)duration;
- (void)startSpectrum;
- (void)stopSpectrum;

@end

NS_ASSUME_NONNULL_END
