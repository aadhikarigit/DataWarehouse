USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[syncLoginMaster]    Script Date: 7/11/2019 6:39:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from dbo.LoginMaster
--exec Sync.syncLoginMaster

ALTER proc [Sync].[syncLoginMaster]
	@fiscalyear varchar(10) = '2075-76'
as
begin

	Merge dbo.LoginMaster as target
	using (
			SELECT DISTINCT
		  'MEMBER' AS LoginType
		, tm.MemberCode AS LoginTypeID
		, tm.MemberCode+ 'LOG' AS LoginID
		, tm.MemberCode + 'pwd' AS LoginPw
		, getdate() AS CreateTs
		, getdate() AS UpdateTS
		, 1 AS IsActive
		,0 as UserRole
		,tm.Id as _OrigId
		,1 as ClientId
		,1 as UserType
		,0 as ReferrerId
		FROM [dbo].[MemberMaster] mm
		join NRLBAN.Carelab_Ktm_104.dbo.tbl_MemberShip tm on tm.MemberCode=mm.MemberCode
		--WHERE mm.Issync = 0

		UNION

		select DISTINCT 'STAFF' as LoginType
		,tau.usrusername as LoginTypeId
		,tau.usrusername as LoginID
		,tau.usrpassword as LoginPw
		,getdate() as CreateTs
		,getdate() as UpdateTS
		,1 as IsActive
		,tau.usrrole as UserRole
		,tau.usruserid as _OrigId
		,1 as ClientId
		,tau.usrUserType as UserType
		,tau.usrReferrerId as ReferrerId
		from NRLBAN.Carelab_Ktm_104.dbo.tbl_appUsers tau
		where tau.Issync = 0 
	) as source
	on	target._OrigId		= source._OrigId
		and target.ClientId = source.ClientId 
		and target.LoginType = source.LoginType
		and target.LoginID = source.LoginID
		and target.LoginTypeID = source.LoginTypeID
		and target.fiscalyear = @fiscalyear
		

	 when matched and Target.UserType <> 2 
	-- and -- added logic to filter User Type 2 from updating
	--(	  -- target.LoginID  <> source.LoginID
	--	target.LoginPw  <> source.LoginPw
	--	OR target.IsActive <> source.IsActive
	--	OR target.UserRole <> source.UserRole
	--	--OR target.ClientId <> source.ClientId
	-- )
	then
	update
	set 
	 
	 --target.LoginID = source.LoginID
		target.LoginPw = source.LoginPw
	,target.UpdateTS = getdate()
	,target.IsActive = source.IsActive
	,target.UserRole = source.UserRole
	,target.Issync = 0
	,target.UserType = source.UserType
	,target.ReferrerId = source.ReferrerId
	--,target.ClientId = source.ClientId
	

	-- when matched

	when not matched then
	insert 
	values(
		source.LoginType
		,source.LoginTypeID
		,source.LoginID
		,source.LoginPw
		,source.CreateTs
		,source.UpdateTS
		,source.IsActive
		,source.UserRole
		,source._OrigId
		,source.ClientId
		,0
		,source.UserType
		,source.ReferrerId
		,@fiscalyear
	);

		--when not matched by source then
		--delete ;
end
