//
//  AudioSpectrumView_2.h
//  AudioSpectrum
//
//  Created by 苏沫离 on 2020/4/26.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioSpectrumView_2 : UIView

@property (nonatomic ,copy) CGFloat (^itemLevelBlock)(void);

- (void)startSpectrum;
- (void)stopSpectrum;

@end

NS_ASSUME_NONNULL_END
