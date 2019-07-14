USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[syncRoles]    Script Date: 7/11/2019 12:09:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec Sync.syncRoles


ALTER proc [Sync].[syncRoles]
	@fiscalyear varchar(10) = '2075-76'
as
begin
	Merge dbo.Roles as target
	using (select roleID,roleName from NRLBAN.Carelab_Ktm_104.dbo.tbl_Role) as source
	on target._OrigRoleId = source.roleID
	and target.fiscalyear = @fiscalyear

	when matched and target.RoleName <> source.roleName then
	update set RoleName = source.RoleName, UpdateTs = getdate()

	when not matched then
	insert 
	values(source.roleID,source.roleName,0,getdate(),getdate(),@fiscalyear);
end


