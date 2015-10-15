//
//  TNCheckBoxGroup.m
//  TNCheckBoxDemo
//
//  Created by Frederik Jacques on 24/04/14.
//  Copyright (c) 2014 Frederik Jacques. All rights reserved.
//

#import "TNCheckBoxGroup.h"

NSString *const GROUP_CHANGED = @"groupChanged";

@interface TNCheckBoxGroup()



@property (nonatomic) NSInteger widthOfComponent;
@property (nonatomic) NSInteger heightOfComponent;

@end

@implementation TNCheckBoxGroup

- (instancetype)initWithCheckBoxData:(NSArray *)checkBoxData style:(TNCheckBoxLayout)layout {
    
    self = [super init];
    
    if (self) {
        self.checkBoxData = checkBoxData;
        self.layout = layout;
        self.marginBetweenItems = 0;
    }
    
    return self;
}

- (void)myInitWithCheckBoxData:(NSArray *)checkBoxData style:(TNCheckBoxLayout)layout
{
    self.checkBoxData = checkBoxData;
    self.layout = layout;
    self.marginBetweenItems = 0;
}

- (void)create {
    self.marginBetweenItems = 0;
    
    [self createCheckBoxes];
    
    self.frame = CGRectMake(0, 0, self.widthOfComponent, self.heightOfComponent);
}

- (void)myCreate {
    self.marginBetweenItems = 0;
    
    [self createCheckBoxes];
}

- (void)createCheckBoxes {
    
    int xPos = 0;
    int yPos = 0;
    int maxHeight = 0;
    int i = 0;
    
    NSMutableArray *tmp = [NSMutableArray new];
    
    for (TNCheckBoxData *data in self.checkBoxData) {
        
        TNCheckBox *checkBox = nil;

        if( !data.labelFont) data.labelFont = self.labelFont;
        if( !data.labelColor) data.labelColor = self.labelColor;
        
        if( [data isKindOfClass:[TNCircularCheckBoxData class]] ){
            checkBox = [[TNCircularCheckBox alloc] initWithData:(TNCircularCheckBoxData *)data];
        }else if( [data isKindOfClass:[TNRectangularCheckBoxData class]] ){
            checkBox = [[TNRectangularCheckBox alloc] initWithData:(TNRectangularCheckBoxData *)data];
        }else if( [data isKindOfClass:[TNImageCheckBoxData class]] ){
            checkBox = [[TNImageCheckbox alloc] initWithData:(TNImageCheckBoxData *)data];
        }
        
        data.tag = i;
        
        checkBox.delegate = self;
        
        CGRect frame;
        
        if( self.layout == TNCheckBoxLayoutHorizontal ){
            frame = CGRectMake(xPos, 0, checkBox.frame.size.width, checkBox.frame.size.height);
        }else{
            frame = CGRectMake(0, yPos, checkBox.frame.size.width, checkBox.frame.size.height);
        }
        
        checkBox.frame = frame;
        [self addSubview:checkBox];
        
        xPos += checkBox.frame.size.width + self.marginBetweenItems;
        yPos += checkBox.frame.size.height + self.marginBetweenItems;
        maxHeight = MAX(maxHeight, checkBox.frame.size.height);
        
        if( self.layout == TNCheckBoxLayoutVertical ){
            maxHeight = yPos;
        }
    
        [tmp addObject:checkBox];
        i++;
    }
    
    self.widthOfComponent = xPos;
    self.heightOfComponent = maxHeight;
    self.radioButtons = [NSArray arrayWithArray:tmp];
}

- (void)checkBoxDidChange:(TNCheckBox *)checkbox {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GROUP_CHANGED object:self];
    
}

- (void)setPosition:(CGPoint)position {
    
    self.frame = CGRectMake(position.x, position.y, self.frame.size.width, self.frame.size.height);
}

#pragma mark - Getters / Setters
- (NSArray *)checkedCheckBoxes {
    
    NSIndexSet *set = [self.checkBoxData indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        
        TNCheckBoxData *data = (TNCheckBoxData *)obj;
        return data.checked;
    }];
    
    return [self.checkBoxData objectsAtIndexes:set];
}

- (NSArray *)uncheckedCheckBoxes {
    
    NSIndexSet *set = [self.checkBoxData indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        
        TNCheckBoxData *data = (TNCheckBoxData *)obj;
        return !data.checked;
    }];
    
    return [self.checkBoxData objectsAtIndexes:set];
}

- (UIColor *)labelColor {
    
    if( !_labelColor ){
        _labelColor = [UIColor colorWithRed:78.0/255.0 green:78.0/255.0 blue:78.0/255.0 alpha:1];
    }
    
    return _labelColor;
    
}

- (UIFont *)labelFont {
    
    if( !_labelFont ){
        _labelFont = [UIFont systemFontOfSize:14];
    }
    
    return  _labelFont;
}


@end
