//
//  Rectangle.m
//  MyFirstObjC
//
//  Created by Kim Dong-woo on 2016. 12. 20..
//  Copyright © 2016년 Kim Dong-woo. All rights reserved.
//

#import "Rectangle.h"

@implementation Rectangle

-(id)init{
    self = [super init];
    if( self )
    {
        [self setWidth:10];
        [self setHeight:20];
    }
    return self;
}
-(id)initWithWidth:(int)nWidth height:(int)nHeight
{
    self = [super init];
    if(self) {
        [self setWidth:nWidth];
        [self setHeight:nHeight];
    }
    return self;
}

-(int)size {
    return width * height;
}

-(void) setWidth:(int) nW{
    width = nW;
}
-(void) setHeight:(int) nH{
    height = nH;
}

-(void)setWidth:(int)nWidth height:(int)nHeight{
    [self setWidth:nWidth];
    [self setHeight:nHeight];
}

-(int)width{
    return width;
}
-(int)height{
    return height;
}

-(BOOL)isSqure{
    return width == height;
}

@end


@implementation Rectangle2

-(void) PrintSize{
    NSLog(@"%i %i  = size : %i", _nWidth, _nHeight, (_nWidth*_nHeight));
}


@end
