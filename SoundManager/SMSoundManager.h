//
//  SMSoundManager.h
//  SoundManager
//
//  Created by Daniel Pourhadi on 1/14/16.
//  Copyright © 2016 Daniel Pourhadi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SMSoundManager;

@protocol SMSoundManagerDelegate
@optional
- (void)soundManager:(SMSoundManager*)soundManager playStateChanged:(BOOL)playing;
- (void)soundManager:(SMSoundManager *)soundManager elapsedTimeUpdated:(NSTimeInterval)elapsedTime;
- (void)soundManagerTrackFinishedPlaying:(SMSoundManager *)soundManager;
- (void)soundManager:(SMSoundManager *)soundManager loadedTrackAtURL:(NSURL*)url title:(NSString*)title;
- (void)soundManager:(SMSoundManager *)soundManager errorPlayingTrack:(NSError*)error;
@end

@interface SMSoundManager : NSObject

+ (id)sharedInstance;
@property (nonatomic, weak) id<SMSoundManagerDelegate> delegate;

- (void)loadAudioAtURL:(NSURL*)url play:(BOOL)play;

- (void)play;
- (void)pause;

@property (nonatomic, readonly, getter=isPlaying) BOOL playing;

@property (nonatomic, readonly) NSTimeInterval elapsedTime;
@property (nonatomic, readonly) NSTimeInterval trackDuration;
@property (nonatomic, readonly) NSString *trackTitle;

@end
