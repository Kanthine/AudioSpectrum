//
//  ViewController.m
//  AudioSpectrum
//
//  Created by 苏沫离 on 2020/4/26.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import "AudioSpectrumView.h"
#import "AudioSpectrumView_2.h"

@interface ViewController ()
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) UIButton *playerButton;

@property (strong, nonatomic) AudioSpectrumView *spectrumView;
@property (strong, nonatomic) AudioSpectrumView_2 *spectrumView_2;

@end

@implementation ViewController

#pragma mark - life cycle

- (void)dealloc{
    [_audioPlayer pause];
    [_spectrumView stopSpectrum];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.opacity = 0.5;
    gl.frame = CGRectMake(0, 100, CGRectGetWidth(UIScreen.mainScreen.bounds), 100);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:41/255.0 green:41/255.0 blue:41/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.39].CGColor,(__bridge id)[UIColor colorWithRed:53/255.0 green:54/255.0 blue:54/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(0.5f),@(1.0f)];
    
    CAGradientLayer *gl_2 = [CAGradientLayer layer];
    gl_2.frame = CGRectMake(0, 100, CGRectGetWidth(UIScreen.mainScreen.bounds), 100);
    gl_2.startPoint = CGPointMake(0, 0);
    gl_2.endPoint = CGPointMake(1, 1);
    gl_2.colors = @[(__bridge id)[UIColor colorWithRed:36/255.0 green:36/255.0 blue:36/255.0 alpha:0.0].CGColor,(__bridge id)[UIColor colorWithRed:31/255.0 green:30/255.0 blue:34/255.0 alpha:1.0].CGColor];
    gl_2.locations = @[@(0.0),@(1.0f)];
    [self.view.layer addSublayer:gl];
    [self.view.layer addSublayer:gl_2];
    self.navigationItem.title = @"音谱";
    
    [self.view addSubview:self.spectrumView];
    [self.view addSubview:self.spectrumView_2];
    [self.view addSubview:self.playerButton];
}

- (void)playerButtonClick:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"停止"]) {
        [self.audioPlayer pause];
        [self.spectrumView stopSpectrum];
        [self.spectrumView_2 stopSpectrum];
        [sender setTitle:@"播放" forState:UIControlStateNormal];
    }else{
        [self.audioPlayer play];
        [self.spectrumView startSpectrum];
        [self.spectrumView_2 startSpectrum];
        [sender setTitle:@"停止" forState:UIControlStateNormal];
    }
}

#pragma mark - setter and getters

- (AVAudioPlayer *)audioPlayer{
    if (_audioPlayer == nil) {
        NSString *path = [NSBundle.mainBundle pathForResource:@"ka" ofType:@"mp3"];
        NSError *error;
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
        _audioPlayer.meteringEnabled = YES;
    }
    return _audioPlayer;
}

- (UIButton *)playerButton{
    if (_playerButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 50);
        [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [button setTitle:@"播放" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(playerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _playerButton = button;
    }
    return _playerButton;
}

- (AudioSpectrumView *)spectrumView{
    if (_spectrumView == nil) {
        _spectrumView = [[AudioSpectrumView alloc] initWithFrame:CGRectMake(0,100,CGRectGetWidth(UIScreen.mainScreen.bounds), 50 * 2.0)];
        [_spectrumView resertSpectrumWithDuration:232];
        
        __weak typeof (self) weakSelf = self;
        _spectrumView.itemLevelBlock = ^CGFloat{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.audioPlayer updateMeters];
            return [strongSelf.audioPlayer averagePowerForChannel:1];
        };
    }
    return _spectrumView;
}

- (AudioSpectrumView_2 *)spectrumView_2{
    if (_spectrumView_2 == nil) {
        _spectrumView_2 = [[AudioSpectrumView_2 alloc] initWithFrame:CGRectMake(64,250,36, 20)];
        
        __weak typeof (self) weakSelf = self;
        _spectrumView_2.itemLevelBlock = ^CGFloat{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.audioPlayer updateMeters];
            return [strongSelf.audioPlayer averagePowerForChannel:1];
        };
    }
    return _spectrumView_2;
}

@end
