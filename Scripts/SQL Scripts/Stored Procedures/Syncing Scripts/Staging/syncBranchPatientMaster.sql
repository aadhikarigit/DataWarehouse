USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[syncBranchPatientMaster]    Script Date: 7/11/2019 7:12:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [Sync].[syncBranchPatientMaster]
	@fiscalyear varchar(10) = '2075-76'
as
begin
	
	Merge dbo.BranchPatientMaster as target
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
			--,case when rm._OrigRequestorId is null then 0 else rm._OrigRequestorId end as RequestorId
			,tpi.Requestor
			,ISNULL(rm.ID,0) as RequestorId
			,tpi.Age
			,tpi.[Date] as PDate
			,tpi.ReferredDoctorId
			,tpi.ClinicalSyptoms as ClinicalSymptoms
			,tpi.[Routine]
			,tpi.[Stat]
			,tpi.[TimeOfCollection]
			,tpi.[ClinicalCode]
			,ISNULL(tpi.[DiscountRemarks],'') as DiscountRemarks
			,tpi.[BranchId]
			,tpi.[BranchInvoiceNo]
			FROM NRLBAN.Carelab_Ktm_104.branch.tbl_BranchPatientInfo tpi
			LEFT JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_RequestorInfo rm
			on rm.Requestor=tpi.Requestor and rm.Requestor <> ''
			where tpi.IsSync = 0
) as source
	on target.MainPatID = source.MainPatID 
	and target.fiscalyear = @fiscalyear

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
		  ,target.[IsActive] = source.IsActive 
		  ,target.[UpdateTs] = source.UpdateTs
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
		  ,target.BranchInvoiceNo=source.BranchInvoiceNo

	--when not matched then
	--insert

	-- when matched

	when not matched then
	insert (MainPatID,IsMember,MemberCode,FirstName,MidName,LastName,
	FullName,Dob,Gender,Address1,Address2,Address3,ContactNo,EmailId,
	IdentityID,IdentityType,Salutation,ContactNo2,ContactNo3,
	IsActive,CreateTs,
	UpdateTs,NepaliDate,RequestorId,Requestor,Age,
	PDate,ReferredDoctorId,ClinicalSymptoms,Routine,Stat,TimeOfCollection,
	ClinicalCode,DiscountRemarks,BranchId,BranchInvoiceNo,fiscalyear
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
	,source.IsActive 
	,source.CreateTs
	,source.UpdateTs
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
	,source.[BranchId]
	,source.[BranchInvoiceNo]
	,@fiscalyear
	);
		--when not matched by source then
		--delete ;
end