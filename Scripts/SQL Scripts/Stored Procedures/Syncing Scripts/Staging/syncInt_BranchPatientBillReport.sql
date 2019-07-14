USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[syncInt_BranchPatientBillReport]    Script Date: 7/12/2019 5:07:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [Sync].[syncInt_BranchPatientBillReport]
	@fiscalyear varchar(10) = '2075-76'
as
begin
IF OBJECT_ID('tempdb..#temppatientrec') IS NOT NULL     --Remove dbo here 
    DROP TABLE #temppatientrec  ;
	select distinct PatId,CheckedBy,CheckedBySecond,IstakenByPatient,IsReportDone,IspartiallyDone,convert(varchar(100),ResultDate,107) as ResultDate 
			into #temppatientrec   -- temporary table for temp patient records
			from  NRLBAN.Carelab_Ktm_104.branch.tbl_BranchPatientTestRecord
			--where isSync = 0 
			order by PatId;

	Merge dbo.Int_BranchPatientBillReport as target
	using (select --top 2
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
			from  NRLBAN.Carelab_Ktm_104.branch.tbl_BranchPatientBill tpb
			join dbo.BranchPatientMaster pm on pm.MainPatId=tpb.PatId
			left join dbo.RequestorMaster rm on rm.Id=pm.RequestorId
			left join dbo.BillMaster bm on bm._PatientId=tpb.PatId 
			left join  NRLBAN.Carelab_Ktm_104.dbo.tbl_appUsers tau on tau.usruserid=tpb.UserId
			join #temppatientrec as tptr on tptr.PatId=tpb.PatId
			left join dbo.MasterSpecialist ms on ms._SpecialistIdOrig=tptr.CheckedBy and ms.IsReferrer=0
			left join dbo.MasterSpecialist ms2 on ms2._SpecialistIdOrig=tptr.CheckedBySecond and ms2.IsReferrer=0
		) as source
	on		target._OrigPatId = source._OrigPatId
		and target._OrigBillId = source._OrigBillId
		and target.BillNo = source.BillNo
		and target.fiscalyear = @fiscalyear

	 when matched 
	  then
	update
	set
	 target.BillDate		= source.BillDate
	,target.ReportDate		= source.ReportDate
	,target.EnteredBy		= source.EnteredBy
	,target.SpecialistId	= source.SpecialistId
	,target.SecondSpecialistId = source.SecondSpecialistId
	,target.IsReportTaken	= source.IsReportTaken
	,target.IsDone			= source.IsDone
	,target.IsPartiallyDone = source.IsPartiallyDone
	,target.BillPriceFinal	= source.BillPriceFinal
	,target.RequestorId		= source.RequestorId
	,target.ResultDate		= source.ResultDate
	,target.IsSync			= 0
	
	-- when matched

	when not matched then
	insert (PatId,_OrigPatId,MemberCode,BillId,_OrigBillId,BillNo,BillDate,ReportDate,EnteredBy,SpecialistId,SecondSpecialistId,
	IsReportTaken,IsDone,IsPartiallyDone,BillPriceFinal,RequestorId,ResultDate,IsSync,fiscalyear)
	values(
		source.PatId
		,source._OrigPatId
		,source.MemberCode
		,source.BillId
		,source._OrigBillId
		,source.BillNo
		,source.BillDate
		,source.ReportDate
		,source.EnteredBy
		,source.SpecialistId
		,source.SecondSpecialistId
		,source.IsReportTaken
		,source.IsDone
		,source.IsPartiallyDone
		,source.BillPriceFinal
		,source.RequestorId
		,source.ResultDate
		,0
		,@fiscalyear
	);

		--when not matched by source then
		--delete ;
	IF OBJECT_ID('tempdb..#temppatientrec') IS NOT NULL     --Remove dbo here 
    DROP TABLE #temppatientrec;
END