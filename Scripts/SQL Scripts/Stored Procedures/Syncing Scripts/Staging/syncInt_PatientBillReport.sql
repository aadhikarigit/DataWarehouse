USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[syncInt_PatientBillReport]    Script Date: 7/11/2019 5:04:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER proc [Sync].[syncInt_PatientBillReport]
	@fiscalyear varchar(10) = '2075-76'
as
begin

	IF OBJECT_ID('tempdb..#temppatientrec') IS NOT NULL     --Remove dbo here 
    DROP TABLE #temppatientrec  ;
	select distinct PatId
			into #temppatientrec   -- temporary table for temp patient records
			from  NRLBAN.Carelab_Ktm_104.pat.tbl_PatientTestRecord
			where isSync = 0 
			order by PatId;
	Merge dbo.Int_PatientBillReport as target
	using (
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
	) as source
	on		target._OrigPatId = source._OrigPatId
		and target.ClientId = source.ClientId
		and target.PatId = source.PatId
		--and target.MemberCode = source.MemberCode
		--and target.BillId = source._OrigBillId
		and target._OrigBillId = source._OrigBillId
		and target.BillNo = source.BillNo
		and target.fiscalyear = @fiscalyear

-- when matched

	 when matched 
	 --and
	 --(
		--   target.BillDate <> source.BillDate
		--OR target.ReportDate <> source.ReportDate
		--OR target.EnteredBy <> source.EnteredBy
		--OR target.SpecialistId <> source.SpecialistId
		--OR target.SecondSpecialistId <> source.SecondSpecialistId
		--OR target.IsReportTaken <> source.IsReportTaken
		--OR target.IsDone <> source.IsDone
		--OR target.IsPartiallyDone <> source.IsPartiallyDone
		--OR target.BillPriceFinal <> source.BillPriceFinal
		--OR target.RequestorId <> source.RequestorId
		--OR target.ResultDate <> source.ResultDate

	 --)
	 then
	update
	set
	 target.BillDate		= source.BillDate
	,target.ReportDate		= source.ReportDate
	,target.EnteredBy		= source.EnteredBy
	--,target.SpecialistId	= source.SpecialistId
	--,target.SecondSpecialistId = source.SecondSpecialistId
	--,target.IsReportTaken	= source.IsReportTaken
	--,target.IsDone			= source.IsDone
	--,target.IsPartiallyDone = source.IsPartiallyDone
	,target.BillPriceFinal	= source.BillPriceFinal
	,target.RequestorId		= source.RequestorId
	--,target.ResultDate		= source.ReportDate
	,target.IsSync			= 0
	,target.IsFactLoaded	= 0

	-- when matched

	when not matched then
	insert (ClientId,PatId,_OrigPatId,MemberCode,BillId,_OrigBillId,BillNo,BillDate,ReportDate,EnteredBy,SpecialistId,SecondSpecialistId,
	IsReportTaken,IsDone,IsPartiallyDone,BillPriceFinal,RequestorId,ResultDate,IsSync,IsFactLoaded,fiscalyear)
	values(
		source.ClientId
		,source.PatId
		,source._OrigPatId
		,''
		,source._OrigBillId
		,source._OrigBillId
		,source.BillNo
		,source.BillDate
		,source.ReportDate
		,source.EnteredBy
		,0
		,0
		,0
		,0
		,0
		,source.BillPriceFinal
		,source.RequestorId
		,source.ReportDate
		,0
		,0
		,@fiscalyear
	);

		--when not matched by source then
		--delete ;
	IF OBJECT_ID('tempdb..#temppatientrec') IS NOT NULL     --Remove dbo here 
    DROP TABLE #temppatientrec;

end
