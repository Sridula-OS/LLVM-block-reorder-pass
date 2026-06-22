; ModuleID = 'test9_stack_queue.c'
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
  br i1 %8, label %9, label %12

9:                                                ; preds = %2
  %10 = getelementptr inbounds %struct.Queue, %struct.Queue* %4, i64 0, i32 2
  %11 = zext i32 %1 to i64
  br label %15

12:                                               ; preds = %37, %2
  %13 = load i32, i32* %6, align 4, !tbaa !5
  %14 = icmp sgt i32 %13, -1
  br i1 %14, label %47, label %40

15:                                               ; preds = %9, %37
  %16 = phi i64 [ 0, %9 ], [ %38, %37 ]
  %17 = getelementptr inbounds i32, i32* %0, i64 %16
  %18 = load i32, i32* %17, align 4, !tbaa !10
  %19 = and i32 %18, 1
  %20 = icmp eq i32 %19, 0
  br i1 %20, label %21, label %28

21:                                               ; preds = %15
  %22 = load i32, i32* %6, align 4, !tbaa !5
  %23 = icmp slt i32 %22, 7
  br i1 %23, label %24, label %37

24:                                               ; preds = %21
  %25 = add nsw i32 %22, 1
  store i32 %25, i32* %6, align 4, !tbaa !5
  %26 = sext i32 %25 to i64
  %27 = getelementptr inbounds %struct.Stack, %struct.Stack* %3, i64 0, i32 0, i64 %26
  br label %35

28:                                               ; preds = %15
  %29 = load i32, i32* %10, align 4, !tbaa !11
  %30 = icmp slt i32 %29, 8
  br i1 %30, label %31, label %37

31:                                               ; preds = %28
  %32 = add nsw i32 %29, 1
  store i32 %32, i32* %10, align 4, !tbaa !11
  %33 = sext i32 %29 to i64
  %34 = getelementptr inbounds %struct.Queue, %struct.Queue* %4, i64 0, i32 0, i64 %33
  br label %35

35:                                               ; preds = %31, %24
  %36 = phi i32* [ %27, %24 ], [ %34, %31 ]
  store i32 %18, i32* %36, align 4, !tbaa !10
  br label %37

37:                                               ; preds = %35, %21, %28
  %38 = add nuw nsw i64 %16, 1
  %39 = icmp eq i64 %38, %11
  br i1 %39, label %12, label %15, !llvm.loop !13

40:                                               ; preds = %47, %12
  %41 = phi i32 [ 0, %12 ], [ %57, %47 ]
  %42 = getelementptr inbounds %struct.Queue, %struct.Queue* %4, i64 0, i32 1
  %43 = getelementptr inbounds %struct.Queue, %struct.Queue* %4, i64 0, i32 2
  %44 = load i32, i32* %43, align 4, !tbaa !11
  %45 = load i32, i32* %42, align 4, !tbaa !16
  %46 = icmp slt i32 %45, %44
  br i1 %46, label %60, label %73

47:                                               ; preds = %12, %47
  %48 = phi i32 [ %58, %47 ], [ %13, %12 ]
  %49 = phi i32 [ %57, %47 ], [ 0, %12 ]
  %50 = add nsw i32 %48, -1
  store i32 %50, i32* %6, align 4, !tbaa !5
  %51 = sext i32 %48 to i64
  %52 = getelementptr inbounds %struct.Stack, %struct.Stack* %3, i64 0, i32 0, i64 %51
  %53 = load i32, i32* %52, align 4, !tbaa !10
  %54 = icmp sgt i32 %53, 10
  %55 = sub i32 0, %53
  %56 = select i1 %54, i32 %53, i32 %55
  %57 = add i32 %56, %49
  %58 = load i32, i32* %6, align 4, !tbaa !5
  %59 = icmp sgt i32 %58, -1
  br i1 %59, label %47, label %40, !llvm.loop !17

60:                                               ; preds = %40, %60
  %61 = phi i32 [ %71, %60 ], [ %45, %40 ]
  %62 = phi i32 [ %70, %60 ], [ %41, %40 ]
  %63 = add nsw i32 %61, 1
  store i32 %63, i32* %42, align 4, !tbaa !16
  %64 = sext i32 %61 to i64
  %65 = getelementptr inbounds %struct.Queue, %struct.Queue* %4, i64 0, i32 0, i64 %64
  %66 = load i32, i32* %65, align 4, !tbaa !10
  %67 = icmp sgt i32 %66, 10
  %68 = zext i1 %67 to i32
  %69 = shl nsw i32 %66, %68
  %70 = add nsw i32 %69, %62
  %71 = load i32, i32* %42, align 4, !tbaa !16
  %72 = icmp slt i32 %71, %44
  br i1 %72, label %60, label %73, !llvm.loop !18

73:                                               ; preds = %60, %40
  %74 = phi i32 [ %41, %40 ], [ %70, %60 ]
  call void @llvm.lifetime.end.p0i8(i64 40, i8* nonnull %7) #5
  call void @llvm.lifetime.end.p0i8(i64 36, i8* nonnull %5) #5
  ret i32 %74
}

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #2

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
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
attributes #1 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #2 = { argmemonly mustprogress nofree nounwind willreturn writeonly }
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
!11 = !{!12, !9, i64 36}
!12 = !{!"", !7, i64 0, !9, i64 32, !9, i64 36}
!13 = distinct !{!13, !14, !15}
!14 = !{!"llvm.loop.mustprogress"}
!15 = !{!"llvm.loop.unroll.disable"}
!16 = !{!12, !9, i64 32}
!17 = distinct !{!17, !14, !15}
!18 = distinct !{!18, !14, !15}
