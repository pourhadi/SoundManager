//
//  SMSoundManager.m
//  SoundManager
//
//  Created by Daniel Pourhadi on 1/14/16.
//  Copyright © 2016 Daniel Pourhadi. All rights reserved.
//

#import "SMSoundManager.h"
#import <AVFoundation/AVFoundation.h>

@interface SMSoundManager ()

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation SMSoundManager

+ (instancetype)sharedInstance {
    static SMSoundManager* instance = nil;
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{ instance = [[self alloc] init]; });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.player = [[AVPlayer alloc] init];
    }
    return self;
}

- (void)loadAudioAtURL:(NSURL*)url play:(BOOL)play {
    [self.player pause];
    [self.player replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:url]];
    if (play) {
        [self.player play];
    }
}

- (void)play {
    
}

- (void)pause {
    
}

@end
