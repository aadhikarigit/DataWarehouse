USE [Stag_Carelab_Ban]
GO

/****** Object:  StoredProcedure [Sync].[syncFactBranchPatientHistoRecords]    Script Date: 7/13/2019 11:14:50 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SELECT COUNT(*) FROM dbo.FactPatientHistoRecords

--NRLBAN.Carelab_Ktm_104.
-- EXEC sync.syncFactPatientHistoRecords


CREATE PROC [Sync].[syncFactBranchPatientHistoRecords]
	@fiscalyear varchar(10) = '2075-76'
as
begin
	create table #tempfactHistopatient(PatId INT DEFAULT 0 );

	Insert into #tempfactHistopatient
	select distinct phd.PatId from dbo.Int_BranchPatientHistoDetails phd;

	Merge dbo.FactBranchPatientHistoRecords as target
	using (select distinct 
		iphd.ID as IntPatientId
		,iphd.PatHistoRecId as PatHistRecId
		,pm.ID as PatientID
		,pm.MainPatID as _OrigPatientID
		,iphd.ResultId
		,iphd.TestTitle
		,iphd.TestParent
		,iphd.Result
		,iphd.HistoTestId
		,iphd.HistoTestName
		,iphd.HistoTestTypeId
		,iphd.HistoType
		,iphd.IsFinished
		,iphd.IsTaken
		,iphd.ReportTakenBy
		,iphd.CheckedBy
		,iphd.Designation
		,iphd.Reg_No
		,iphd.Nrl_Reg_No
		,iphd.HistoCode
		,iphd.InvoiceNumber
		,iphd.ResultDate
		,iphd.CheckedById
		,iphd.CheckedBySecond
		,iphd.HistoNote
		,iphd.IsHistoRecord
		,getdate() as CreateTs
		,getdate() as UpdateTs
		,iphd.SyncStatus
		from dbo.Int_BranchPatientHistoDetails iphd
		left join dbo.BranchPatientMaster pm on pm.MainPatID=iphd.PatId
		where iphd.IsSync = 0 and iphd.IsFactLoaded = 0

		) as source
	on  target._OrigPatientID      = source._OrigPatientID
		and target.ResultId        = source.ResultId
		and target.fiscalyear = @fiscalyear

	when matched 
	THEN
	UPDATE
	SET
	 target.IntPatientId	   = source.IntPatientId
	,target.PatHistRecId       = source.PatHistRecId
	,target.PatientID          = source.PatientID
	,target.TestTitle          = source.TestTitle
	,target.TestParent         = source.TestParent
	,target.Result             = source.Result
	,target.HistoTestId        = source.HistoTestId
	,target.HistoTestName      = source.HistoTestName
	,target.HistoTestTypeId    = source.HistoTestTypeId
	,target.HistoType          = source.HistoType
	,target.IsFinished         = source.IsFinished
	,target.IsTaken            = source.IsTaken
	,target.ReportTakenBy      = source.ReportTakenBy
	,target.CheckedBy          = source.CheckedBy
	,target.Designation        = source.Designation
	,target.Reg_No             = source.Reg_No
	,target.Nrl_Reg_No         = source.Nrl_Reg_No
	,target.HistoCode          = source.HistoCode
	,target.InvoiceNumber      = source.InvoiceNumber
	,target.ResultDate         = source.ResultDate
	,target.CheckedById        = source.CheckedById
	,target.CheckedBySecond    = source.CheckedBySecond
	,target.HistoNote          = source.HistoNote
	,target.IsHistoRecord      = source.IsHistoRecord
	,target.IsSync			   = 0
	,target.CreateTs           = source.CreateTs
	,target.UpdateTs           = getdate()
	,target.SyncStatus		   = source.SyncStatus
	
	when not matched then
	insert --into FactBranchPatientHistoRecords
	(IntPatientId,PatHistRecId,PatientID,_OrigPatientID,ResultId,TestTitle,TestParent,Result,HistoTestId,HistoTestName,HistoTestTypeId,
	HistoType,IsFinished,IsTaken,ReportTakenBy,CheckedBy,Designation,Reg_No,Nrl_Reg_No,HistoCode,InvoiceNumber,ResultDate,CheckedById,
	CheckedBySecond,HistoNote,IsHistoRecord,CreateTs,UpdateTs,SyncStatus,IsSync,fiscalyear)
	values(source.IntPatientId
		   ,source.PatHistRecId
		   ,source.PatientID
		   ,source._OrigPatientID
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
		   --,0
		   ,getdate()
		   ,getdate()
		   ,source.SyncStatus
		   ,0
		   ,@fiscalyear
		   );

		   update dbo.Int_PatientHistoDetails
		   set IsFactLoaded = 1
		   Where PatID in (Select PatId from #tempfactHistopatient);

		   drop table #tempfactHistopatient;
end
GO


