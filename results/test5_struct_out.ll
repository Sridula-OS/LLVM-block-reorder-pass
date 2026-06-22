; ModuleID = 'results/test5_struct.ll'
source_filename = "test5_struct.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Student = type { i32, i32, i32 }

@__const.main.students = private unnamed_addr constant [5 x %struct.Student] [%struct.Student { i32 82, i32 1, i32 91 }, %struct.Student { i32 44, i32 1, i32 88 }, %struct.Student { i32 67, i32 0, i32 95 }, %struct.Student { i32 73, i32 1, i32 62 }, %struct.Student { i32 59, i32 1, i32 79 }], align 16
@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: nofree noinline norecurse nosync nounwind readonly uwtable
define dso_local i32 @process_students(%struct.Student* nocapture noundef readonly %0, i32 noundef %1) local_unnamed_addr #0 {
  %3 = icmp sgt i32 %1, 0
  br i1 %3, label %4, label %12

4:                                                ; preds = %2
  %5 = zext i32 %1 to i64
  br label %27

6:                                                ; preds = %27
  %7 = getelementptr inbounds %struct.Student, %struct.Student* %0, i64 %28, i32 2
  %8 = load i32, i32* %7, align 4, !tbaa !5
  %9 = icmp slt i32 %8, 75
  br i1 %9, label %10, label %14

10:                                               ; preds = %6
  %11 = add nsw i32 %29, -10
  br label %23

12:                                               ; preds = %23, %2
  %13 = phi i32 [ 0, %2 ], [ %24, %23 ]
  ret i32 %13

14:                                               ; preds = %6
  %15 = getelementptr inbounds %struct.Student, %struct.Student* %0, i64 %28, i32 0
  %16 = load i32, i32* %15, align 4, !tbaa !10
  %17 = icmp sgt i32 %16, 49
  br i1 %17, label %18, label %20

18:                                               ; preds = %14
  %19 = add nsw i32 %16, %29
  br label %23

20:                                               ; preds = %14
  %21 = sdiv i32 %16, -2
  %22 = add i32 %21, %29
  br label %23

23:                                               ; preds = %20, %18, %10, %27
  %24 = phi i32 [ %11, %10 ], [ %19, %18 ], [ %22, %20 ], [ %29, %27 ]
  %25 = add nuw nsw i64 %28, 1
  %26 = icmp eq i64 %25, %5
  br i1 %26, label %12, label %27, !llvm.loop !11

27:                                               ; preds = %23, %4
  %28 = phi i64 [ 0, %4 ], [ %25, %23 ]
  %29 = phi i32 [ 0, %4 ], [ %24, %23 ]
  %30 = getelementptr inbounds %struct.Student, %struct.Student* %0, i64 %28, i32 1
  %31 = load i32, i32* %30, align 4, !tbaa !14
  %32 = icmp eq i32 %31, 0
  br i1 %32, label %23, label %6
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
!5 = !{!6, !7, i64 8}
!6 = !{!"", !7, i64 0, !7, i64 4, !7, i64 8}
!7 = !{!"int", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = !{!6, !7, i64 0}
!11 = distinct !{!11, !12, !13}
!12 = !{!"llvm.loop.mustprogress"}
!13 = !{!"llvm.loop.unroll.disable"}
!14 = !{!6, !7, i64 4}
