USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[syncPanelMaster]    Script Date: 7/11/2019 6:25:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec Sync.syncPanelMaster

ALTER proc [Sync].[syncPanelMaster]
	@fiscalyear varchar(10) = '2075-76'
as
begin

	
	Merge dbo.PanelMaster as target
	using (
			select tppg.Id as _OrigPanelId,
			  tppg.Description as PanelName,
			  ttgt.TestType as PanelType,
			  tppg.Specimen,
			  tppg.DiagnosisGroup,
			  tppg.DiagnosisId,
			  getdate() as CreateTs,
			  getdate() as UpdateTs 
			  from NRLBAN.Carelab_Ktm_104.dbo.tbl_Panel_ProfileGroup tppg
			  join NRLBAN.Carelab_Ktm_104.dbo.tbl_Test_GroupType ttgt on tppg.TypeId = ttgt.Id
			  where tppg.Issync = 0
	) as source
	on target._origPanelId = source._origPanelId
	and target.fiscalyear = @fiscalyear

	 when matched and
	 (
		   target.PanelName			<> source.PanelName
		OR target.PanelType			<> source.PanelType
		OR target.Specimen			<> source.Specimen
		OR target.DiagnosisGroup	<> source.DiagnosisGroup
		OR target.DiagnosisId		<> source.DiagnosisId
	 )
	 	 
	 then
	update
	set target.PanelName = source.PanelName
	,target.PanelType = source.PanelType
	,target.UpdateTS = getdate()
	,target.Specimen = source.Specimen
	,target.DiagnosisGroup = source.DiagnosisGroup
	,target.DiagnosisId = source.DiagnosisId
	,target.Issync = 0
	
	

	-- when matched

	when not matched then
	insert (_OrigPanelId,PanelName,PanelType,CreateTs,UpdateTs,Specimen,DiagnosisGroup,DiagnosisId,fiscalyear)
	values(
		source._OrigPanelId
		,source.PanelName
		,source.PanelType
		,source.CreateTs
		,source.UpdateTs
		,source.Specimen
		,source.DiagnosisGroup
		,source.DiagnosisId
		,@fiscalyear
	);

		--when not matched by source then
		--delete ;
end
