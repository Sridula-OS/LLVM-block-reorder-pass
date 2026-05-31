; ModuleID = 'test2.c'
source_filename = "test2.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nofree norecurse nosync nounwind readnone uwtable
define dso_local i32 @test2(i32 noundef %0) local_unnamed_addr #0 {
  br label %3

2:                                                ; preds = %3
  ret i32 %13

3:                                                ; preds = %1, %3
  %4 = phi i32 [ 0, %1 ], [ %14, %3 ]
  %5 = phi i32 [ 0, %1 ], [ %13, %3 ]
  %6 = icmp slt i32 %4, %0
  %7 = sub nsw i32 0, %4
  %8 = select i1 %6, i32 %4, i32 %7
  %9 = add i32 %8, %5
  %10 = srem i32 %9, 3
  %11 = icmp eq i32 %10, 0
  %12 = select i1 %11, i32 2, i32 -2
  %13 = add nsw i32 %12, %9
  %14 = add nuw nsw i32 %4, 1
  %15 = icmp eq i32 %14, 20
  br i1 %15, label %2, label %3, !llvm.loop !5
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
