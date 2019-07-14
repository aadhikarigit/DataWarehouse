	-- PatientMaster
		-- TestMaster
		select count(*) from TestMaster
		select count(*) from NRLBAN.Carelab_Ktm_104.dbo.tbl_NRLTests T

		-- SubTestMaster
		select count(*) from NRLBAN.Carelab_Ktm_104.dbo.tbl_SubTests t1
		select count(*) from SubTestMaster

		-- RequestorMaster
		select count(*) from RequestorMaster
		select count(*) from NRLBAN.Carelab_Ktm_104.dbo.tbl_RequestorInfo ri
		-- MemberMaster
		select count(*) from MemberMaster
		select count(*) from NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientInfo] pat
		-- DiagnosisMaster
		select count(*) from DiagnosisMaster
		select count(*) from NRLBAN.Carelab_Ktm_104.dbo.tbl_DiagnosisGroup Diag
		-- MasterSpecialist
		select count(*) from MasterSpecialist
		select count(*) from NRLBAN.Carelab_Ktm_104.pat.tbl_PatReferDoctor ptpr
		select count(*) from NRLBAN.Carelab_Ktm_104.dbo.tbl_PatTestCheckedBy tptc
						where tptc.Name NOT IN ('' ,'SELECT')
		-- PanelMaster
		select count(*) from PanelMaster
		select count(*) from NRLBAN.Carelab_Ktm_104.dbo.tbl_Panel_ProfileGroup tppg
		-- BillMaster
		select count(*) from BillMaster
		select count(*) from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientBill tpb

		-- PatientHistoMaster   -- for now solved by ignoring the duplicate Patient id but is not a proper solution, need to confirm with Luniva
		select count(*) from PatientHistoMaster
		select count(*) from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientHistoRecord tphr

		-----------issue in merge, so investigation------------------
		select 
			tphr.Id as HistoRecordId
			,tphr.PatId as _OrigPatId
			,tphr.HistoTestId
			,tphr.CheckedBy as CheckedByFirstId
			,isnull(ms.Name,'') as CheckedByFirstName
			,isnull(ms.Designation,'') as CheckedByFirstDesignation
			,case when (ms.NHPCRegID is null or ms.NHPCRegID='') and (ms.NMCRegID is null or ms.NMCRegID='') then isnull(ms.OtherReg,'')
			  when (ms.NHPCRegID is null or ms.NHPCRegID='') and (ms.OtherReg is null or ms.OtherReg='') then isnull(ms.NMCRegID,'')
			  when (ms.NMCRegID is null or ms.NMCRegID='') and (ms.OtherReg is null or ms.OtherReg='') then isnull(ms.NHPCRegID,'')
			 end as CheckedByFirstRegNo
			,tphr.CheckedBySecond as CheckedBySecondId
			,isnull(ms2.Name,'') as CheckedBySecondName
			,isnull(ms2.Designation,'') as CheckedBySecondDesignation
			,case when (ms2.NHPCRegID is null or ms2.NHPCRegID='') and (ms2.NMCRegID is null or ms2.NMCRegID='') then isnull(ms2.OtherReg,'')
			  when (ms2.NHPCRegID is null or ms2.NHPCRegID='') and (ms2.OtherReg is null or ms2.OtherReg='') then isnull(ms2.NMCRegID,'')
			  when (ms2.NMCRegID is null or ms2.NMCRegID='') and (ms2.OtherReg is null or ms2.OtherReg='') then isnull(ms2.NHPCRegID,'')
			 end as CheckedBySecondRegNo
			,convert(varchar(10),tphr.ReportDate,105) as ReportDate
			,tphr.IsFinished
			,tphr.HistoTestTypeId
			,thtt.HistoType as HistoTestType
			,tphr.IsTaken
			,tphr.UserId
			,tau.usrFullName as UserName
			,tphr.ReportTakenBy
			,isnull(tphr.HistoCode,'') as HistoCode
			,isnull(tphr.ResultDate,convert(datetime,'')) as ResultDate
			,tphr.ReportNepaliDate
			,isnull(tphr.Note,'') as Note
			,getdate() as CreateTs
			,getdate() as UpdateTs
			from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientHistoRecord tphr
			left join dbo.MasterSpecialist ms on ms._SpecialistIdOrig=tphr.CheckedBy and ms.IsReferrer=0
			left join  dbo.MasterSpecialist ms2 on ms2._SpecialistIdOrig=tphr.CheckedBySecond and ms2.IsReferrer=0
			left join NRLBAN.Carelab_Ktm_104.dbo.tbl_HistoTestType thtt on thtt.Id=tphr.HistoTestTypeId
			left join NRLBAN.Carelab_Ktm_104.dbo.tbl_appUsers tau on tau.usruserid=tphr.UserId
			where tphr.Issync = 0


			select tphr.PatId, tphr.HistoTestId, count(*) as totcount
			from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientHistoRecord tphr
			left join dbo.MasterSpecialist ms on ms._SpecialistIdOrig=tphr.CheckedBy and ms.IsReferrer=0
			left join  dbo.MasterSpecialist ms2 on ms2._SpecialistIdOrig=tphr.CheckedBySecond and ms2.IsReferrer=0
			left join NRLBAN.Carelab_Ktm_104.dbo.tbl_HistoTestType thtt on thtt.Id=tphr.HistoTestTypeId
			left join NRLBAN.Carelab_Ktm_104.dbo.tbl_appUsers tau on tau.usruserid=tphr.UserId
			where tphr.Issync = 0
			group by tphr.Patid, tphr.HistoTestId
			having count(*) > 1


			select * from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientHistoRecord tphr
			where PatId in
			(56135,
101725,
39204,
16448)

