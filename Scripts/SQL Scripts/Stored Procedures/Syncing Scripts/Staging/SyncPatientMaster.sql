USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[syncPatientMaster]    Script Date: 7/10/2019 3:48:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [Sync].[syncPatientMaster]
	@fiscalyear varchar(10) = '2075-76'
as
begin
	
	Merge dbo.PatientMaster as target
	using (
			SELECT DISTINCT
			tpi.Id AS MainPatID
			,CASE WHEN tpi.MemberCode IS NULL OR tpi.MemberCode = '' OR tpi.MemberCode = 'N' THEN 0 ELSE 1 END AS IsMember
			,CASE WHEN tpi.MemberCode IS NULL OR tpi.MemberCode = '' OR tpi.MemberCode = 'N' THEN '' ELSE tpi.MemberCode END AS MemberCode
			,tpi.FirstName AS FirstName
			,tpi.MiddleName AS MidName
			,tpi.LastName AS LastName
			,tpi.FirstName + ' ' + tpi.MiddleName  + ' ' + tpi.LastName AS FullName
			,CAST(getdate() AS DATE) AS Dob
			,CASE tpi.Sex WHEN 'Male' THEN 'M'
				WHEN 'Female' THEN 'F'
				ELSE 'O' END AS Gender
			,'' AS Address1
			,'' AS Address2
			,'' AS Address3
			,tpi.ContactNo AS ContactNo
			,isnull(tpi.EmailId,'') AS EmailId
			,'' AS IdentityID
			,'' AS IdentityType
			,tpi.Designation AS Salutation
			,'' AS ContactNo2
			,'' AS ContactNo3
			,'' AS CrdtPrtyId
			,1 AS IsActive
			,CAST(getdate() AS DATE) AS CreateTs
			,CAST(getdate() AS DATE) AS UpdateTs
			,'' as CreditParty
			,tpi.NepaliDate
			,case when rm._OrigRequestorId is null then 0 else rm._OrigRequestorId end as RequestorId
			,tpi.Requestor
			,tpi.Age
			,tpi.[Date] as PDate
			,tpi.ReferredDoctorId
			,tpi.ClinicalSyptoms as ClinicalSymptoms
			,tpi.[Routine]
			,tpi.[Stat]
			,tpi.[TimeOfCollection]
			,tpi.[ClinicalCode]
			,ISNULL(tpi.[DiscountRemarks],'') as DiscountRemarks
			FROM NRLBAN.Carelab_Ktm_104.pat.tbl_PatientInfo tpi
			left join dbo.RequestorMaster rm on rm._OrigRequestorId = tpi.RequestorID
			where tpi.Issync = 0
			--order by 1
	) as source
	on target.MainPatID = source.MainPatID 
		and target.fiscalyear = @fiscalyear
	--and (
	--target.IsMember <> source.IsMember 
	--or target.MemberCode <> source.MemberCode 
	--target.FirstName <> source.FirstName 
	--or len(target.MidName) <> len(source.MidName)
	-- or target.Gender <> source.Gender-- or target.Address1 <> source.Address1
	--)
	--and (target.IsMember <> source.IsMember or target.MemberCode <> source.MemberCode or target.FirstName <> source.FirstName
	--or target.MidName <> source.MidName or target.Gender <> source.Gender or target.Address1 <> source.Address1 
	--or target.Address2 <> source.Address2 or target.Address3 <> source.Address3 or target.ContactNo <> source.ContactNo
	--or target.EmailId <> source.EmailId or target.IdentityId <> source.IdentityId or target.IdentityType <> source.IdentityType
	--or target.salutation <> source.Salutation or target.ContactNo2 <> source.ContactNo2 or target.ContactNo3 <> source.ContactNo3
	--or target.CrdtPrtyId <> source.CrdtPrtyId or target.IsActive <> source.IsActive or target.CreditParty <> source.CreditParty
	--or target.NepaliDate <> source.NepaliDate or target.Age <> source.Age or target.PDate <> source.PDate or 
	--target.ReferredDoctorId <> source.ReferredDoctorId or target.RequestorId <> source.RequestorId or target.Requestor <> source.Requestor
	--or target.ClinicalSymptoms <> source.ClinicalSymptoms or target.Routine <> source.Routine or target.Stat <> source.Stat
	--or target.TimeOfCollection <> source.TimeOfCollection or target.ClinicalCode <> source.ClinicalCode 
	--or target.DiscountRemarks <> source.DiscountRemarks
	--)

	 when matched then
	update
	set target.[IsMember] = source.[IsMember]
		  ,target.[MemberCode] = target.[MemberCode]
		  ,target.[FirstName] = source.FirstName
		  ,target.[MidName] = source.MidName
		  ,target.[LastName] = source.LastName
		  ,target.[FullName] = source.FullName
		  ,target.[Dob] = source.Dob
		  ,target.[Gender] = source.Gender
		  ,target.[Address1] = source.Address1
		  ,target.[Address2] = source.Address2
		  ,target.[Address3] = source.Address3
		  ,target.[ContactNo] = source.ContactNo
		  ,target.[EmailId] = source.EmailId
		  ,target.[IdentityID] = source.IdentityID
		  ,target.[IdentityType] = source.IdentityType
		  ,target.[Salutation] = source.Salutation
		  ,target.[ContactNo2] = source.ContactNo2
		  ,target.[ContactNo3] = source.ContactNo3
		  ,target.[CrdtPrtyId] = source.CrdtPrtyId
		  ,target.[IsActive] = source.IsActive 
		  ,target.[UpdateTs] = source.UpdateTs
		  ,target.[CreditParty] = source.CreditParty
		  ,target.[NepaliDate] = source.NepaliDate
		  ,target.[Age] = source.Age
		  ,target.[PDate] = source.PDate
		  ,target.[ReferredDoctorId] = source.ReferredDoctorId
		  ,target.[RequestorId] = source.RequestorId
		  ,target.[Requestor] = source.Requestor
		  ,target.[ClinicalSymptoms] = source.ClinicalSymptoms
		  ,target.[Routine] = source.Routine
		  ,target.[Stat] = source.Stat
		  ,target.[TimeOfCollection] = source.TimeOfCollection
		  ,target.[ClinicalCode] = source.ClinicalCode
		  ,target.[DiscountRemarks] = source.DiscountRemarks
		  ,target.Issync = 0

	--when not matched then
	--insert

	-- when matched

	when not matched then
	insert (MainPatID,IsMember,MemberCode,FirstName,MidName,LastName,
	FullName,Dob,Gender,Address1,Address2,Address3,ContactNo,EmailId,
	IdentityID,IdentityType,Salutation,ContactNo2,ContactNo3,CrdtPrtyId,
	IsActive,CreateTs,
	UpdateTs,CreditParty,NepaliDate,RequestorId,Requestor,Age,
	PDate,ReferredDoctorId,ClinicalSymptoms,Routine,Stat,TimeOfCollection,
	ClinicalCode,DiscountRemarks,IsSync,fiscalyear
	)
	values(
		source.MainPatId,
		source.IsMember
		,source.MemberCode
	,source.FirstName
	,source.MidName
	,source.LastName
	,source.FullName
	,source.Dob
	,source.Gender
	,source.Address1
	,source.Address2
	,source.Address3
	,source.ContactNo
	,source.EmailId
	,source.IdentityID 
	,source.IdentityType 
	,source.Salutation
	,source.ContactNo2
	,source.ContactNo3
	,source.CrdtPrtyId
	,source.IsActive 
	,source.CreateTs
	,source.UpdateTs
	,source.CreditParty
	,source.NepaliDate
	,source.RequestorId
	,source.Requestor
	,source.Age
	,source.[PDate]
	,source.ReferredDoctorId
	,source.ClinicalSymptoms
	,source.[Routine]
	,source.[Stat]
    ,source.[TimeOfCollection]
    ,source.[ClinicalCode]
    ,source.[DiscountRemarks]
	,0
	,@fiscalyear
	);
		--when not matched by source then
		--delete ;
end
