//
//  MoButton.m
//  
//
//  Created by Sanjay Madan on 2/11/15.
//  Copyright (c) 2015 mowglii.com. All rights reserved.
//

#import "MoButton.h"

@implementation MoButton
{
    NSImage *_img, *_imgAlt, *_imgDarkened;
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        self.wantsLayer = YES;
        self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawCrossfade;
    }
    return self;
}

- (BOOL)wantsUpdateLayer { return YES; }

- (CGSize)intrinsicContentSize
{
    return _img.size;
}

- (void)setImage:(NSImage *)image
{
    _img = image;
    _imgDarkened = [NSImage imageWithSize:_img.size flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
        [_img drawInRect:dstRect];
        [[NSColor colorWithCalibratedRed:0.3 green:0.5 blue:0.9 alpha:1] set];
        NSRectFillUsingOperation(dstRect, NSCompositeSourceAtop);
        return YES;
    }];
}

- (void)setAlternateImage:(NSImage *)alternateImage
{
    _imgAlt = alternateImage;
}

- (void)updateLayer
{
    // Animate state changes and highlighting by crossfading
    // between _img and _imgAlt, if it was provided. If not,
    // use _imgDarkened.
    NSImage *img2 = _imgAlt ? _imgAlt : _imgDarkened;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.3;
        context.allowsImplicitAnimation = YES;
        // If this button reflects its state, use state to determine which img to use.
        if ([(NSButtonCell *)self.cell showsStateBy] != 0) {
            if (!self.isHighlighted) {
                self.layer.contents = self.state ? (id)img2 : (id)_img;
            }
        }
        // Otherwise, use highlight to determine which image to show.
        else {
            self.layer.contents = self.isHighlighted ? (id)img2 : (id)_img;
        }
    } completionHandler:NULL];
}

@end