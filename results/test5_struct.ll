; ModuleID = 'test5_struct.c'
source_filename = "test5_struct.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Student = type { i32, i32, i32 }

@__const.main.students = private unnamed_addr constant [5 x %struct.Student] [%struct.Student { i32 82, i32 1, i32 91 }, %struct.Student { i32 44, i32 1, i32 88 }, %struct.Student { i32 67, i32 0, i32 95 }, %struct.Student { i32 73, i32 1, i32 62 }, %struct.Student { i32 59, i32 1, i32 79 }], align 16
@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: nofree noinline norecurse nosync nounwind readonly uwtable
define dso_local i32 @process_students(%struct.Student* nocapture noundef readonly %0, i32 noundef %1) local_unnamed_addr #0 {
  %3 = icmp sgt i32 %1, 0
  br i1 %3, label %4, label %6

4:                                                ; preds = %2
  %5 = zext i32 %1 to i64
  br label %8

6:                                                ; preds = %29, %2
  %7 = phi i32 [ 0, %2 ], [ %30, %29 ]
  ret i32 %7

8:                                                ; preds = %4, %29
  %9 = phi i64 [ 0, %4 ], [ %31, %29 ]
  %10 = phi i32 [ 0, %4 ], [ %30, %29 ]
  %11 = getelementptr inbounds %struct.Student, %struct.Student* %0, i64 %9, i32 1
  %12 = load i32, i32* %11, align 4, !tbaa !5
  %13 = icmp eq i32 %12, 0
  br i1 %13, label %29, label %14

14:                                               ; preds = %8
  %15 = getelementptr inbounds %struct.Student, %struct.Student* %0, i64 %9, i32 2
  %16 = load i32, i32* %15, align 4, !tbaa !10
  %17 = icmp slt i32 %16, 75
  br i1 %17, label %18, label %20

18:                                               ; preds = %14
  %19 = add nsw i32 %10, -10
  br label %29

20:                                               ; preds = %14
  %21 = getelementptr inbounds %struct.Student, %struct.Student* %0, i64 %9, i32 0
  %22 = load i32, i32* %21, align 4, !tbaa !11
  %23 = icmp sgt i32 %22, 49
  br i1 %23, label %24, label %26

24:                                               ; preds = %20
  %25 = add nsw i32 %22, %10
  br label %29

26:                                               ; preds = %20
  %27 = sdiv i32 %22, -2
  %28 = add i32 %27, %10
  br label %29

29:                                               ; preds = %18, %26, %24, %8
  %30 = phi i32 [ %19, %18 ], [ %25, %24 ], [ %28, %26 ], [ %10, %8 ]
  %31 = add nuw nsw i64 %9, 1
  %32 = icmp eq i64 %31, %5
  br i1 %32, label %6, label %8, !llvm.loop !12
}

; Function Attrs: nofree nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #1 {
  %1 = call i32 @process_students(%struct.Student* noundef nonnull getelementptr inbounds ([5 x %struct.Student], [5 x %struct.Student]* @__const.main.students, i64 0, i64 0), i32 noundef 5)
  %2 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %1)
  ret i32 0
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #2

attributes #0 = { nofree noinline norecurse nosync nounwind readonly uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!5 = !{!6, !7, i64 4}
!6 = !{!"", !7, i64 0, !7, i64 4, !7, i64 8}
!7 = !{!"int", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = !{!6, !7, i64 8}
!11 = !{!6, !7, i64 0}
!12 = distinct !{!12, !13, !14}
!13 = !{!"llvm.loop.mustprogress"}
!14 = !{!"llvm.loop.unroll.disable"}
