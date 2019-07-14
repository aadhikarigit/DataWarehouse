select * from TestMaster;

select _TestIDOrig, TestCode,fiscalyear, count(*) as totcount from TestMaster tm group by _TestIDOrig,TestCode,fiscalyear having count(*) > 1

select 
			--tphr.Id as HistoRecordId
			--,
			tphr.PatId as _OrigPatId
			,tphr.HistoTestId
			,count(*) as totalcnt
			--,tphr.CheckedBy as CheckedByFirstId
			--,isnull(ms.Name,'') as CheckedByFirstName
			--,isnull(ms.Designation,'') as CheckedByFirstDesignation
			--,case when (ms.NHPCRegID is null or ms.NHPCRegID='') and (ms.NMCRegID is null or ms.NMCRegID='') then isnull(ms.OtherReg,'')
			--  when (ms.NHPCRegID is null or ms.NHPCRegID='') and (ms.OtherReg is null or ms.OtherReg='') then isnull(ms.NMCRegID,'')
			--  when (ms.NMCRegID is null or ms.NMCRegID='') and (ms.OtherReg is null or ms.OtherReg='') then isnull(ms.NHPCRegID,'')
			-- end as CheckedByFirstRegNo
			--,tphr.CheckedBySecond as CheckedBySecondId
			--,isnull(ms2.Name,'') as CheckedBySecondName
			--,isnull(ms2.Designation,'') as CheckedBySecondDesignation
			--,case when (ms2.NHPCRegID is null or ms2.NHPCRegID='') and (ms2.NMCRegID is null or ms2.NMCRegID='') then isnull(ms2.OtherReg,'')
			--  when (ms2.NHPCRegID is null or ms2.NHPCRegID='') and (ms2.OtherReg is null or ms2.OtherReg='') then isnull(ms2.NMCRegID,'')
			--  when (ms2.NMCRegID is null or ms2.NMCRegID='') and (ms2.OtherReg is null or ms2.OtherReg='') then isnull(ms2.NHPCRegID,'')
			-- end as CheckedBySecondRegNo
			--,convert(varchar(10),tphr.ReportDate,105) as ReportDate
			--,tphr.IsFinished
			--,tphr.HistoTestTypeId
			--,thtt.HistoType as HistoTestType
			--,tphr.IsTaken
			--,tphr.UserId
			--,tau.usrFullName as UserName
			--,tphr.ReportTakenBy
			--,isnull(tphr.HistoCode,'') as HistoCode
			--,isnull(tphr.ResultDate,convert(datetime,'')) as ResultDate
			--,tphr.ReportNepaliDate
			--,isnull(tphr.Note,'') as Note
			--,getdate() as CreateTs
			--,getdate() as UpdateTs
			--,fiscalyear
			from NRLBAN.Carelab_Ktm_104.branch.tbl_BranchPatientHistoRecord tphr
			left join dbo.MasterSpecialist ms on ms._SpecialistIdOrig=tphr.CheckedBy and ms.IsReferrer=0
			left join  dbo.MasterSpecialist ms2 on ms2._SpecialistIdOrig=tphr.CheckedBySecond and ms2.IsReferrer=0
			left join NRLBAN.Carelab_Ktm_104.dbo.tbl_HistoTestType thtt on thtt.Id=tphr.HistoTestTypeId
			left join NRLBAN.Carelab_Ktm_104.dbo.tbl_appUsers tau on tau.usruserid=tphr.UserId
			where tphr.Issync = 0
			group by tphr.PatId, tphr.HistoTestId
			having count(*) > 1


			0
575

select * from NRLBAN.Carelab_Ktm_104.branch.tbl_BranchPatientHistoRecord tphr where PatId in (0,575)

---------------------------------------------------------
-- Int_BranchPatientHistoMaster

select top 50 * from BranchPatientHistoMaster
select * from  NRLBAN.Carelab_Ktm_104.branch.tbl_BranchPatientHistoReport report where PatHistoId =2
select * from FactPatientHistoRecords where _OrigPatientID = 129

select * from BranchPatientHistoMaster record
join NRLBAN.Carelab_Ktm_104.branch.tbl_BranchPatientHistoReport report on report.PatHistoId = record.HistoRecordId

select top 2 * from NRLBAN.Carelab_Ktm_104.branch.tbl_BranchPatientHistoRecord tphr
select top 2 *  from NRLBAN.Carelab_Ktm_104.branch.tbl_BranchPatientHistoReport report 
select top 2 * from NRLBAN.Carelab_Ktm_104.dbo.tbl_NRLHistoTests test

select distinct PatId,BillNo 
into tempdb..#temppatientbill
from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientBill bm order by 1,2

-------------Script for Int_BranchPatientHistoDetails-------------------------------

