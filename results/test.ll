; ModuleID = 'test.c'
source_filename = "test.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: nofree norecurse nosync nounwind readnone uwtable
define dso_local i32 @foo(i32 noundef %0) local_unnamed_addr #0 {
  %2 = icmp sgt i32 %0, 10
  %3 = shl nsw i32 %0, 1
  %4 = add nsw i32 %0, -2
  %5 = select i1 %2, i32 %3, i32 %4
  %6 = icmp sgt i32 %5, 20
  %7 = select i1 %6, i32 5, i32 -5
  %8 = add nsw i32 %7, %5
  br label %13

9:                                                ; preds = %13
  %10 = icmp sgt i32 %20, 50
  %11 = sub nsw i32 0, %20
  %12 = select i1 %10, i32 %20, i32 %11
  ret i32 %12

13:                                               ; preds = %1, %13
  %14 = phi i32 [ 0, %1 ], [ %21, %13 ]
  %15 = phi i32 [ %8, %1 ], [ %20, %13 ]
  %16 = and i32 %15, 1
  %17 = icmp eq i32 %16, 0
  %18 = sub nsw i32 0, %14
  %19 = select i1 %17, i32 %14, i32 %18
  %20 = add i32 %19, %15
  %21 = add nuw nsw i32 %14, 1
  %22 = icmp eq i32 %21, 5
  br i1 %22, label %9, label %13, !llvm.loop !5
}

; Function Attrs: nofree nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #1 {
  %1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef -35)
  ret i32 0
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #2

attributes #0 = { nofree norecurse nosync nounwind readnone uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

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
