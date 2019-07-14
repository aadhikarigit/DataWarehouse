USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[syncBillMaster]    Script Date: 7/11/2019 6:31:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[NRLBAN].[Carelab_CloudSyncTest].
--EXEC Sync.syncBillMaster
-- select * from dbo.BillMaster
ALTER proc [Sync].[syncBillMaster]
	@fiscalyear varchar(10) = '2075-76'
as
begin

	SELECT DISTINCT PatId INTO #ReportPatient 
	FROM NRLBAN.Carelab_Ktm_104.pat.tbl_PatientTestRecord where IsSync=0 order by 1;

	Merge dbo.BillMaster as target
	using
	(
		select distinct tpb.BillNo as BillNo
		,tpb.PatId as _PatientId
		,tpb.BillDate as BillDate
		,isnull(tpb.Price,0) as BillPrice
		,isnull(tpb.BillDiscountAmt,0) as BillDiscount
		,isnull(tpb.BillHstAmt,0) as BillHSTAmount
		,isnull(tpb.TotalPrice,0) as BillTotal
		,isnull(tpb.BillAmtPaid,0) as BillPaid
		,isnull(tpb.BillRemainingAmt,0) as BillBalance
		,case when isnull(tpb.BillOutGngAmt,0) > 0 then 1 else 0 end as IsOutGoing
		,tpb.BillPaymentType as BillPaymentType
		,isnull(tpb.BillOutGngAmtPc,0) as BillOutgoingAmt
		,isnull(tpb.BillOutGngDiscountAmt,0) as BillOutgoingDiscAmt
		,isnull(tpb.BillOutGngAmtPc,0) as BillOutgoingPct
		,tpb.BillIsVoid as BillVoid
		,tau.usrFullName as BillCreatedBy
		,mtau.usrFullName as BillModifiedBy
		,tpb.BillLastModifiedDate as BillModifiedDate
		,getdate() as CreateTs
		,getdate() as UpdateTs
		from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientBill tpb
		join NRLBAN.Carelab_Ktm_104.dbo.tbl_appUsers tau on tpb.UserId = tau.usruserid  -- bills creating user
		join NRLBAN.Carelab_Ktm_104.dbo.tbl_appUsers mtau on tpb.UserId=mtau.usruserid
		where 1=1 --tpb.BillNo not in (  'LUE0003215'  ,'LUE0028366'  ,'LUE0080548'  ,'LUE0046025'  ,'LUE0023542'  )
		and tpb.Issync = 0 --and tpb.PatId in (select PatId from #ReportPatient)
	) as source
	on target.BillNo = source.BillNo 
	and target._PatientId  = source._PatientId
	and target.fiscalyear = @fiscalyear
	when matched 
	--and 
	--( 
	--	 target.BillDate            <> source.BillDate
	--	OR target.BillPrice           <> source.BillPrice
	--	OR target.BillDiscount        <> source.BillDiscount
	--	OR target.BillHSTAmount       <> source.BillHSTAmount
	--	OR target.BillTotal           <> source.BillTotal
	--	OR target.BillPaid            <> source.BillPaid
	--	OR target.BillBalance         <> source.BillBalance
	--	OR target.IsOutGoing          <> source.IsOutGoing
	--	OR target.BillPaymentType     <> source.BillPaymentType
	--	OR target.BillOutgoingAmt     <> source.BillOutgoingAmt
	--	OR target.BillOutgoingDiscAmt <> source.BillOutgoingDiscAmt
	--	OR target.BillOutgoingPct     <> source.BillOutgoingPct
	--	OR target.BillVoid            <> source.BillVoid
	--	OR target.BillCreatedBy       <> source.BillCreatedBy
	--	OR target.BillModifiedBy      <> source.BillModifiedBy
	--	OR target.BillModifiedDate    <> source.BillModifiedDate
	--	OR target.CreateTs            <> source.CreateTs
	--	--OR target.UpdateTs            <> source.UpdateTs
	--)
	then
	update 
	set  -- target.BillNo              = source.BillNo
		 --,target._PatientId          = source._PatientId
		  target.BillDate            = source.BillDate
		 ,target.BillPrice           = source.BillPrice
		 ,target.BillDiscount        = source.BillDiscount
		 ,target.BillHSTAmount       = source.BillHSTAmount
		 ,target.BillTotal           = source.BillTotal
		 ,target.BillPaid            = source.BillPaid
		 ,target.BillBalance         = source.BillBalance
		 ,target.IsOutGoing          = source.IsOutGoing
		 ,target.BillPaymentType     = source.BillPaymentType
		 ,target.BillOutgoingAmt     = source.BillOutgoingAmt
		 ,target.BillOutgoingDiscAmt = source.BillOutgoingDiscAmt
		 ,target.BillOutgoingPct     = source.BillOutgoingPct
		 ,target.BillVoid            = source.BillVoid
		 ,target.BillCreatedBy       = source.BillCreatedBy
		 ,target.BillModifiedBy      = source.BillModifiedBy
		 ,target.BillModifiedDate    = source.BillModifiedDate
		 --,target.CreateTs            = source.CreateTs
		 ,target.UpdateTs            = source.UpdateTs
		 ,target.IsSync				 = 0

	when not matched then
	insert 
	values(
			source.BillNo
		   ,source._PatientId
		   ,source.BillDate
		   ,source.BillPrice
		   ,source.BillDiscount
		   ,source.BillHSTAmount
		   ,source.BillTotal
		   ,source.BillPaid
		   ,source.BillBalance
		   ,source.IsOutGoing
		   ,source.BillPaymentType
		   ,source.BillOutgoingAmt
		   ,source.BillOutgoingDiscAmt
		   ,source.BillOutgoingPct
		   ,source.BillVoid
		   ,source.BillCreatedBy
		   ,source.BillModifiedBy
		   ,source.BillModifiedDate
		   ,0
		   ,source.CreateTs
		   ,source.UpdateTs
		   ,@fiscalyear
		  );

		  DROP TABLE #ReportPatient;
end



--select count(*) from BillMaster_Ban
