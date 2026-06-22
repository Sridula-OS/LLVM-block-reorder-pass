; ModuleID = 'results/test6_array.ll'
source_filename = "test6_array.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@__const.main.values = private unnamed_addr constant [8 x i32] [i32 12, i32 -3, i32 41, i32 28, i32 7, i32 64, i32 -9, i32 18], align 16
@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: nofree noinline norecurse nosync nounwind readonly uwtable
define dso_local i32 @analyze_array(i32* nocapture noundef readonly %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = icmp sgt i32 %1, 0
  br i1 %4, label %5, label %12

5:                                                ; preds = %3
  %6 = zext i32 %1 to i64
  br label %25

7:                                                ; preds = %25
  %8 = and i32 %29, 1
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %10, label %14

10:                                               ; preds = %7
  %11 = add nsw i32 %29, %27
  br label %21

12:                                               ; preds = %21, %3
  %13 = phi i32 [ 0, %3 ], [ %22, %21 ]
  ret i32 %13

14:                                               ; preds = %7
  %15 = sdiv i32 %29, 2
  %16 = add nsw i32 %15, %27
  br label %21

17:                                               ; preds = %25
  %18 = icmp slt i32 %29, 0
  br i1 %18, label %31, label %19

19:                                               ; preds = %17
  %20 = add nsw i32 %27, -1
  br label %21

21:                                               ; preds = %19, %31, %14, %10
  %22 = phi i32 [ %11, %10 ], [ %16, %14 ], [ %32, %31 ], [ %20, %19 ]
  %23 = add nuw nsw i64 %26, 1
  %24 = icmp eq i64 %23, %6
  br i1 %24, label %12, label %25, !llvm.loop !5

25:                                               ; preds = %21, %5
  %26 = phi i64 [ 0, %5 ], [ %23, %21 ]
  %27 = phi i32 [ 0, %5 ], [ %22, %21 ]
  %28 = getelementptr inbounds i32, i32* %0, i64 %26
  %29 = load i32, i32* %28, align 4, !tbaa !8
  %30 = icmp sgt i32 %29, %2
  br i1 %30, label %7, label %17

31:                                               ; preds = %17
  %32 = sub nsw i32 %27, %29
  br label %21
}

; Function Attrs: nofree nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #1 {
  %1 = call i32 @analyze_array(i32* noundef nonnull getelementptr inbounds ([8 x i32], [8 x i32]* @__const.main.values, i64 0, i64 0), i32 noundef 8, i32 noundef 20)
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
!5 = distinct !{!5, !6, !7}
!6 = !{!"llvm.loop.mustprogress"}
!7 = !{!"llvm.loop.unroll.disable"}
!8 = !{!9, !9, i64 0}
!9 = !{!"int", !10, i64 0}
!10 = !{!"omnipotent char", !11, i64 0}
!11 = !{!"Simple C/C++ TBAA"}