select record._OrigPatId as PatId
		,record.HistoRecordId as PatHistoRecId
		,look.Id as ResultId
		,look.TestTitle
		,look.TestParent
		,report.Result
		,record.HistoTestId
		,test.HistoTestName
		,record.HistoTestTypeId
		,htype.HistoType
		,record.IsFinished
		,record.IsTaken
		,record.ReportTakenBy
		,record.CheckedByFirstName as CheckedBy
		,record.CheckedByFirstDesignation as Designation
		,record.CheckedByFirstRegNo as Reg_No
		,record._OrigPatId as Nrl_Reg_No
		,isnull(record.HistoCode,'') as HistoCode
		,gen.InvoiceNumber
		,DATENAME(MM,record.ResultDate)+RIGHT(Convert(Varchar(12),record.ResultDate,107),9)+'<br>'+convert(varchar,record.ReportNepaliDate) +' BS' as ResultDate
		--,convert(varchar,record.ReportNepaliDate) + 'BS' as ResultDate
		,isnull(record.CheckedByFirstId,'') as CheckedById
		,isnull(record.CheckedBySecondId,'') as CheckedBySecond
		,isnull(record.Note,'') as HistoNote
		,case when IsFinished=1 then 1 else 0 end as IsHistoRecord
		,getdate() as CreateTs
		,getdate() as UpdateTs
		,CASE WHEN RecSync.SyncStatus <> 1 THEN 0
		 ELSE 1 END AS SyncStatus
from NRLBAN.Carelab_Ktm_104.branch.tbl_BranchPatientHistoRecord tphr
		join NRLBAN.Carelab_Ktm_104.branch.tbl_BranchPatientHistoReport report on report.PatHistoId = tphr.Id
		JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_NRLHistoTests test on test.Id=tphr.HistoTestId
		JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_HistoReportTypeLookUp look on look.Id=report.HistoReportId 
		JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_HistoTestType htype on htype.Id=look.HistoId
		JOIN #temppatientbill tpb on tpb.PatId = tphr.PatId
		JOIN dbo.MasterSpecialist chk on chk._SpecialistIdOrig=tphr.CheckedBy and chk.IsReferrer=0
		--JOIN  NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientHistoSync] RecSync ON  tphr.HistoRecordId = RecSync.Recordid
		where IsFinished=1
		--and tphr.IsSync = 0
		--and RecSync.SyncStatus IN (1,3)
		--order by record.Id

		union
		select 
			p.PatId
			,p.Id as PatHistoRecId
			,look.Id as 'ResultId'
			,look.TestTitle,
			look.TestParent,
			look.DefaultResult As 'Result'
			,p.HistoTestId,
			nhisto.HistoTestName,
			p.HistoTestTypeId,
			htype.HistoType,
			p.IsFinished,
			p.IsTaken,
			p.ReportTakenBy,
			Isnull(chk.Name,'') as 'CheckedBy',
			isnull(chk.Designation,'') as 'Designation',
			isnull(chk.Reg_No,'') as 'Reg_No',
			p.Nrl_Reg_No,
			isnull(p.HistoCode,'') as 'HistoCode',
			gen.InvoiceNumber as 'InvoiceNumber',
			convert(varchar, getdate(), 101) as 'ResultDate',
			0 as 'CheckedById', 0 as 'CheckedBySecond'
			,isnull(nhisto.HistoNote,'') as 'HistoNote'
			,case when IsFinished=1 then 1 else 0 end as IsHistoRecord
			,getdate() as CreateTs
			,getdate() as UpdateTs
			,CASE WHEN RecSync.SyncStatus <> 1 THEN 0
				ELSE 1 END AS SyncStatus
			from NRLBAN.Carelab_Ktm_104.branch.tbl_BranchPatientHistoRecord p 
			  JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_NRLHistoTests nhisto ON nhisto.Id=p.HistoTestId
			  JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_HistoReportTypeLookUp look  ON p.HistoTestTypeId=look.HistoId
			  JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_HistoTestType htype on htype.Id=look.HistoId  	  
			  LEFT JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_PatTestCheckedBy chk on chk.Id=p.CheckedBy
			  --JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_NrlNumberGenerator gen on gen.UserId=p.PatId
			  JOIN #temppatientbill tpb on tpb.PatId = p.PatId
			  JOIN  NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientHistoSync] RecSync ON  p.Id = RecSync.Recordid
			  where IsFinished=0
			  --and p.IsSync = 0
			  --and RecSync.SyncStatus IN (1,3)
		--order by p.Id


--from dbo.BranchPatientHistoMaster record
--		join NRLBAN.Carelab_Ktm_104.branch.tbl_BranchPatientHistoReport report on report.PatHistoId = record.HistoRecordId
--		JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_HistoReportTypeLookUp look on look.Id=report.HistoReportId 
--		JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_NRLHistoTests test on test.Id=record.HistoTestId
--		JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_HistoTestType htype on htype.Id=look.HistoId
--		JOIN dbo.MasterSpecialist chk on chk._SpecialistIdOrig=record.CheckedByFirstId and chk.IsReferrer=0
--		JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_NrlNumberGenerator gen on gen.UserId=record._OrigPatId
--		JOIN  NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientHistoSync] RecSync ON  record.HistoRecordId = RecSync.Recordid


select top 1 * from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientBill bm

select count(*) from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientBill bm
select distinct PatId, BillNo from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientBill bm

-- Add IsFactLoaded column in the table Int_BranchPatientHistoDetails

Alter table Int_BranchPatientHistoDetails add IsFactLoaded bit default 0