select count(*) from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientHistoRecord tphr where HistoCode is null and ResultDate is null
select * from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientHistoRecord tphr where HistoCode is null and ResultDate is null order by 2,3

		----------------------------------------End of Investigation---------------------------------------------------------



		-- BillLoginMaster
		select count(*) from BillLoginMaster
		select count(*) from NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientBill]

		-- LoginMaster   -- Need to confirm with Luniva
		select count(*) from LoginMaster
		select * from LoginMaster
		select count(*) from MemberMaster  mm
		join NRLBAN.Carelab_Ktm_104.dbo.tbl_MemberShip tm on tm.MemberCode=mm.MemberCode
		
		-- Roles
		select count(*) from Roles
		select count(*) from NRLBAN.Carelab_Ktm_104.dbo.tbl_Role

		-- Rights
		select count(*) from Rights
		select count(*) from NRLBAN.Carelab_Ktm_104.dbo.tbl_Rights tr

		-- LoginMaster  -- need to confirm with Luniva 
		select count(*) from LoginMaster
		select count(*) from [dbo].[MemberMaster] mm
		join NRLBAN.Carelab_Ktm_104.dbo.tbl_MemberShip tm on tm.MemberCode=mm.MemberCode

		-- LoginInfo
		select count(*) from LoginInfo
		select count(*) from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientInfo pinfo
			join NRLBAN.Carelab_Ktm_104.pat.tbl_PatientBill Binfo ON pinfo.Id = Binfo.PatId

		-- RolesRights
		select count(*) from Role_Rights
		select count(*) from NRLBAN.Carelab_Ktm_104.dbo.tbl_RoleRights

		-- Int_PatientBillReport
		select count(*) from  NRLBAN.Carelab_Ktm_104.pat.tbl_PatientBill tpb

		-- Int_PatientHistoDetails
		-- Int_PatientReportDetails


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

		select count(*) from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientTestRecord patrecord


		select --* --into New_PatientTestRecordResult--count(*) 
		patrecord.id,
		from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientTestRecord patrecord
		left join NRLBAN.Carelab_Ktm_104.dbo.tbl_TestResultForReport ttrfr on ttrfr.TestId=patrecord.Id
		JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_Test_DiagnosisGroup InTest on patrecord.IndividualTestId=InTest.Id
		LEFT JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_RangeOfTests ran on ran.DGId=Intest.Id
		--JOIN  NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientTestRecordSync] RecSync ON  patrecord.Id = RecSync.Recordid and RecSync.IsCurrent=1
		where 1=1
		--and patrecord.IsSync = 0
		--and RecSync.SyncStatus IN (1,3) 

		

		drop table Master.dbo.New_PatientTestRecordResult
		select count(*) from dbo.New_PatientTestRecordResult

		select count(*) from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientInfo tpi
		select count(*) from PatientMaster

		select count(*) from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientTestRecord patrecord where issync = 0
		select top 1 * from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientTestRecord patrecord

		select distinct count(PatId) from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientTestRecord patrecord

	

		select * from New_PatientTestRecordResult patrecord
		LEFT JOIN dbo.PatientMaster pm on pm.MainPatID = patrecord.PatId
		left join dbo.SubTestMaster subtest on subtest._SubTestIdOrig=patrecord.SubTestId
		left join dbo.TestMaster nTest on nTest._TestIDOrig = patrecord.TestId
		where patrecord.SubTestId is not null


		select count(*) from Int_PatientReportDetails

		-------------------Run today to create a new table as combination of Individual test and Panel test -------------------

		--select * into New_PatientTestRecordResult from
		 --drop table master.dbo.New_PatientTestRecordResult
		--select count(*) from master.dbo.New_PatientTestRecordResult

		-- drop table New_PatientTestRecordResult
		select * 
		into New_PatientTestRecordResult 
		from
		(
			select  --top 5
			patrecord.Id as patrecordid,	patrecord.PatId,	patrecord.IndividualTestId,	patrecord.TestPanId, 0 as _origpanelid,	patrecord.TestResult,	
			patrecord.CheckedBy,	patrecord.CheckedBySecond,	patrecord.ResultDate,	patrecord.Nrl_Reg_No,	patrecord.UserId as patuserid,	
			patrecord.IsExecutive,	patrecord.IstakenByPatient,	patrecord.IsReportDone,	patrecord.ReportTakenBy,	patrecord.Note as patnote,	
			patrecord.TestRange,	patrecord.IspartiallyDone,	patrecord.IsHideOnPrint as patrechideonprint,	patrecord.ReportedNepaliDate,	
			patrecord.IsSync,	patrecord.CheckedByThird,	patrecord.Abnormality,	
					ttrfr.Id as ttrfrid,	ttrfr.TestId as ttrfrtestid,	ttrfr.SubTestId,	ttrfr.Result,	ttrfr.[Range],	ttrfr.Method,	
					ttrfr.Abnormality as ttfrabnormality,	ttrfr.IsHideOnPrint,	ttrfr.Note,	ttrfr.ResultDate as testresultdate,	ttrfr.UserId,	
					InTest.Id as intestid,	InTest.DGId as intestdgid,	InTest.TestId,	InTest.SubGroupId,	InTest.IsDifferentialCount,	InTest.SubDiagnosis,	
					InTest.IsActive,	InTest.IsSync as intestissync,	
					ran.Id as ranid,	ran.DGId,	ran.[Min],	ran.[Max],	ran.[Group],	ran.SubGroup,	ran.Date
					--into New_PatientTestRecordResult
					from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientTestRecord patrecord
			left join NRLBAN.Carelab_Ktm_104.dbo.tbl_TestResultForReport ttrfr on ttrfr.TestId=patrecord.Id
			JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_Test_DiagnosisGroup InTest on patrecord.IndividualTestId=InTest.Id
			LEFT JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_NRLTests nTest on nTest.Id = InTest.TestId
			LEFT JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_RangeOfTests ran on ran.DGId=Intest.Id
			--JOIN  NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientTestRecordSync] RecSync ON  patrecord.Id = RecSync.Recordid and RecSync.IsCurrent=1
			where 1=1
			--and nTest.Testname not like 'Stone Analysis'
			--and patrecord.IsSync = 0
			--and RecSync.SyncStatus IN (1,3) 

			UNION

			select-- top 1
			patrecord.Id as patrecordid,	patrecord.PatId,	patrecord.IndividualTestId,	patrecord.TestPanId, tppg.id as _origpanelid,	patrecord.TestResult,	
			patrecord.CheckedBy,	patrecord.CheckedBySecond,	patrecord.ResultDate,	patrecord.Nrl_Reg_No,	patrecord.UserId as patuserid,	
			patrecord.IsExecutive,	patrecord.IstakenByPatient,	patrecord.IsReportDone,	patrecord.ReportTakenBy,	patrecord.Note as patnote,	
			patrecord.TestRange,	patrecord.IspartiallyDone,	patrecord.IsHideOnPrint as patrechideonprint,	patrecord.ReportedNepaliDate,	
			patrecord.IsSync,	patrecord.CheckedByThird,	patrecord.Abnormality,	
					ttrfr.Id as ttrfrid,	ttrfr.TestId as ttrfrtestid,	ttrfr.SubTestId,	ttrfr.Result,	ttrfr.[Range],	ttrfr.Method,	
					ttrfr.Abnormality as ttfrabnormality,	ttrfr.IsHideOnPrint,	ttrfr.Note,	ttrfr.ResultDate as testresultdate,	ttrfr.UserId,	
					testDiagnosis.Id as intestid,	testDiagnosis.DGId as intestdgid,	testDiagnosis.TestId,	testDiagnosis.SubGroupId,	testDiagnosis.IsDifferentialCount,	testDiagnosis.SubDiagnosis,	
					testDiagnosis.IsActive,	testDiagnosis.IsSync as intestissync,	
					ran.Id as ranid,	ran.DGId,	ran.[Min],	ran.[Max],	ran.[Group],	ran.SubGroup,	ran.Date
					--into New_PatientTestRecordResult
					from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientTestRecord patrecord
			left join NRLBAN.Carelab_Ktm_104.dbo.tbl_TestResultForReport ttrfr on ttrfr.TestId=patrecord.Id
			--JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_Test_DiagnosisGroup InTest on patrecord.IndividualTestId=InTest.Id
			left JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_TestPanel_ProfileGroup testGroup ON patrecord.TestPanId=testGroup.Id
			left join NRLBAN.Carelab_Ktm_104.dbo.tbl_Panel_ProfileGroup tppg on tppg.Id = testGroup.PanId
			left JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_Test_DiagnosisGroup testDiagnosis ON testGroup.DGId=testDiagnosis.Id
			LEFT JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_NRLTests nTest on nTest.Id = testDiagnosis.TestId
			LEFT JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_RangeOfTests ran on ran.DGId=testDiagnosis.Id
			--JOIN  NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientTestRecordSync] RecSync ON  patrecord.Id = RecSync.Recordid and RecSync.IsCurrent=1
			where 1=1
			--and TestPanId <> 0
			--and nTest.Testname like '%stone%'

			--and patrecord.IsSync = 0
			--and RecSync.SyncStatus IN (1,3) 
		) as t

		--select * from NRLBAN.Carelab_Ktm_104.dbo.tbl_Panel_ProfileGroup tppg
		--select * from  NRLBAN.Carelab_Ktm_104.dbo.tbl_TestPanel_ProfileGroup testGroup
