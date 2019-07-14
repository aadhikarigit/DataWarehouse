USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[mergeMasterReferrer]    Script Date: 7/11/2019 6:23:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [Sync].[mergeMasterReferrer]
	@fiscalyear varchar(10) = '2075-76'
as
begin
	Merge dbo.MasterSpecialist as target
	using (
			select distinct s.*
			from
			  (
				select
				  ptpr.Id as _SpecialistIdOrig,
				  ptpr.Name as Name,
				  case when ptpr.Name like 'Dr%' then 'Doctor'
					 when ptpr.Name like '%Hospital%' THEN 'Hospital'
					 when ptpr.Name like '%Health%Care%' THEN  'HealthCare' else 'Other' end as Designation, '0' as NMCRegID, '0' as NHPCRegID, '0' as OtherReg, '' AS PrimarySpeciality
					, '' as SecondarySpeciality
					, case when Hospital='N' or Hospital='' or Hospital is null THEN ''
					 ELSE Hospital END as PrimaryHospital
					 , 1 AS IsActive
					 , 1 as IsReferrer
					, 0 as _OrigTabId
						from NRLBAN.Carelab_Ktm_104.pat.tbl_PatReferDoctor ptpr
					where ptpr.Issync = 0
				) as s 
				where s.IsReferrer = 1
		--order by s._SpecialistIdOrig
	) as source
	on target._SpecialistIdOrig = source._SpecialistIdOrig and target.IsReferrer=1
	and target.fiscalyear = @fiscalyear
	--and target.Name <> source.Name or target.Designation <> source.Designation or target.NMCRegID <> source.NMCRegID
	--or target.NHPCRegID <> source.NHPCRegID or target.OtherReg <> source.OtherReg or target.PrimarySpeciality <> source.PrimarySpeciality
	--or target.SecondarySpeciality <> source.SecondarySpeciality or target.PrimaryHospital <> source.PrimaryHospital or
	--target.IsActive <> source.IsActive or target.IsReferrer <> source.IsReferrer or target._OrigTabId <> source._OrigTabId and target.IsReferrer <> 0

	 when matched then
	update
	set target.Name = source.Name
	,target.Designation = source.Designation
	,target.NMCRegID = source.NMCRegID
	,target.NHPCRegID = source.NHPCRegID
	,target.OtherReg = source.OtherReg
	,target.PrimarySpeciality = source.PrimarySpeciality
	,target.SecondarySpeciality = source.SecondarySpeciality
	,target.PrimaryHospital = source.PrimaryHospital
	,target.IsActive = source.IsActive
	,target.IsReferrer = source.IsReferrer
	,target._OrigTabId = source._OrigTabId
	,target.Issync = 0

	-- when matched

	when not matched then
	insert (_SpecialistIdOrig,Name,Designation,NMCRegID,NHPCRegID,OtherReg,PrimarySpeciality,SecondarySpeciality,PrimaryHospital,IsActive,IsReferrer,_OrigTabId, DigitalSign,fiscalyear)
	values(
		source._SpecialistIdOrig
		,source.Name
		,source.Designation
		,source.NMCRegID
		,source.NHPCRegID
		,source.OtherReg
		,source.PrimarySpeciality
		,source.SecondarySpeciality
		,source.Primaryhospital
		,source.IsActive
		,source.IsReferrer
		,source._OrigTabId
		,CONVERT(VARBINARY, '')
		,@fiscalyear
	);
end
