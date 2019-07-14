USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[syncInt_PatientHistoDetails]    Script Date: 7/11/2019 6:54:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--NRLBAN.Carelab_Ktm_104.

--select * from #tempHisto

--exec sync.syncInt_PatientHistoDetails

ALTER proc [Sync].[syncInt_PatientHistoDetails]
	@fiscalyear varchar(10) = '2075-76'
as
begin
	Merge dbo.Int_PatientHistoDetails as target
	using (
	select distinct *
	--into #tempHisto
	from
	(
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
		from dbo.PatientHistoMaster record
		join NRLBAN.Carelab_Ktm_104.pat.tbl_PatientHistoReport report on report.PatHistoId = record.HistoRecordId
		JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_HistoReportTypeLookUp look on look.Id=report.HistoReportId 
		JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_NRLHistoTests test on test.Id=record.HistoTestId
		JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_HistoTestType htype on htype.Id=look.HistoId
		JOIN dbo.MasterSpecialist chk on chk._SpecialistIdOrig=record.CheckedByFirstId and chk.IsReferrer=0
		JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_NrlNumberGenerator gen on gen.UserId=record._OrigPatId
		JOIN  NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientHistoSync] RecSync ON  record.HistoRecordId = RecSync.Recordid
		where IsFinished=1
		and report.IsSync = 0
		and RecSync.SyncStatus IN (1,3)
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
			from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientHistoRecord p 
			  JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_NRLHistoTests nhisto ON nhisto.Id=p.HistoTestId
			  JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_HistoReportTypeLookUp look  ON p.HistoTestTypeId=look.HistoId
			  JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_HistoTestType htype on htype.Id=look.HistoId  	  
			  LEFT JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_PatTestCheckedBy chk on chk.Id=p.CheckedBy
			  JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_NrlNumberGenerator gen on gen.UserId=p.PatId
			  JOIN  NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientHistoSync] RecSync ON  p.Id = RecSync.Recordid
			  where IsFinished=0
			  and p.IsSync = 0
			  and RecSync.SyncStatus IN (1,3)
		--order by p.Id
		) as t
		--order by t.PatHistoRecId
	
	
	) as source
	on target.PatId = source.PatId and target.Resultid = source.Resultid
	and target.fiscalyear = @fiscalyear
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
			,@fiscalyear
	);
end