---------------------------------------------------------------------------------------------------

		--select top 1 * from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientTestRecord patrecord

		select top 1 * from Int_PatientReportDetails where _origPatId in (3)--,1921,2253,1566, 1427)   -- needed   0
		select top 1 * from New_PatientTestRecordResult where PatId=1427  -- 1
		select top 1 * from  PatientMaster   -- 2
		select top 1 * from SubTestMaster  -- 3
		select top 1 * from TestMaster -- 4

		select top 1 * from New_PatientTestRecordResult
		select top 10 * from NRLBAN.Carelab_Ktm_104.dbo.tbl_TestResultForReport ttrfr where len(ltrim(rtrim(Method)) ) > 0

-- loading new data into Int_PatientReportDetails_new table
-- select count(*) from Int_PatientReportDetails_New

insert into Int_PatientReportDetails_new
select --top 10
nptrr.PatId,
nptrr.PatId as _OrigPatId,
nptrr.ResultDate as ReportDate,
nptrr.intestdgid as DiagId, 
nptrr.intestdgid as _OrigDiagId, 
nptrr.TestId,
nptrr.TestId as _OrigTestId,
isnull(pmaster.Id,0) as PanelId,
isnull(pmaster._OrigPanelId,0) as _OrigPanelId,
nptrr.TestRange,
nptrr.IsExecutive,
nTest.TotalPrice as TestPrice,
nTest.Method as TestMethod,
nptrr.TestResult,
nptrr.SubTestId,
nptrr.SubTestId as _OrigSubTestId,	
subtest.SubTestName as SubTest,
subtest.SubTestRange,
subtest.SubTestUnits,
subtest.IsActive,
nptrr.Result as SubTestResult,
nptrr.patnote as Note,
pmaster.PanelName as PanelName,
nptrr.Method as SubMethod,
isnull(nptrr.intestdgid,pmaster.DiagnosisId) as D_Group,
isnull(nptrr.intestdgid,pmaster._OrigPanelId)  as GroupId,	
coalesce(dgroup.DiagnosisName,pmaster.PanelName,'') as GroupName,
nptrr.intestid as DigId,	
1 as rownum,	   
0 as IsSync,	   
0 as SyncStatus,
0 as TestRecordId,
0 as IsFactLoaded,
isnull(nptrr.IsHideOnPrint,0) as IsHideOnPrint, 
'2075-76' as fiscalyear
		from New_PatientTestRecordResult nptrr  -- 1
		LEFT JOIN dbo.PatientMaster pm on pm.MainPatID = nptrr.PatId   -- 2
		left join dbo.SubTestMaster subtest on subtest._SubTestIdOrig=nptrr.SubTestId  -- 3
		left join dbo.TestMaster nTest on nTest._TestIDOrig = nptrr.TestId  -- 4
		left join dbo.PanelMaster pmaster on nptrr._origpanelid = pmaster._OrigPanelId
		left join dbo.DiagnosisMaster dgroup on dgroup._DiagnosisIDOrig = nptrr.intestdgid
