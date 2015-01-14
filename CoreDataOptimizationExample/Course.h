//
//  Course.h
//  CoreDataOptimizationExample
//
//  Created by Zack Liston on 1/13/15.
//  Copyright (c) 2015 Zack Liston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Professor, Student;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *previousStudents;
@property (nonatomic, retain) Professor *professor;
@property (nonatomic, retain) NSSet *students;
@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addPreviousStudentsObject:(Student *)value;
- (void)removePreviousStudentsObject:(Student *)value;
- (void)addPreviousStudents:(NSSet *)values;
- (void)removePreviousStudents:(NSSet *)values;

- (void)addStudentsObject:(Student *)value;
- (void)removeStudentsObject:(Student *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

@end
