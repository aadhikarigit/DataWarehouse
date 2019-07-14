USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[syncInt_PatientReportDetails]    Script Date: 6/28/2019 7:41:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--TRUNCATE TABLE dbo.Int_PatientReportDetails
--SELECT COUNT(*) FROM dbo.Int_PatientReportDetails
--EXEC sync.syncInt_PatientReportDetails

ALTER proc [Sync].[syncInt_PatientReportDetails]
as
begin
	Merge dbo.Int_PatientReportDetails as target
	using (
	select * from
	(
		select distinct  
		patrecord.Id as TestRecordId
		,pm.ID as PatId
		,pm.MainPatID as _OrigPatId
		,convert(varchar(10),patrecord.ResultDate,105) as ReportDate
		,dgroup.ID as DiagId
		,dgroup._DiagnosisIDOrig as _OrigDiagId
		,nTest.ID as TestID
		,nTest._TestIDOrig as _OrigTestId
		,0 as PanelId
		,0 as _OrigPanelId
		--,dgroup.DiagnosisName as Panel
		,isnull(ran.[Max],'') as TestRange
		--,case when patrecord.IsExecutive = 1 then 'Y' else 'N' end as IsExecutive
		,patrecord.IsExecutive
		,nTest.TotalPrice as TestPrice
		,nTest.Method as TestMethod
		,patrecord.TestResult
		,isnull(subtest.ID,0) as SubTestId
		,isnull(subtest._SubTestIdOrig,0) as _OrigSubTestId
		,isnull(subtest.SubTestName,'') as SubTest
		,isnull(subtest.SubTestRange,'') as SubTestRange
		,isnull(subtest.SubTestUnits,'') as SubTestUnits
		,isnull(subtest.IsActive,0) as SubTestActive
		,isnull(ttrfr.Result,'') as SubTestResult
		,isnull(patrecord.Note,'') as Note
		,dgroup.DiagnosisName as PanelName
		,isnull(ttrfr.Method,'') as SubMethod
		,dgroup._DiagnosisIDOrig as D_Group
		,dgroup._DiagnosisIDOrig as GroupId
		,dgroup.DiagnosisName as GroupName
		,InTest.Id as DigId
		,1 as rownum
		,CASE WHEN RecSync.SyncStatus <> 1 THEN 0
		ELSE 1 END AS SyncStatus
		,patrecord.IsHideOnPrint
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
		--patrecord.PatId=@PatId 
		--and 
		nTest.Testname not like 'Stone Analysis' 
		--and patrecord.IsHideOnPrint=0
		and patrecord.IsSync = 0
		and RecSync.SyncStatus IN (1,3) 
		union

		--Declare @PatId int = 19
		select distinct patrecord.Id as TestRecordId
		,pm.ID as PatId
		,pm.MainPatID as _OrigPatId
		,convert(varchar(10),patrecord.ResultDate,105) as ReportDate
		,dGroup.ID as DiagId
		,dGroup._DiagnosisIDOrig as _OrigDiagId
		,ntest.ID as TestID
		,ntest._TestIDOrig as _OrigTestId
		,testGroup.Id as PanelId
		,pGroup._OrigPanelId as _OrigPanelId
		,ISNULL(trange.[Max],'') as TestRange
		--,case when patrecord.IsExecutive = 1 then 'Y' else 'N' end as IsExecutive
		,patrecord.IsExecutive
		,ntest.TotalPrice as TestPrice
		,ntest.Method as TestMethod
		,patrecord.TestResult
		,isnull(subtest.ID,0) as SubTestId
		,isnull(subtest._SubTestIdOrig,0) as _OrigSubTestId
		,isnull(subtest.SubTestName,'') as SubTest
		,isnull(subtest.SubTestRange,'') as SubTestRange
		,Isnull(subtest.SubTestUnits,'') as SubTestUnits
		,isnull(subtest.IsActive,0) as SubTestActive
		,isnull(rep.Result,'') as SubTestResult
		,isnull(patrecord.Note,'') as Note
		,pGroup.DiagnosisGroup as PanelName
		,isnull(rep.Method, '') as SubMethod
		,pGroup.DiagnosisId as D_Group
		,pGroup._OrigPanelId as GroupId
		,pGroup.PanelName as GroupName
		,testDiagnosis.Id as DigId
		,1 as rownum
		,CASE WHEN RecSync.SyncStatus <> 1 THEN 0
		ELSE 1 END AS SyncStatus
		,patrecord.IsHideOnPrint
		 FROM NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientTestRecord] patrecord
		 JOIN dbo.PatientMaster pm on pm.MainPatID = patrecord.PatId
		 LEFT JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_TestResultForReport rep on rep.TestId=patrecord.Id
		 --LEFT JOIN tbl_SubTests subtest on subtest.Id=rep.SubTestId
		 left join dbo.SubTestMaster subtest on subtest._SubTestIdOrig=rep.SubTestId
		 left JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_TestPanel_ProfileGroup testGroup ON patrecord.TestPanId=testGroup.Id
		 --JOIN tbl_Panel_ProfileGroup pGroup ON testGroup.PanId=pGroup.Id
		 left join dbo.PanelMaster pGroup on testGroup.PanId=pGroup._OrigPanelId
		 left JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_Test_DiagnosisGroup testDiagnosis ON testGroup.DGId=testDiagnosis.Id
		 --JOIN tbl_NrlTests ntest ON ntest.Id=testDiagnosis.TestId
		 left join dbo.TestMaster ntest on ntest._TestIDOrig = testDiagnosis.TestId
		 --JOIN tbl_DiagnosisGroup dGroup ON dGroup.Id=testDiagnosis.DGId 					  		   
		 join dbo.DiagnosisMaster dGroup on dGroup._DiagnosisIDOrig=testDiagnosis.DGId
		 LEft JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_RangeOfTests trange on trange.DGId=testDiagnosis.id
		 JOIN  NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientTestRecordSync] RecSync ON  patrecord.Id = RecSync.Recordid and RecSync.IsCurrent=1
		 WHERE 
		--patrecord.PatId=@PatId and 
		--patrecord.IsHideOnPrint=0
		--and 
		patrecord.IsSync = 0 
		and RecSync.SyncStatus IN (1,3) 
	) as t

	
	) as source
	on		target._OrigPatId = source._OrigPatId
		and target.PatId           = source.PatId
		and target.DiagId          = source.DiagId
		and target._OrigDiagId     = source._OrigDiagId
		and target.TestID          = source.TestID
		and target._OrigTestId     = source._OrigTestId
		and target.PanelId         = source.PanelId
		and target._OrigPanelId    = source._OrigPanelId
		and target._OrigSubTestId  = source._OrigSubTestId
		and target.SubTestId       = source.SubTestId
		and target.IsExecutive     = source.IsExecutive
	when matched 
	--and 
	--(
	--	   target.TestRange       <> source.TestRange
	--	--OR target.IsExecutive    <> source.IsExecutive
	--	OR target.TestPrice       <> source.TestPrice
	--	OR target.TestMethod      <> source.TestMethod
	--	OR target.TestResult      <> source.TestResult
	--	OR target.SubTest         <> source.SubTest
	--	OR target.SubTestRange    <> source.SubTestRange
	--	OR target.SubTestUnits    <> source.SubTestUnits
	--	OR target.SubTestActive   <> source.SubTestActive
	--	OR target.SubTestResult   <> source.SubTestResult
	--	OR target.Note            <> source.Note
	--	OR target.PanelName       <> source.PanelName
	--	OR target.SubMethod       <> source.SubMethod
	--	OR target.D_Group         <> source.D_Group
	--	OR target.GroupId         <> source.GroupId
	--	OR target.GroupName       <> source.GroupName
	--	OR target.DigId           <> source.DigId
	--	OR target.ReportDate      <> source.ReportDate
	--	OR target.rownum          <> source.rownum
	--	--OR target.SyncStatus	  <> source.SyncStatus
	--)
	THEN UPDATE
	SET    
		  target.ReportDate      = source.ReportDate
		, target.TestRange       = source.TestRange
		--, target.IsExecutive    = source.IsExecutive
		, target.TestPrice       = source.TestPrice
		, target.TestMethod      = source.TestMethod
		, target.TestResult      = source.TestResult
		, target.SubTest         = source.SubTest
		, target.SubTestRange    = source.SubTestRange
		, target.SubTestUnits    = source.SubTestUnits
		, target.SubTestActive   = source.SubTestActive
		, target.SubTestResult   = source.SubTestResult
		, target.Note            = source.Note
		, target.PanelName       = source.PanelName
		, target.SubMethod       = source.SubMethod
		, target.D_Group         = source.D_Group
		, target.GroupId         = source.GroupId
		, target.GroupName       = source.GroupName
		, target.DigId           = source.DigId
		, target.rownum			 = source.rownum
		,target.IsSync			 = 0
		,target.SyncStatus		 = source.SyncStatus
		,target.TestRecordId	 = source.TestRecordId
		,target.IsFactLoaded	 = 0
		,target.IsHideOnPrint   = source.IsHideOnPrint
	when not matched then
	insert --(_OrigRequestorId,RequestorName,ReqIsActive,ReqReqId,CreateTs,UpdateTs)
	values( source.PatId
			,source._OrigPatId
			,source.ReportDate
			,source.DiagId
			,source._OrigDiagId
			,source.TestID
			,source._OrigTestId
			,source.PanelId
			,source._OrigPanelId
			,source.TestRange
			,source.IsExecutive
			,source.TestPrice
			,source.TestMethod
			,source.TestResult
			,source.SubTestId
			,source._OrigSubTestId
			,source.SubTest
			,source.SubTestRange
			,source.SubTestUnits
			,source.SubTestActive
			,source.SubTestResult
			,source.Note
			,source.PanelName
			,source.SubMethod
			,source.D_Group
			,source.GroupId
			,source.GroupName
			,source.DigId
			,source.rownum
			,0
			,source.SyncStatus
			,source.TestRecordId
			,0
			,source.IsHideOnPrint
			);
end
