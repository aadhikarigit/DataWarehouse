USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[syncRolesRights]    Script Date: 7/11/2019 6:19:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec Sync.syncRolesRights

ALTER proc [Sync].[syncRolesRights]
	@fiscalyear varchar(10) = '2075-76'
as
begin
	Merge dbo.Role_Rights as target
using (select * from NRLBAN.Carelab_Ktm_104.dbo.tbl_RoleRights) as source
on target.RoleId = source.rrRoleID and target.RightsId = source.rrRightID
and target.fiscalyear = @fiscalyear

when not matched then
insert 
values(source.rrRoleID,source.rrRightID,0,@fiscalyear);


end
