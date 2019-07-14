USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[syncRights]    Script Date: 7/11/2019 5:47:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER proc [Sync].[syncRights]
	@fiscalyear varchar(10) = '2075-76'
as
begin
	Merge dbo.Rights as target
using (
		select tr.rightsID as _OrigRightsId
		,tr.rightsName as RightsName
		,tr.rightsDescp as RightsDesc
		,getdate() as CreateTs
		,getdate() as UpdateTs
		from NRLBAN.Carelab_Ktm_104.dbo.tbl_Rights tr

	) as source
on target._OrigRightsId = source._OrigRightsId
and target.fiscalyear = @fiscalyear

WHEN MATCHED and target.RightsName   <> source.RightsName
 OR target.RightDesc   <> source.RightsDesc
THEN UPDATE 
set 
 
  target.RightsName  = source.RightsName
 ,target.RightDesc  = source.RightsDesc
 ,target.UpdateTs    = getdate()

when not matched then
insert 
values( source._OrigRightsId
		,source.RightsName
		,source.RightsDesc
		,0
		,getdate()
		,getdate()
		,@fiscalyear);
end
