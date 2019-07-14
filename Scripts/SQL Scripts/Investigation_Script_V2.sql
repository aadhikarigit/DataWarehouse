-- LoginInfo
select count(*) from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientInfo pinfo  -- 102122
select count(*) from LoginInfo  -- 95152


-- LoginMaster
select count(*) from MemberMaster   -- 101409
select count(*) from NRLBAN.Carelab_Ktm_104.dbo.tbl_appUsers  -- 62

select count(*) from LoginMaster  -- 79
-- Roles
select count(*) from NRLBAN.Carelab_Ktm_104.dbo.tbl_Role --  19
select count(*) from Roles -- 0  -- 19


-- Rights
select count(*) from NRLBAN.Carelab_Ktm_104.dbo.tbl_Rights tr --  67
select count(*) from Rights -- 67


-- Roles_Rights
select count(*) from NRLBAN.Carelab_Ktm_104.dbo.tbl_RoleRights --  441
select count(*) from Role_Rights -- 441


-- BillLoginMaster

select count(*) from NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientBill]  -- 101849
select count(*) from BillLoginMaster  -- 101849


-- StoneReport

select count(*) from  NRLBAN.Carelab_Ktm_104.pat.tbl_PatientTestRecord   -- 613115
select count(*) from StoneReport   -- 226

-- SyncInt_PatientBillReport
select count(*) from Int_PatientBillReport

select top 10 * from Int_PatientBillReport
select distinct PatId,CheckedBy,CheckedBySecond,IstakenByPatient,IsReportDone,IspartiallyDone,convert(varchar(100),ResultDate,107) as ResultDate 
			into #temppatientrec   -- temporary table for temp patient records
			from  NRLBAN.Carelab_Ktm_104.pat.tbl_PatientTestRecord
			where isSync = 0 
			order by PatId;

-- syncInt_PatientReportDetails
--syncInt_PatientHistoDetails
-- syncFactPatientDiagnosis
-- syncFactPatientHistoRecords


------------------------------------------------------------------------------
select count(*) FROM NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientTestRecord] patrecord  -- 618836
select top 1 * FROM NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientTestRecord] patrecord

select count(*) from NRLBAN.Carelab_Ktm_104.dbo.tbl_TestResultForReport   -- 252565
select top 1 * from NRLBAN.Carelab_Ktm_104.dbo.tbl_TestResultForReport

select count(*) from NRLBAN.Carelab_Ktm_104.dbo.tbl_TestPanel_ProfileGroup testGroup  -- 631
select top 1 * from NRLBAN.Carelab_Ktm_104.dbo.tbl_TestPanel_ProfileGroup testGroup

select count(*) from NRLBAN.Carelab_Ktm_104.dbo.tbl_Test_DiagnosisGroup testDiagnosis   -- 751
select top 1 * from NRLBAN.Carelab_Ktm_104.dbo.tbl_Test_DiagnosisGroup testDiagnosis

select count(*) from NRLBAN.Carelab_Ktm_104.dbo.tbl_RangeOfTests trange  -- 314
select top 1 * from NRLBAN.Carelab_Ktm_104.dbo.tbl_RangeOfTests trange

select top 1 * from Int_PatientReportDetails

