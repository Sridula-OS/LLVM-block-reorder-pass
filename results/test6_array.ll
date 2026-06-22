; ModuleID = 'test6_array.c'
source_filename = "test6_array.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@__const.main.values = private unnamed_addr constant [8 x i32] [i32 12, i32 -3, i32 41, i32 28, i32 7, i32 64, i32 -9, i32 18], align 16
@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: nofree noinline norecurse nosync nounwind readonly uwtable
define dso_local i32 @analyze_array(i32* nocapture noundef readonly %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = icmp sgt i32 %1, 0
  br i1 %4, label %5, label %7

5:                                                ; preds = %3
  %6 = zext i32 %1 to i64
  br label %9

7:                                                ; preds = %29, %3
  %8 = phi i32 [ 0, %3 ], [ %30, %29 ]
  ret i32 %8

9:                                                ; preds = %5, %29
  %10 = phi i64 [ 0, %5 ], [ %31, %29 ]
  %11 = phi i32 [ 0, %5 ], [ %30, %29 ]
  %12 = getelementptr inbounds i32, i32* %0, i64 %10
  %13 = load i32, i32* %12, align 4, !tbaa !5
  %14 = icmp sgt i32 %13, %2
  br i1 %14, label %15, label %23

15:                                               ; preds = %9
  %16 = and i32 %13, 1
  %17 = icmp eq i32 %16, 0
  br i1 %17, label %18, label %20

18:                                               ; preds = %15
  %19 = add nsw i32 %13, %11
  br label %29

20:                                               ; preds = %15
  %21 = sdiv i32 %13, 2
  %22 = add nsw i32 %21, %11
  br label %29

23:                                               ; preds = %9
  %24 = icmp slt i32 %13, 0
  br i1 %24, label %25, label %27

25:                                               ; preds = %23
  %26 = sub nsw i32 %11, %13
  br label %29

27:                                               ; preds = %23
  %28 = add nsw i32 %11, -1
  br label %29

29:                                               ; preds = %25, %27, %18, %20
  %30 = phi i32 [ %19, %18 ], [ %22, %20 ], [ %26, %25 ], [ %28, %27 ]
  %31 = add nuw nsw i64 %10, 1
  %32 = icmp eq i64 %31, %6
  br i1 %32, label %7, label %9, !llvm.loop !9
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
!5 = !{!6, !6, i64 0}
!6 = !{!"int", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = distinct !{!9, !10, !11}
!10 = !{!"llvm.loop.mustprogress"}
!11 = !{!"llvm.loop.unroll.disable"}
