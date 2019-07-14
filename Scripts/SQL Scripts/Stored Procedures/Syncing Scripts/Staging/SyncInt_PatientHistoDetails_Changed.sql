-- Script for 

ALTER proc [Sync].[syncInt_PatientHistoDetails]
as
begin
	Merge dbo.Int_PatientHistoDetails as target
	using (
	select distinct *
	--into #tempHisto
	from
	(
		select record.PatId as PatId
		,record.Id as PatHistoRecId
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
		,chk.Name as CheckedBy
		,chk.Designation
		,chk.Reg_No
		,record.PatId as Nrl_Reg_No
		,isnull(record.HistoCode,'') as HistoCode
		,tpb.BillNo as InvoiceNumber--,gen.InvoiceNumber  -- take billno from bill table
		,DATENAME(MM,record.ResultDate)+RIGHT(Convert(Varchar(12),record.ResultDate,107),9)+'<br>'+convert(varchar,record.ReportNepaliDate) +' BS' as ResultDate
		--,convert(varchar,record.ReportNepaliDate) + 'BS' as ResultDate
		,isnull(record.CheckedBy,'') as CheckedById
		,isnull(record.CheckedBySecond,'') as CheckedBySecond
		,isnull(record.Note,'') as HistoNote
		,case when IsFinished=1 then 1 else 0 end as IsHistoRecord
		,getdate() as CreateTs
		,getdate() as UpdateTs
		,CASE WHEN RecSync.SyncStatus <> 1 THEN 0
		 ELSE 1 END AS SyncStatus
		from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientHistoRecord record
		join NRLBAN.Carelab_Ktm_104.pat.tbl_PatientHistoReport report on report.PatHistoId = record.Id
		JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_HistoReportTypeLookUp look on look.Id=report.HistoReportId 
		JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_NRLHistoTests test on test.Id=record.HistoTestId
		JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_HistoTestType htype on htype.Id=look.HistoId
		JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_PatTestCheckedBy chk on chk.Id = record.CheckedBy
		JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_PatTestCheckedBy chk2 on chk2.Id = record.CheckedBySecond
		JOIN NRLBAN.Carelab_Ktm_104.pat.tbl_PatientBill tpb on tpb.PatId=record.PatId
		JOIN  NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientHistoSync] RecSync ON  record.Id = RecSync.Recordid
		where IsFinished=1
		and report.IsSync = 0
		and RecSync.SyncStatus IN (1,3)

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
			tpb.BillNo as InvoiceNumber--gen.InvoiceNumber as 'InvoiceNumber',  -- same as above here, i.e. bill number from bill table
			,convert(varchar, getdate(), 101) as 'ResultDate',
			0 as 'CheckedById', 0 as 'CheckedBySecond'
			,isnull(nhisto.HistoNote,'') as 'HistoNote'
			,case when IsFinished=1 then 1 else 0 end as IsHistoRecord
			,getdate() as CreateTs
			,getdate() as UpdateTs
			,CASE WHEN RecSync.SyncStatus <> 1 THEN 0
				ELSE 1 END AS SyncStatus
			from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientHistoRecord p 
			  JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_NRLHistoTests nhisto ON nhisto.Id=p.HistoTestId
			  JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_HistoReportTypeLookUp look  ON p.HistoTestTypeId=look.HistoId
			  JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_HistoTestType htype on htype.Id=look.HistoId  	  
			  LEFT JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_PatTestCheckedBy chk on chk.Id=p.CheckedBy
			  --JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_NrlNumberGenerator gen on gen.UserId=p.PatId
			  JOIN NRLBAN.Carelab_Ktm_104.pat.tbl_PatientBill tpb on tpb.PatId=p.PatId
			  JOIN  NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientHistoSync] RecSync ON  p.Id = RecSync.Recordid
			  where IsFinished=0
			  and p.IsSync = 0
			  and RecSync.SyncStatus IN (1,3)
		--order by p.Id
		) as t
		--order by t.PatHistoRecId
	
	
	) as source
	on target.PatId = source.PatId 
	and target.Resultid = source.Resultid 
	--and target.PatHistoRecId=source.PatHistoRecId
	when matched
	 THEN UPDATE
	 SET
		 
		   target.PatHistoRecId    = source.PatHistoRecId
		 , target.TestTitle        = source.TestTitle
		 , target.TestParent       = source.TestParent
		 , target.Result           = source.Result
		 , target.HistoTestId      = source.HistoTestId
		 , target.HistoTestName    = source.HistoTestName
		 , target.HistoTestTypeId  = source.HistoTestTypeId
		 , target.HistoType        = source.HistoType
		 , target.IsFinished       = source.IsFinished
		 , target.IsTaken          = source.IsTaken
		 , target.ReportTakenBy    = source.ReportTakenBy
		 , target.CheckedBy        = source.CheckedBy
		 , target.Designation      = source.Designation
		 , target.Reg_No           = source.Reg_No
		 , target.Nrl_Reg_No       = source.Nrl_Reg_No
		 , target.HistoCode        = source.HistoCode
		 , target.InvoiceNumber    = source.InvoiceNumber
		 , target.ResultDate       = source.ResultDate
		 , target.CheckedById      = source.CheckedById
		 , target.CheckedBySecond  = source.CheckedBySecond
		 , target.HistoNote        = source.HistoNote
		 , target.IsHistoRecord    = source.IsHistoRecord
		 , target.UpdateTs         = getdate()
		 , target.IsSync		   = 0
		 , target.SyncStatus	   =source.SyncStatus
		 , target.IsFactLoaded		= 0

	when not matched then
	insert
	values(	source.PatId
			,source.PatHistoRecId
			,source.ResultId
			,source.TestTitle
			,source.TestParent
			,source.Result
			,source.HistoTestId
			,source.HistoTestName
			,source.HistoTestTypeId
			,source.HistoType
			,source.IsFinished
			,source.IsTaken
			,source.ReportTakenBy
			,source.CheckedBy
			,source.Designation
			,source.Reg_No
			,source.Nrl_Reg_No
			,source.HistoCode
			,source.InvoiceNumber
			,source.ResultDate
			,source.CheckedById
			,source.CheckedBySecond
			,source.HistoNote
			,source.IsHistoRecord
			,0
			,getdate()
			,getdate()
			,source.SyncStatus
			,0
	);
end