--where nTest.Testname not like 'Stone Analysis'
		
		 

		 select top 10 * from New_PatientTestRecordResult nptrr where Method is not null or ltrim(rtrim(Method)) <> ''
		 select * from PanelMaster
		

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



		select top 1 * from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientTestRecord patrecord where PatId=33

		select distinct _origPatId from Int_PatientReportDetails  -- 1921  2253   1566


		--select * into Int_PatientReportDetails_new from Int_PatientReportDetails where 1=1

		--select count(*) from Int_PatientReportDetails_new
		--truncate table Int_PatientReportDetails_new


		select top 1 * from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientTestRecord patrecord
		select top 1 * from NRLBAN.Carelab_Ktm_104.dbo.tbl_NRLTests T
		select top 1 * from NRLBAN.Carelab_Ktm_104.dbo.tbl_Test_DiagnosisGroup InTest
		select top 1 * from NRLBAN.Carelab_Ktm_104.dbo.tbl_TestPanel_ProfileGroup
		select top 1 * from NRLBAN.Carelab_Ktm_104.dbo.tbl_Panel_ProfileGroup tppg


		select count(*) as totcount
		from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientTestRecord patrecord
		left join NRLBAN.Carelab_Ktm_104.dbo.tbl_TestResultForReport ttrfr on ttrfr.TestId=patrecord.Id
		JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_Test_DiagnosisGroup InTest on patrecord.IndividualTestId=InTest.Id
		LEFT JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_NRLTests nTest on nTest.Id = InTest.TestId
		LEFT JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_RangeOfTests ran on ran.DGId=Intest.Id
		--JOIN  NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientTestRecordSync] RecSync ON  patrecord.Id = RecSync.Recordid and RecSync.IsCurrent=1
		where 1=1
		and nTest.Testname not like 'Stone Analysis'    -- 251777


		select count(*) as totcnt
		from  NRLBAN.Carelab_Ktm_104.pat.tbl_PatientTestRecord patrecord
		left join NRLBAN.Carelab_Ktm_104.dbo.tbl_TestResultForReport ttrfr on ttrfr.TestId=patrecord.Id
		--JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_Test_DiagnosisGroup InTest on patrecord.IndividualTestId=InTest.Id
		left JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_TestPanel_ProfileGroup testGroup ON patrecord.TestPanId=testGroup.Id
		left join NRLBAN.Carelab_Ktm_104.dbo.tbl_Panel_ProfileGroup tppg on tppg.Id = testGroup.PanId
		left JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_Test_DiagnosisGroup testDiagnosis ON testGroup.DGId=testDiagnosis.Id
		LEFT JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_NRLTests nTest on nTest.Id = testDiagnosis.TestId
		--LEFT JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_RangeOfTests ran on ran.DGId=Intest.Id
		--JOIN  NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientTestRecordSync] RecSync ON  patrecord.Id = RecSync.Recordid and RecSync.IsCurrent=1
		where 1=1     -- 864717



		select * from RequestorMaster