; ModuleID = 'test4.c'
source_filename = "test4.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nofree norecurse nosync nounwind readnone uwtable
define dso_local i32 @unpredictable(i32 noundef %0, i32 noundef %1) local_unnamed_addr #0 {
  %3 = mul nsw i32 %1, %0
  br label %5

4:                                                ; preds = %5
  ret i32 %13

5:                                                ; preds = %2, %5
  %6 = phi i32 [ 0, %2 ], [ %14, %5 ]
  %7 = phi i32 [ 0, %2 ], [ %13, %5 ]
  %8 = add nsw i32 %6, %3
  %9 = and i32 %8, 1
  %10 = icmp eq i32 %9, 0
  %11 = sub nsw i32 0, %6
  %12 = select i1 %10, i32 %11, i32 %6
  %13 = add i32 %12, %7
  %14 = add nuw nsw i32 %6, 1
  %15 = icmp eq i32 %14, 100
  br i1 %15, label %4, label %5, !llvm.loop !5
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