-------------------------------------------------------------------------------------------------
-- Whole script

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

	-- First part of script

	select distinct  
		patrecord.Id as TestRecordId
		--,pm.ID as PatId
		,patrecord.PatId as _OrigPatId
		--,pm.MainPatID as _OrigPatId
		,convert(varchar(10),patrecord.ResultDate,105) as ReportDate
		--,dgroup.ID as DiagId
		--,dgroup._DiagnosisIDOrig as _OrigDiagId
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
		--,isnull(subtest.ID,0) as SubTestId
		--,isnull(subtest._SubTestIdOrig,0) as _OrigSubTestId
		--,isnull(subtest.SubTestName,'') as SubTest
		--,isnull(subtest.SubTestRange,'') as SubTestRange
		--,isnull(subtest.SubTestUnits,'') as SubTestUnits
		--,isnull(subtest.IsActive,0) as SubTestActive
		,isnull(ttrfr.Result,'') as SubTestResult
		,isnull(patrecord.Note,'') as Note
		--,dgroup.DiagnosisName as PanelName
		,isnull(ttrfr.Method,'') as SubMethod
		--,dgroup._DiagnosisIDOrig as D_Group
		--,dgroup._DiagnosisIDOrig as GroupId
		--,dgroup.DiagnosisName as GroupName
		,InTest.Id as DigId
		,1 as rownum
		,CASE WHEN RecSync.SyncStatus <> 1 THEN 0
		ELSE 1 END AS SyncStatus
		,patrecord.IsHideOnPrint
		 from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientTestRecord patrecord
		--LEFT JOIN dbo.PatientMaster pm on pm.MainPatID = patrecord.PatId
		left join NRLBAN.Carelab_Ktm_104.dbo.tbl_TestResultForReport ttrfr on ttrfr.TestId=patrecord.Id
		--left join dbo.SubTestMaster subtest on subtest._SubTestIdOrig=ttrfr.SubTestId
		JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_Test_DiagnosisGroup InTest on patrecord.IndividualTestId=InTest.Id 
		left join dbo.TestMaster nTest on Intest.TestId = nTest._TestIDOrig
		--left join dbo.DiagnosisMaster dgroup on Intest.DGId=dgroup._DiagnosisIDOrig
		LEFT JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_RangeOfTests ran on ran.DGId=Intest.Id
		JOIN  NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientTestRecordSync] RecSync ON  patrecord.Id = RecSync.Recordid and RecSync.IsCurrent=1
		where 
		--patrecord.PatId=@PatId 
		--and 
		nTest.Testname not like 'Stone Analysis' 
		--and patrecord.IsHideOnPrint=0
		and patrecord.IsSync = 0
		and RecSync.SyncStatus IN (1,3) 

	-- Second part of script

	select distinct patrecord.Id as TestRecordId
		--,pm.ID as PatId
		--,pm.MainPatID as _OrigPatId
		,patrecord.PatId as _OrigPatId
		,convert(varchar(10),patrecord.ResultDate,105) as ReportDate
		--,dGroup.ID as DiagId
		--,dGroup._DiagnosisIDOrig as _OrigDiagId
		--,ntest.ID as TestID
		--,ntest._TestIDOrig as _OrigTestId
		,testGroup.Id as PanelId
		--,pGroup._OrigPanelId as _OrigPanelId
		,ISNULL(trange.[Max],'') as TestRange
		--,case when patrecord.IsExecutive = 1 then 'Y' else 'N' end as IsExecutive
		,patrecord.IsExecutive
		--,ntest.TotalPrice as TestPrice
		--,ntest.Method as TestMethod
		,patrecord.TestResult
		--,isnull(subtest.ID,0) as SubTestId
		--,isnull(subtest._SubTestIdOrig,0) as _OrigSubTestId
		--,isnull(subtest.SubTestName,'') as SubTest
		--,isnull(subtest.SubTestRange,'') as SubTestRange
		--,Isnull(subtest.SubTestUnits,'') as SubTestUnits
		--,isnull(subtest.IsActive,0) as SubTestActive
		,isnull(rep.Result,'') as SubTestResult
		,isnull(patrecord.Note,'') as Note
		--,pGroup.DiagnosisGroup as PanelName
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
		-- JOIN dbo.PatientMaster pm on pm.MainPatID = patrecord.PatId
		 LEFT JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_TestResultForReport rep on rep.TestId=patrecord.Id
		 --LEFT JOIN tbl_SubTests subtest on subtest.Id=rep.SubTestId
		 left join dbo.SubTestMaster subtest on subtest._SubTestIdOrig=rep.SubTestId
		 left JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_TestPanel_ProfileGroup testGroup ON patrecord.TestPanId=testGroup.Id
		 JOIN tbl_Panel_ProfileGroup pGroup ON testGroup.PanId=pGroup.Id
		 left join dbo.PanelMaster pGroup on testGroup.PanId=pGroup._OrigPanelId
		 left JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_Test_DiagnosisGroup testDiagnosis ON testGroup.DGId=testDiagnosis.Id
		 --JOIN tbl_NrlTests ntest ON ntest.Id=testDiagnosis.TestId
		 left join dbo.TestMaster ntest on ntest._TestIDOrig = testDiagnosis.TestId
		 JOIN tbl_DiagnosisGroup dGroup ON dGroup.Id=testDiagnosis.DGId 					  		   
		 join dbo.DiagnosisMaster dGroup on dGroup._DiagnosisIDOrig=testDiagnosis.DGId
		 LEft JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_RangeOfTests trange on trange.DGId=testDiagnosis.id
		 JOIN  NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientTestRecordSync] RecSync ON  patrecord.Id = RecSync.Recordid and RecSync.IsCurrent=1
		 WHERE 
		--patrecord.PatId=@PatId and 
		--patrecord.IsHideOnPrint=0
		--and 
		patrecord.IsSync = 0 
		and RecSync.SyncStatus IN (1,3) 

