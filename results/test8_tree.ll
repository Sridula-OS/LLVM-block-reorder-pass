; ModuleID = 'test8_tree.c'
source_filename = "test8_tree.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.TreeNode = type { i32, %struct.TreeNode*, %struct.TreeNode* }

@__const.main.left_left = private unnamed_addr constant %struct.TreeNode { i32 3, %struct.TreeNode* null, %struct.TreeNode* null }, align 8
@__const.main.right = private unnamed_addr constant %struct.TreeNode { i32 18, %struct.TreeNode* null, %struct.TreeNode* null }, align 8
@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: nofree noinline nosync nounwind readonly uwtable
define dso_local i32 @tree_score(%struct.TreeNode* noundef readonly %0) local_unnamed_addr #0 {
  %2 = icmp eq %struct.TreeNode* %0, null
  br i1 %2, label %17, label %3

3:                                                ; preds = %1
  %4 = getelementptr inbounds %struct.TreeNode, %struct.TreeNode* %0, i64 0, i32 0
  %5 = load i32, i32* %4, align 8, !tbaa !5
  %6 = icmp sgt i32 %5, 9
  %7 = sub nsw i32 0, %5
  %8 = select i1 %6, i32 %5, i32 %7
  %9 = getelementptr inbounds %struct.TreeNode, %struct.TreeNode* %0, i64 0, i32 1
  %10 = load %struct.TreeNode*, %struct.TreeNode** %9, align 8, !tbaa !11
  %11 = call i32 @tree_score(%struct.TreeNode* noundef %10)
  %12 = add nsw i32 %8, %11
  %13 = getelementptr inbounds %struct.TreeNode, %struct.TreeNode* %0, i64 0, i32 2
  %14 = load %struct.TreeNode*, %struct.TreeNode** %13, align 8, !tbaa !12
  %15 = call i32 @tree_score(%struct.TreeNode* noundef %14)
  %16 = add nsw i32 %12, %15
  br label %17

17:                                               ; preds = %1, %3
  %18 = phi i32 [ %16, %3 ], [ 0, %1 ]
  ret i32 %18
}

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nofree nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #2 {
  %1 = alloca %struct.TreeNode, align 8
  %2 = alloca %struct.TreeNode, align 8
  %3 = alloca %struct.TreeNode, align 8
  %4 = alloca %struct.TreeNode, align 8
  %5 = bitcast %struct.TreeNode* %1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %5) #5
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %5, i8* noundef nonnull align 8 dereferenceable(24) bitcast (%struct.TreeNode* @__const.main.left_left to i8*), i64 24, i1 false)
  %6 = bitcast %struct.TreeNode* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %6) #5
  %7 = getelementptr inbounds %struct.TreeNode, %struct.TreeNode* %2, i64 0, i32 0
  store i32 12, i32* %7, align 8, !tbaa !5
  %8 = getelementptr inbounds %struct.TreeNode, %struct.TreeNode* %2, i64 0, i32 1
  store %struct.TreeNode* %1, %struct.TreeNode** %8, align 8, !tbaa !11
  %9 = getelementptr inbounds %struct.TreeNode, %struct.TreeNode* %2, i64 0, i32 2
  store %struct.TreeNode* null, %struct.TreeNode** %9, align 8, !tbaa !12
  %10 = bitcast %struct.TreeNode* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %10) #5
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %10, i8* noundef nonnull align 8 dereferenceable(24) bitcast (%struct.TreeNode* @__const.main.right to i8*), i64 24, i1 false)
  %11 = bitcast %struct.TreeNode* %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %11) #5
  %12 = getelementptr inbounds %struct.TreeNode, %struct.TreeNode* %4, i64 0, i32 0
  store i32 8, i32* %12, align 8, !tbaa !5
  %13 = getelementptr inbounds %struct.TreeNode, %struct.TreeNode* %4, i64 0, i32 1
  store %struct.TreeNode* %2, %struct.TreeNode** %13, align 8, !tbaa !11
  %14 = getelementptr inbounds %struct.TreeNode, %struct.TreeNode* %4, i64 0, i32 2
  store %struct.TreeNode* %3, %struct.TreeNode** %14, align 8, !tbaa !12
  %15 = call i32 @tree_score(%struct.TreeNode* noundef nonnull %4)
  %16 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %15)
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %11) #5
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %10) #5
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %6) #5
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %5) #5
  ret i32 0
}

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #3

; Function Attrs: nofree nounwind
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #4

attributes #0 = { nofree noinline nosync nounwind readonly uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
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
!6 = !{!"TreeNode", !7, i64 0, !10, i64 8, !10, i64 16}
!7 = !{!"int", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = !{!"any pointer", !8, i64 0}
!11 = !{!6, !10, i64 8}
!12 = !{!6, !10, i64 16}
