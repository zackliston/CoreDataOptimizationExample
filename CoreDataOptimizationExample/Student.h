//
//  Student.h
//  CoreDataOptimizationExample
//
//  Created by Zack Liston on 1/13/15.
//  Copyright (c) 2015 Zack Liston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course;

@interface Student : NSManagedObject

@property (nonatomic, retain) NSNumber * grade;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) NSSet *courses;
@property (nonatomic, retain) NSSet *previousCourses;
@end

@interface Student (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(Course *)value;
- (void)removeCoursesObject:(Course *)value;
- (void)addCourses:(NSSet *)values;
- (void)removeCourses:(NSSet *)values;

- (void)addPreviousCoursesObject:(Course *)value;
- (void)removePreviousCoursesObject:(Course *)value;
- (void)addPreviousCourses:(NSSet *)values;
- (void)removePreviousCourses:(NSSet *)values;

@end