-----------------------------------------------------------------------------

		select distinct  
		patrecord.Id as TestRecordId
		--,pm.ID as PatId
		--,pm.MainPatID as _OrigPatId
		,patrecord.PatId as MainPatID
		,convert(varchar(10),patrecord.ResultDate,105) as ReportDate
		,Intest.DGId as OrigDiagId
		--,dgroup.ID as DiagId
		--,dgroup._DiagnosisIDOrig as _OrigDiagId
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
		--,dgroup.DiagnosisName as PanelName
		,isnull(ttrfr.Method,'') as SubMethod
		--,dgroup._DiagnosisIDOrig as D_Group
		--,dgroup._DiagnosisIDOrig as GroupId
		--,dgroup.DiagnosisName as GroupName
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
		--left join dbo.DiagnosisMaster dgroup on Intest.DGId=dgroup._DiagnosisIDOrig
		LEFT JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_RangeOfTests ran on ran.DGId=Intest.Id
		JOIN  NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientTestRecordSync] RecSync ON  patrecord.Id = RecSync.Recordid and RecSync.IsCurrent=1
		where 
		--patrecord.PatId=@PatId 
		--and 
		nTest.Testname not like 'Stone Analysis' 
		--and patrecord.IsHideOnPrint=0
		and patrecord.IsSync = 0
		and RecSync.SyncStatus IN (1,3) 


		select top 10 * from  NRLBAN.Carelab_Ktm_104.pat.tbl_PatientTestRecord patrecord


		--------------------------------
		-- Int_PatientBillReport

		select --top 2
			distinct 
			 1 as  ClientId
			,pm.ID as PatId
			,pm.MainPatId as _OrigPatId
			,isnull(pm.MemberCode,'') as MemberCode
			,bm.BillMasterID as BillId
			,bm.BillMasterID as _OrigBillId
			,bm.BillNo
			,convert(varchar(10),tpb.BillDate,105) as BillDate
			,convert(varchar(10),tpb.BillDate,105) as ReportDate
			,tau.usrFullName as EnteredBy
			,ISNULL(ms._SpecialistIdOrig ,0)as SpecialistId
			,ISNULL(ms2._SpecialistIdOrig,0) as SecondSpecialistId
			--, CASE WHEN tptr.IstakenByPatient = 1 THEN 'Y' ELSE 'N' END AS IsReportTaken
			,isnull(tptr.IstakenByPatient,0) as IsReportTaken
			--, CASE WHEN tptr.IsReportDone=1 THEN 'Y' ELSE 'N' END AS IsDone
			,isnull(tptr.IsReportDone,0) as IsDone
			--, CASE WHEN tptr.IspartiallyDone=1 THEN 'Y' ELSE 'N' END AS IsPartiallyDone
			,isnull(tptr.IspartiallyDone,0) as IsPartiallyDone
			, ISNULL(bm.BillTotal,0) AS BillPriceFinal
			,ISNULL(rm.ID,0) as RequestorId
			,tptr.ResultDate
			from  NRLBAN.Carelab_Ktm_104.pat.tbl_PatientBill tpb
			join dbo.PatientMaster pm on pm.MainPatId=tpb.PatId
			left join dbo.RequestorMaster rm on rm.Id=pm.RequestorId
			join dbo.BillMaster bm on bm._PatientId=tpb.PatId 
			left join  NRLBAN.Carelab_Ktm_104.dbo.tbl_appUsers tau on tau.usruserid=tpb.UserId
			join #temppatientrec as tptr on tptr.PatId=tpb.PatId
			left join dbo.MasterSpecialist ms on ms._SpecialistIdOrig=tptr.CheckedBy and ms.IsReferrer=0
			left join dbo.MasterSpecialist ms2 on ms2._SpecialistIdOrig=tptr.CheckedBySecond and ms2.IsReferrer=0



			select 
			pm.MainPatId,bm.BillNo,count(*) as totcount
			from  NRLBAN.Carelab_Ktm_104.pat.tbl_PatientBill tpb
			join dbo.PatientMaster pm on pm.MainPatId=tpb.PatId
			left join dbo.RequestorMaster rm on rm.Id=pm.RequestorId
			join dbo.BillMaster bm on bm._PatientId=tpb.PatId 
			left join  NRLBAN.Carelab_Ktm_104.dbo.tbl_appUsers tau on tau.usruserid=tpb.UserId
			group by pm.MainPatID,bm.BillNo
			having count(*) > 1
			--join #temppatientrec as tptr on tptr.PatId=tpb.PatId


			left join dbo.MasterSpecialist ms on ms._SpecialistIdOrig=tptr.CheckedBy and ms.IsReferrer=0
			left join dbo.MasterSpecialist ms2 on ms2._SpecialistIdOrig=tptr.CheckedBySecond and ms2.IsReferrer=0


			select * from  NRLBAN.Carelab_Ktm_104.pat.tbl_PatientBill tpb where tpb.PatId = 105075
			select * from PatientMaster where MainPatId = 105075

			select * from  NRLBAN.Carelab_Ktm_104.pat.tbl_PatientTestRecord where PatId=90790

			select 
			pm.MainPatId,bm.BillNo, count(*) as totcount
			from  NRLBAN.Carelab_Ktm_104.pat.tbl_PatientBill tpb
			join dbo.PatientMaster pm on pm.MainPatId=tpb.PatId
			left join dbo.RequestorMaster rm on rm.Id=pm.RequestorId
			join dbo.BillMaster bm on bm._PatientId=tpb.PatId 
			left join  NRLBAN.Carelab_Ktm_104.dbo.tbl_appUsers tau on tau.usruserid=tpb.UserId
			join #temppatientrec as tptr on tptr.PatId=tpb.PatId
			left join dbo.MasterSpecialist ms on ms._SpecialistIdOrig=tptr.CheckedBy and ms.IsReferrer=0
			left join dbo.MasterSpecialist ms2 on ms2._SpecialistIdOrig=tptr.CheckedBySecond and ms2.IsReferrer=0
			group by pm.MainPatID,bm.BillNo
			having count(*) > 1


			select * from #temppatientrec where PatId = 90790

			select * from  NRLBAN.Carelab_Ktm_104.pat.tbl_PatientTestRecord where PatId=90790


			IF OBJECT_ID('tempdb..#temppatientrec') IS NOT NULL     --Remove dbo here 
    DROP TABLE #temppatientrec  ;
	select distinct PatId
			into #temppatientrec   -- temporary table for temp patient records
			from  NRLBAN.Carelab_Ktm_104.pat.tbl_PatientTestRecord
			where isSync = 0 
			order by PatId;


			select --top 2
			distinct 
			 1 as  ClientId
			,pm.ID as PatId
			,pm.Id as _OrigPatId
			--,isnull(pm.MemberCode,'') as MemberCode
			--,bm.BillMasterID as BillId
			,bm.Id as _OrigBillId
			,bm.BillNo
			,convert(varchar(10),tpb.BillDate,105) as BillDate
			,convert(varchar(10),tpb.BillDate,105) as ReportDate
			,tau.usrFullName as EnteredBy
			, ISNULL(bm.TotalPrice,0) AS BillPriceFinal
			,ISNULL(rm.ID,0) as RequestorId
			from  NRLBAN.Carelab_Ktm_104.pat.tbl_PatientBill tpb
			--join dbo.PatientMaster pm on pm.MainPatId=tpb.PatId
			join NRLBAN.Carelab_Ktm_104.pat.tbl_PatientInfo pm on pm.Id=tpb.PatId
			left join dbo.RequestorMaster rm on rm.Id=pm.RequestorId
			--join dbo.BillMaster bm on bm._PatientId=tpb.PatId 
			join NRLBAN.Carelab_Ktm_104.pat.tbl_PatientBill bm on bm.PatId = tpb.PatId
			left join  NRLBAN.Carelab_Ktm_104.dbo.tbl_appUsers tau on tau.usruserid=tpb.UserId
			join #temppatientrec as tptr on tptr.PatId=tpb.PatId
			--left join dbo.MasterSpecialist ms on ms._SpecialistIdOrig=tptr.CheckedBy and ms.IsReferrer=0
			--left join dbo.MasterSpecialist ms2 on ms2._SpecialistIdOrig=tptr.CheckedBySecond and ms2.IsReferrer=0
			--WHERE 
			--(bm.BIllNo IS NOT NULL OR bm.BILLNO <> '') and 
			--tpb.IsSync = 0
			--ORDER BY bm.BillNo

			select top 1 * 
			from  NRLBAN.Carelab_Ktm_104.pat.tbl_PatientBill tpb
			--join dbo.PatientMaster pm on pm.MainPatId=tpb.PatId
			join NRLBAN.Carelab_Ktm_104.pat.tbl_PatientInfo pm on pm.Id=tpb.PatId
			left join dbo.RequestorMaster rm on rm.Id=pm.RequestorId
			--join dbo.BillMaster bm on bm._PatientId=tpb.PatId 
			join NRLBAN.Carelab_Ktm_104.pat.tbl_PatientBill bm on bm.PatId = tpb.PatId
			left join  NRLBAN.Carelab_Ktm_104.dbo.tbl_appUsers tau on tau.usruserid=tpb.UserId
			join #temppatientrec as tptr on tptr.PatId=tpb.PatId


			 select top 1 * from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientInfo tpi
			select top 1 * from PatientMaster 
			select top 1 * from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientBill tpb


			-------------20190709---------------------

			select top 1 * from NRLBAN.Carelab_Ktm_104.dbo.tbl_Test_DiagnosisGroup
			select top 1 * from NRLBAN.Carelab_Ktm_104.dbo.tbl_TestPanel_ProfileGroup testGroup


			select * from Int_PatientReportDetails where _OrigPatId=4

			select _TestIDOrig,TestCode,count(*) as totcount from TestMaster group by _TestIDOrig,TestCode having count(*) > 1

			select * from SubTestMaster