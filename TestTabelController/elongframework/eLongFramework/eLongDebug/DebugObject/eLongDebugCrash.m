//
//  eLongDebugCrash.m
//  ElongClient
//
//  Created by Dawn on 15/3/23.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDebugCrash.h"
#import "eLongDebugDB.h"

static NSString *crashDebugModelName = @"Crash";        // Crash数据表名
@implementation eLongDebugCrash
- (eLongDebugCrashModel *) beginCrash {
    if (!self.enabled) {
        return nil;
    }
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    eLongDebugCrashModel *crashModel = [debugDB insertEntity:crashDebugModelName];
    return crashModel;
}

- (void) endCrash {
    if (!self.enabled) {
        return;
    }
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    [debugDB saveContext];
}

- (NSArray *) crashes {
    if (!self.enabled) {
        return nil;
    }
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    return [debugDB selectDataFromEntity:crashDebugModelName
                                   query:nil];
}

- (void) clearCrash {
    if (!self.enabled) {
        return;
    }
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    [debugDB clearEntity:crashDebugModelName];
    [debugDB saveContext];
}
@end
