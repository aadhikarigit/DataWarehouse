USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[mergeMasterCheckedBy]    Script Date: 7/11/2019 6:20:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER proc [Sync].[mergeMasterCheckedBy]
	@fiscalyear varchar(10) = '2075-76'
as
begin
	Merge dbo.MasterSpecialist as target
	using (
			select s.*
			from
			  (
						select
						  tptc.Id as _SpecialistIdOrig,
						  tptc.Name as Name,
						  tptc.Designation,
						  case when Reg_No like '%NMC%' then Reg_No 
					   when tptc.Designation like '%NMC%' THEN Designation else '' end as NMCRegID
					, case when Reg_No like '%nhpc%' then Reg_No else '' end as NHPCRegID
					, case when Reg_No Not Like '%nmc%' and Reg_No not like '%nhpc%' then Reg_No else '' end as OtherReg
					, case when tptc.Designation like '%lab%' or tptc.Designation like '%patholog%' then 'Pathologist'
					   when tptc.Designation like '%biochem%' then 'BioChemist'
					   when tptc.Designation like '%techno%' then 'Technologist'
					   when tptc.Designation like '%microbio%' then 'Microbiologist'
					   else ''
					end as PrimarySpeciality
					, case when tptc.Designation like '%consult%' then 'Consultant'
					  else ''
					 end as SecondarySpeciality
					, '' as PrimaryHospital
					, 1 as IsActive
					, 0 as IsReferrer
					, 0 as _OrigTabId
					,ISNULL(tptc.DigitalSign,'') as DigitalSign
					,tptc.AppUserId
					,tptc.IsDSAccessible
						from NRLBAN.Carelab_Ktm_104.dbo.tbl_PatTestCheckedBy tptc
						where tptc.Name NOT IN ('' ,'SELECT')
						and tptc.Issync = 0
				) as s 
				where s.IsReferrer = 0
		--order by s._SpecialistIdOrig
	) as source
	on target._SpecialistIdOrig = source._SpecialistIdOrig and target.IsReferrer=0
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
	,target.DigitalSign = source.DigitalSign
	,target.AppUserId = source.AppUserId
	,target.IsDSAccessible = source.IsDSAccessible

	-- when matched

	when not matched then
	insert (_SpecialistIdOrig,Name,Designation,NMCRegID,NHPCRegID,OtherReg,PrimarySpeciality,SecondarySpeciality,PrimaryHospital,IsActive,IsReferrer,_OrigTabId,
	DigitalSign,AppUserId,IsDSAccessible,fiscalyear)
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
		,source.DigitalSign
		,source.AppUserId
		,source.IsDSAccessible
		,@fiscalyear
	);
end

		--select * from  LOCALLINK.Carelab_Butwal_Current.dbo.tbl_PatTestCheckedBy tptc
		--select * from LOCALLINK.Carelab_Butwal_Current.pat.tbl_PatReferDoctor ptpr

		--select * from MasterSpecialist
		--truncate table MasterSpecialist
