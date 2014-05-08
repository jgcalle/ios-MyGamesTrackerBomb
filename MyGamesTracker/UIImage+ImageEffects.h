//
//  UIImage+ImageEffects.h
//  MyGamesTracker
//
//  Created by MIMO on 04/03/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageEffects)

+ (UIImage *)imageWithImageOriginal:(UIImage *)image convertToWidth:(float)width;

- (UIImage *)applyLightEffect;

- (UIImage *)applyExtraLightEffect;

- (UIImage *)applyDarkEffect;

- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end
