USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[syncBillLoginMaster]    Script Date: 7/11/2019 6:37:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--NRLBAN.Carelab_ktm_CloudSyncTest.
--EXEC Sync.syncBillLoginMaster


ALTER proc [Sync].[syncBillLoginMaster]
	@fiscalyear varchar(10) = '2075-76'
as
begin

	
	Merge dbo.BillLoginMaster as target
	using (
			SELECT 
			 pat.Id AS _PatientID
			,bill.BillNo AS BillLogin
			,bill.BillPassword AS BillPassword
			,1 AS ClientID
			,1 AS IsActive
			,0 AS IsMemberMapped
			,1 AS IsDocSharable
			,GETDATE() AS CreateTs
			,GETDATE() AS UpdateTs
			FROM NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientBill] bill
			LEFT JOIN NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientInfo] pat ON pat.id = bill.patid
			WHERE 1=1 
			and pat.Issync = 0
			--MemberCode <> '' AND MemberCode <> 'N'-- AND ContactNo <> ''
			--order by _PatientID
	) as source
	on target._PatientId = source._PatientId 
	--and target.ClientId = source.ClientId 
	and target.BillLogin = source.BillLogin
	and target.fiscalyear = @fiscalyear

	 when matched and
	 (
		target.BillPassword <> source.BillPassword
		OR target.IsActive <> source.IsActive
		OR target.IsMemberMapped <> source.IsMemberMapped
		OR target.IsDocSharable <> source.IsDocSharable
	 )
	 then
	update
	set --target.BillLogin = source.BillLogin
	target.BillPassword = source.BillPassword
	,target.IsActive = source.IsActive
	,target.IsMemberMapped = source.IsMemberMapped
	,target.IsDocSharable = source.IsDocSharable
	,target.UpdateTS = getdate()
	,target.Issync = 0
	

	-- when matched

	when not matched then
	insert (_PatientID,BillLogin,BillPassword,ClientID,IsActive,IsMemberMapped,IsDocSharable,CreateTs,UpdateTs,fiscalyear)
	values(
		source._PatientId
		,source.BillLogin
		,source.BillPassword
		,source.ClientID
		,source.IsActive
		,source.IsMemberMapped
		,source.IsDocSharable
		,source.CreateTs
		,source.UpdateTs
		,@fiscalyear
	);

		--when not matched by source then
		--delete ;
end


--select top 1 * from [NRLBAN].[Carelab_CloudSyncTest].[pat].[tbl_PatientBill]

--select * from DataWareHouse.dbo.LoginInfo_Ban

--select top 1 * from [NRLBAN].[Carelab_CloudSyncTest].[pat].[tbl_PatientBill]
--select top 1 * from [NRLBAN].[Carelab_CloudSyncTest].[pat].[tbl_PatientInfo]
