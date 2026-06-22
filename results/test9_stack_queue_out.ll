; ModuleID = 'results/test9_stack_queue.ll'
source_filename = "test9_stack_queue.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Stack = type { [8 x i32], i32 }
%struct.Queue = type { [8 x i32], i32, i32 }

@__const.main.values = private unnamed_addr constant [8 x i32] [i32 4, i32 15, i32 8, i32 3, i32 22, i32 11, i32 6, i32 19], align 16
@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: nofree noinline nosync nounwind readonly uwtable
define dso_local i32 @exercise_stack_queue(i32* nocapture noundef readonly %0, i32 noundef %1) local_unnamed_addr #0 {
  %3 = alloca %struct.Stack, align 4
  %4 = alloca %struct.Queue, align 4
  %5 = bitcast %struct.Stack* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 36, i8* nonnull %5) #5
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(36) %5, i8 0, i64 36, i1 false)
  %6 = getelementptr inbounds %struct.Stack, %struct.Stack* %3, i64 0, i32 1
  store i32 -1, i32* %6, align 4
  %7 = bitcast %struct.Queue* %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 40, i8* nonnull %7) #5
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(40) %7, i8 0, i64 40, i1 false)
  %8 = icmp sgt i32 %1, 0
  br i1 %8, label %9, label %15

9:                                                ; preds = %2
  %10 = getelementptr inbounds %struct.Queue, %struct.Queue* %4, i64 0, i32 2
  %11 = zext i32 %1 to i64
  br label %47

12:                                               ; preds = %47
  %13 = load i32, i32* %6, align 4, !tbaa !5
  %14 = icmp slt i32 %13, 7
  br i1 %14, label %31, label %44

15:                                               ; preds = %44, %2
  %16 = load i32, i32* %6, align 4, !tbaa !5
  %17 = icmp sgt i32 %16, -1
  br i1 %17, label %18, label %53

18:                                               ; preds = %18, %15
  %19 = phi i32 [ %29, %18 ], [ %16, %15 ]
  %20 = phi i32 [ %28, %18 ], [ 0, %15 ]
  %21 = add nsw i32 %19, -1
  store i32 %21, i32* %6, align 4, !tbaa !5
  %22 = sext i32 %19 to i64
  %23 = getelementptr inbounds %struct.Stack, %struct.Stack* %3, i64 0, i32 0, i64 %22
  %24 = load i32, i32* %23, align 4, !tbaa !10
  %25 = icmp sgt i32 %24, 10
  %26 = sub i32 0, %24
  %27 = select i1 %25, i32 %24, i32 %26
  %28 = add i32 %27, %20
  %29 = load i32, i32* %6, align 4, !tbaa !5
  %30 = icmp sgt i32 %29, -1
  br i1 %30, label %18, label %53, !llvm.loop !11

31:                                               ; preds = %12
  %32 = add nsw i32 %13, 1
  store i32 %32, i32* %6, align 4, !tbaa !5
  %33 = sext i32 %32 to i64
  %34 = getelementptr inbounds %struct.Stack, %struct.Stack* %3, i64 0, i32 0, i64 %33
  br label %42

35:                                               ; preds = %47
  %36 = load i32, i32* %10, align 4, !tbaa !14
  %37 = icmp slt i32 %36, 8
  br i1 %37, label %38, label %44

38:                                               ; preds = %35
  %39 = add nsw i32 %36, 1
  store i32 %39, i32* %10, align 4, !tbaa !14
  %40 = sext i32 %36 to i64
  %41 = getelementptr inbounds %struct.Queue, %struct.Queue* %4, i64 0, i32 0, i64 %40
  br label %42

42:                                               ; preds = %38, %31
  %43 = phi i32* [ %34, %31 ], [ %41, %38 ]
  store i32 %50, i32* %43, align 4, !tbaa !10
  br label %44

44:                                               ; preds = %42, %35, %12
  %45 = add nuw nsw i64 %48, 1
  %46 = icmp eq i64 %45, %11
  br i1 %46, label %15, label %47, !llvm.loop !16

47:                                               ; preds = %44, %9
  %48 = phi i64 [ 0, %9 ], [ %45, %44 ]
  %49 = getelementptr inbounds i32, i32* %0, i64 %48
  %50 = load i32, i32* %49, align 4, !tbaa !10
  %51 = and i32 %50, 1
  %52 = icmp eq i32 %51, 0
  br i1 %52, label %12, label %35

53:                                               ; preds = %18, %15
  %54 = phi i32 [ 0, %15 ], [ %28, %18 ]
  %55 = getelementptr inbounds %struct.Queue, %struct.Queue* %4, i64 0, i32 1
  %56 = getelementptr inbounds %struct.Queue, %struct.Queue* %4, i64 0, i32 2
  %57 = load i32, i32* %56, align 4, !tbaa !14
  %58 = load i32, i32* %55, align 4, !tbaa !17
  %59 = icmp slt i32 %58, %57
  br i1 %59, label %60, label %73

60:                                               ; preds = %60, %53
  %61 = phi i32 [ %71, %60 ], [ %58, %53 ]
  %62 = phi i32 [ %70, %60 ], [ %54, %53 ]
  %63 = add nsw i32 %61, 1
  store i32 %63, i32* %55, align 4, !tbaa !17
  %64 = sext i32 %61 to i64
  %65 = getelementptr inbounds %struct.Queue, %struct.Queue* %4, i64 0, i32 0, i64 %64
  %66 = load i32, i32* %65, align 4, !tbaa !10
  %67 = icmp sgt i32 %66, 10
  %68 = zext i1 %67 to i32
  %69 = shl nsw i32 %66, %68
  %70 = add nsw i32 %69, %62
  %71 = load i32, i32* %55, align 4, !tbaa !17
  %72 = icmp slt i32 %71, %57
  br i1 %72, label %60, label %73, !llvm.loop !18

73:                                               ; preds = %60, %53
  %74 = phi i32 [ %54, %53 ], [ %70, %60 ]
  call void @llvm.lifetime.end.p0i8(i64 40, i8* nonnull %7) #5
  call void @llvm.lifetime.end.p0i8(i64 36, i8* nonnull %5) #5
  ret i32 %74
}

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #2

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nofree nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #3 {
  %1 = call i32 @exercise_stack_queue(i32* noundef nonnull getelementptr inbounds ([8 x i32], [8 x i32]* @__const.main.values, i64 0, i64 0), i32 noundef 8)
  %2 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %1)
  ret i32 0
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #4

attributes #0 = { nofree noinline nosync nounwind readonly uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly nofree nosync nounwind willreturn }
attributes #2 = { argmemonly nofree nounwind willreturn writeonly }
attributes #3 = { nofree nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nofree nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!5 = !{!6, !9, i64 32}
!6 = !{!"", !7, i64 0, !9, i64 32}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = !{!"int", !7, i64 0}
!10 = !{!9, !9, i64 0}
!11 = distinct !{!11, !12, !13}
!12 = !{!"llvm.loop.mustprogress"}
!13 = !{!"llvm.loop.unroll.disable"}
!14 = !{!15, !9, i64 36}
!15 = !{!"", !7, i64 0, !9, i64 32, !9, i64 36}
!16 = distinct !{!16, !12, !13}
!17 = !{!15, !9, i64 32}
!18 = distinct !{!18, !12, !13}
