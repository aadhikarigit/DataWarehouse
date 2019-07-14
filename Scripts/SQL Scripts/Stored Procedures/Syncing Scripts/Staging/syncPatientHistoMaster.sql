USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[syncPatientHistoMaster]    Script Date: 7/11/2019 6:34:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [Sync].[syncPatientHistoMaster]
	@fiscalyear varchar(10) = '2075-76'
as
begin

	
	Merge dbo.PatientHistoMaster as target
	using (
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
			and tphr.PatId not in 
			(56135,
101725,
39204,
16448)
	) as source
	on      target._OrigPatId = source._OrigPatId 
		and target.HistoTestId = source.HistoTestId
		and target.fiscalyear = @fiscalyear

	 when matched  and
	 (
		   
		   target.CheckedByFirstId <> source.CheckedByFirstId
		or target.CheckedByFirstName <> source.CheckedByFirstName
		or target.CheckedByFirstDesignation <> source.CheckedByFirstDesignation
		or target.CheckedBySecondId <> source.CheckedBySecondId
		or target.CheckedBySecondName <> source.CheckedBySecondName
		or target.CheckedBySecondDesignation <> source.CheckedBySecondDesignation
		or target.ReportDate <> source.ReportDate
		or target.IsFinished <> source.IsFinished
		or target.HistoTestTypeId <> source.HistoTestTypeId
		or target.HistoTestType <> source.HistoTestType
		or target.IsTaken <> source.IsTaken
		or target.UserId <> source.UserId
		or target.UserName <> source.UserName
		or target.ReportTakenBy <> source.ReportTakenBy
		or target.HistoCode <> source.HistoCode
		or target.ResultDate <> source.ResultDate
		or target.ReportNepaliDate <> source.ReportNepaliDate
		or target.Note <> source.Note
	) 
	 then
	update
	set target.HistoTestId = source.HistoTestId
	,target.CheckedByFirstId = source.CheckedByFirstId
	,target.CheckedByFirstName = source.CheckedByFirstName
	,target.CheckedByFirstDesignation = source.CheckedByFirstDesignation
	,target.CheckedBySecondId = source.CheckedBySecondId
	,target.CheckedBySecondName = source.CheckedBySecondName
	,target.CheckedBySecondDesignation = source.CheckedBySecondDesignation
	,target.ReportDate = source.ReportDate
	,target.IsFinished = source.IsFinished
	,target.HistoTestTypeId = source.HistoTestTypeId
	,target.HistoTestType = source.HistoTestType
	,target.IsTaken = source.IsTaken
	,target.UserId = source.UserId
	,target.UserName = source.UserName
	,target.ReportTakenBy = source.ReportTakenBy
	,target.HistoCode = source.HistoCode
	,target.ResultDate = source.ResultDate
	,target.ReportNepaliDate = source.ReportNepaliDate
	,target.Note = source.Note
	,target.UpdateTs = getdate()
	,target.Issync = 0

	-- when matched

	when not matched then
	insert 
	values(
		source.HistoRecordId
		,source._OrigPatId
		,source.HistoTestId
		,source.CheckedByFirstId
		,source.CheckedByFirstName
		,source.CheckedByFirstDesignation
		,source.CheckedByFirstRegNo
		,source.CheckedBySecondId
		,source.CheckedBySecondName
		,source.CheckedBySecondDesignation
		,source.CheckedBySecondRegNo
		,source.ReportDate
		,source.IsFinished
		,source.HistoTestTypeId
		,source.HistoTestType
		,source.IsTaken
		,source.UserId
		,source.UserName
		,source.ReportTakenBy
		,source.HistoCode
		,source.ResultDate
		,source.ReportNepaliDate
		,source.Note
		,0
		,getdate()
		,getdate()
		,@fiscalyear
	);

		--when not matched by source then
		--delete ;
end
