; ModuleID = 'test7_linked_list.c'
source_filename = "test7_linked_list.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Node = type { i32, %struct.Node* }

@__const.main.fifth = private unnamed_addr constant %struct.Node { i32 10, %struct.Node* null }, align 8
@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: nofree noinline norecurse nosync nounwind readonly uwtable
define dso_local i32 @process_list(%struct.Node* noundef readonly %0) local_unnamed_addr #0 {
  %2 = icmp eq %struct.Node* %0, null
  br i1 %2, label %23, label %3

3:                                                ; preds = %1, %18
  %4 = phi i32 [ %19, %18 ], [ 0, %1 ]
  %5 = phi %struct.Node* [ %21, %18 ], [ %0, %1 ]
  %6 = getelementptr inbounds %struct.Node, %struct.Node* %5, i64 0, i32 0
  %7 = load i32, i32* %6, align 8, !tbaa !5
  %8 = icmp sgt i32 %7, -1
  br i1 %8, label %9, label %16

9:                                                ; preds = %3
  %10 = and i32 %7, 1
  %11 = icmp eq i32 %10, 0
  br i1 %11, label %12, label %14

12:                                               ; preds = %9
  %13 = add nsw i32 %7, %4
  br label %18

14:                                               ; preds = %9
  %15 = add nsw i32 %4, 1
  br label %18

16:                                               ; preds = %3
  %17 = sub nsw i32 %4, %7
  br label %18

18:                                               ; preds = %12, %14, %16
  %19 = phi i32 [ %13, %12 ], [ %15, %14 ], [ %17, %16 ]
  %20 = getelementptr inbounds %struct.Node, %struct.Node* %5, i64 0, i32 1
  %21 = load %struct.Node*, %struct.Node** %20, align 8, !tbaa !11
  %22 = icmp eq %struct.Node* %21, null
  br i1 %22, label %23, label %3, !llvm.loop !12

23:                                               ; preds = %18, %1
  %24 = phi i32 [ 0, %1 ], [ %19, %18 ]
  ret i32 %24
}

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nofree nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #2 {
  %1 = alloca %struct.Node, align 8
  %2 = alloca %struct.Node, align 8
  %3 = alloca %struct.Node, align 8
  %4 = alloca %struct.Node, align 8
  %5 = alloca %struct.Node, align 8
  %6 = bitcast %struct.Node* %1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %6) #5
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(16) %6, i8* noundef nonnull align 8 dereferenceable(16) bitcast (%struct.Node* @__const.main.fifth to i8*), i64 16, i1 false)
  %7 = bitcast %struct.Node* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %7) #5
  %8 = getelementptr inbounds %struct.Node, %struct.Node* %2, i64 0, i32 0
  store i32 -4, i32* %8, align 8, !tbaa !5
  %9 = getelementptr inbounds %struct.Node, %struct.Node* %2, i64 0, i32 1
  store %struct.Node* %1, %struct.Node** %9, align 8, !tbaa !11
  %10 = bitcast %struct.Node* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %10) #5
  %11 = getelementptr inbounds %struct.Node, %struct.Node* %3, i64 0, i32 0
  store i32 7, i32* %11, align 8, !tbaa !5
  %12 = getelementptr inbounds %struct.Node, %struct.Node* %3, i64 0, i32 1
  store %struct.Node* %2, %struct.Node** %12, align 8, !tbaa !11
  %13 = bitcast %struct.Node* %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %13) #5
  %14 = getelementptr inbounds %struct.Node, %struct.Node* %4, i64 0, i32 0
  store i32 8, i32* %14, align 8, !tbaa !5
  %15 = getelementptr inbounds %struct.Node, %struct.Node* %4, i64 0, i32 1
  store %struct.Node* %3, %struct.Node** %15, align 8, !tbaa !11
  %16 = bitcast %struct.Node* %5 to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %16) #5
  %17 = getelementptr inbounds %struct.Node, %struct.Node* %5, i64 0, i32 0
  store i32 3, i32* %17, align 8, !tbaa !5
  %18 = getelementptr inbounds %struct.Node, %struct.Node* %5, i64 0, i32 1
  store %struct.Node* %4, %struct.Node** %18, align 8, !tbaa !11
  %19 = call i32 @process_list(%struct.Node* noundef nonnull %5)
  %20 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %19)
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %16) #5
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %13) #5
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %10) #5
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %7) #5
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %6) #5
  ret i32 0
}

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #3

; Function Attrs: nofree nounwind
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #4

attributes #0 = { nofree noinline norecurse nosync nounwind readonly uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #2 = { nofree nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { argmemonly mustprogress nofree nounwind willreturn }
attributes #4 = { nofree nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!5 = !{!6, !7, i64 0}
!6 = !{!"Node", !7, i64 0, !10, i64 8}
!7 = !{!"int", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = !{!"any pointer", !8, i64 0}
!11 = !{!6, !10, i64 8}
!12 = distinct !{!12, !13, !14}
!13 = !{!"llvm.loop.mustprogress"}
!14 = !{!"llvm.loop.unroll.disable"}
