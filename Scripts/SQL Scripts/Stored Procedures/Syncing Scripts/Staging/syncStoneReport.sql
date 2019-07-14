USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[syncStoneReport]    Script Date: 6/26/2019 12:21:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select count(*) from DATAWAREHOUSE.DBO.StoneReport

ALTER proc [Sync].[syncStoneReport]
as
begin
	
	
	Merge dbo.StoneReport as target
	using (
			SELECT	 nTest._TestIDOrig as _OrigTestId
				,patrecord.PatId as _OrigPatId
				,patrecord.id as RecordId
				,subtest._SubTestIdOrig as _OrigSubTestId
				,subtest.SubTestName as TestSubType
				,ttrfr.Result as 'Result'
				,subtest.SubTestGroup as [Group]
				,ttrfr.[Range]
				,ttrfr.Method
				,ttrfr.Id as _OrigResultId 
				,patrecord.PatId as ActualPatId
				,isnull(patrecord.IstakenByPatient,0) as IsReportTaken
				,isnull(patrecord.IsReportDone,0) as IsReportDone
				,patrecord.CheckedBy as SpecialistId
				,convert(varchar(10),patrecord.ResultDate,105) as ResultDate
			from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientTestRecord patrecord
		LEFT JOIN dbo.PatientMaster pm on pm.MainPatID = patrecord.PatId
		left join NRLBAN.Carelab_Ktm_104.dbo.tbl_TestResultForReport ttrfr on ttrfr.TestId=patrecord.Id
		left join dbo.SubTestMaster subtest on subtest._SubTestIdOrig=ttrfr.SubTestId
		 JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_Test_DiagnosisGroup InTest on patrecord.IndividualTestId=InTest.Id 
		left join dbo.TestMaster nTest on Intest.TestId = nTest._TestIDOrig
		left join dbo.DiagnosisMaster dgroup on Intest.DGId=dgroup._DiagnosisIDOrig
		LEFT JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_RangeOfTests ran on ran.DGId=Intest.Id
		JOIN  NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientTestRecordSync] RecSync ON  patrecord.Id = RecSync.Recordid and RecSync.IsCurrent=1
		where 
		nTest.Testname like '%Stone Analysis%'
		and patrecord.IsSync = 0
		and RecSync.SyncStatus IN (1,3)					
	) as source
	on target._OrigPatID		= source._OrigPatId
		AND target._OrigTestId		= source._OrigTestId
		AND target._OrigSubTestId	= source._OrigSubTestId
			
	when matched
	
	then
	update set
	   --target._OrigPatID		= source.PatId
	   target.TestSubType		= source.TestSubType
	,  target.Result			= source.Result
	,  target.[Group]			= source.[Group]
	,  target.[Range]			= source.[Range]
	,  target.Method			= source.Method
	,  target._OrigResultId		= source._OrigResultId
	,  target.IsSync			= 0
	,  target.RecordId			= source.RecordId
	,  target.IsReportDone		= source.IsReportDone
	,  target.IsReportTaken		= source.IsReportTaken
	,  target.SpecialistId		= source.SpecialistId
	,  target.ResultDate		= source.ResultDate
	when not matched then
	insert
	values(
		source._OrigPatId
		,source._OrigTestId
		,source._OrigSubTestId
		,source.TestSubType
		,source.Result
		,source.[Group]
		,source.[Range]
		,source.Method
		,source._OrigResultId
		,getdate()
		,getdate()
		,source.ActualPatId
		,0
		,source.RecordId
		,source.IsReportDone
		,source.IsReportTaken
		,source.SpecialistId
		,source.ResultDate
	);
end