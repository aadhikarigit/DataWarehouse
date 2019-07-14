USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[syncSubTestMaster]    Script Date: 7/11/2019 4:48:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  proc [Sync].[syncSubTestMaster]
	@fiscalyear varchar(10) = '2075-76'
as
begin
	Merge dbo.SubTestMaster as target
	using (
	select t1.Id as _SubTestIdOrig
		,ISNULL(t1.TestSubType,'') as SubTestName
		,ISNULL(t1.[Group],'') as SubTestGroup
		,ISNULL(t1.SubTestRange,'') as SubTestRange
		,ISNULL(t1.SubTestUnits,'') as SubTestUnits
		,ISNULL(t1.SubTestId,0) as ParentSubTestId
		,ISNULL(t2.TestSubType,'') as  ParentSubTest
		,isnull(t1.IsActive,0) as IsActive
		,getdate() as CreateTs
		,getdate() as UpdateTs
		,t1.TestId as _OrigTestId
		from NRLBAN.Carelab_Ktm_104.dbo.tbl_SubTests t1
		left join NRLBAN.Carelab_Ktm_104.dbo.tbl_SubTests t2 on t2.SubTestId=t1.Id
		where t1.IsSync = 0
	) as source
	on target._SubTestIdOrig = source._SubTestIdOrig
		and target.fiscalyear = @fiscalyear
	when matched and
	(		target.SubTestName     <> source.SubTestName
		 or target.SubTestGroup    <> source.SubTestGroup
		 or target.SubTestRange    <> source.SubTestRange
		 or target.SubTestUnits    <> source.SubTestUnits
		 or target.ParentSubTestId <> source.ParentSubTestId
		 or target.ParentSubTest   <> source.ParentSubTest
		 or target.IsActive        <> source.IsActive
		 or target._OrigTestId	   <> source._OrigTestId
	)
	 then
	update set 
	   target.SubTestName     = source.SubTestName
	 , target.SubTestGroup    = source.SubTestGroup
	 , target.SubTestRange    = source.SubTestRange
	 , target.SubTestUnits    = source.SubTestUnits
	 , target.ParentSubTestId = source.ParentSubTestId
	 , target.ParentSubTest   = source.ParentSubTest
	 , target.IsActive        = source.IsActive
	 , target.UpdateTs        = getdate()
	 , target.IsSync		  = 0
	 , target._OrigTestId	  = source._OrigTestId

	when not matched then
	insert 
	values( source._SubTestIdOrig
			,source.SubTestName
		   ,source.SubTestGroup
		   ,source.SubTestRange
		   ,source.SubTestUnits
		   ,source.ParentSubTestId
		   ,source.ParentSubTest
		   ,source.IsActive
		   ,0
		   ,getdate()
		   ,getdate()
		   ,source._OrigTestId
		   ,@fiscalyear);
end
