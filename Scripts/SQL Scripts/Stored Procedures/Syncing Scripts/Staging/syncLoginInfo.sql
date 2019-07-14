USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[syncLoginInfo]    Script Date: 7/11/2019 6:42:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--exec Sync.syncLoginInfo

ALTER proc [Sync].[syncLoginInfo]
	@fiscalyear varchar(10) = '2075-76'
as
begin
	Merge dbo.LoginInfo as target
	using (
			select DISTINCT 'Patient' as LoginType
			,pinfo.Id as LoginID
			,Binfo.BillPassword LoginPw
			,getdate() as CreateTs
			,getdate() as UpdateTS
			,1 as IsActive
			from NRLBAN.Carelab_Ktm_104.pat.tbl_PatientInfo pinfo
			join NRLBAN.Carelab_Ktm_104.pat.tbl_PatientBill Binfo ON pinfo.Id = Binfo.PatId
	
	) as source	on target.LoginType = source.LoginType 
					AND target.LoginID = source.LoginID
					and target.fiscalyear = @fiscalyear

	when matched and 
	(
		target.LoginPw <> source.LoginPw 
		or Target.IsActive <> Source.IsActive
	) then
	update set 
	Target.LoginPw = source.LoginPw, 
	Target.IsActive = source.IsActive,
	target.IsSync = 0

	when not matched then
	insert 
	values(source.LoginType,source.LoginID,source.LoginPw,getdate(),getdate(),source.IsActive,0,@fiscalyear);
end
