; ModuleID = 'test3.c'
source_filename = "test3.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nofree norecurse nosync nounwind readnone uwtable
define dso_local i32 @test3(i32 noundef %0) local_unnamed_addr #0 {
  %2 = icmp sgt i32 %0, 10
  br i1 %2, label %3, label %10

3:                                                ; preds = %1
  %4 = shl nsw i32 %0, 1
  %5 = icmp sgt i32 %0, 15
  br i1 %5, label %6, label %8

6:                                                ; preds = %3
  %7 = add nsw i32 %4, 5
  br label %12

8:                                                ; preds = %3
  %9 = add nsw i32 %4, -5
  br label %12

10:                                               ; preds = %1
  %11 = add nsw i32 %0, -3
  br label %12

12:                                               ; preds = %6, %8, %10
  %13 = phi i32 [ %11, %10 ], [ %9, %8 ], [ %7, %6 ]
  br label %15

14:                                               ; preds = %15
  ret i32 %21

15:                                               ; preds = %12, %15
  %16 = phi i32 [ %22, %15 ], [ 0, %12 ]
  %17 = phi i32 [ %21, %15 ], [ %13, %12 ]
  %18 = icmp sgt i32 %17, %16
  %19 = sub nsw i32 0, %16
  %20 = select i1 %18, i32 %16, i32 %19
  %21 = add i32 %20, %17
  %22 = add nuw nsw i32 %16, 1
  %23 = icmp eq i32 %22, 5
  br i1 %23, label %14, label %15, !llvm.loop !5
}

attributes #0 = { nofree norecurse nosync nounwind readnone uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!5 = distinct !{!5, !6, !7}
!6 = !{!"llvm.loop.mustprogress"}
!7 = !{!"llvm.loop.unroll.disable"}
