USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[syncMemberMaster]    Script Date: 7/11/2019 6:00:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from [DataWareHouse].dbo.[MemberMaster]
--exec Sync.syncMemberMaster


ALTER proc [Sync].[syncMemberMaster]
	@fiscalyear varchar(10) = '2075-76'
as
begin
	Merge dbo.[MemberMaster] as target
	using (
			select *
			from(
					SELECT DISTINCT
					pat.Id as PatId
					,case when MemberCode like '%M%' then MemberCode else '' end AS MemberCode
					,FirstName AS FirstName
					,MiddleName AS MidName
					,LastName AS LastName
					,FirstName + ' ' + MiddleName + ' ' + LastName AS FullName
					,GETDATE()  AS Dob
					,CASE SEX	WHEN 'Male'		THEN 1
								WHEN 'Female'	THEN 2 
								ELSE 0 
					 END AS Gender
					,'' AS Address1
					,'' AS Address2
					,'' AS Address3
					,case when convert(varchar,ContactNo) is null then '0' else convert(varchar,ContactNo) end AS ContactNo
					,EmailId AS EmailId
					,'' AS IdentityID
					,'' AS IdentityType
					,Designation AS Salutation
					,'' AS ContactNo2
					,'' AS ContactNo3
					,0 AS CrdtPrtyId
					,1 AS IsActive
					,GETDATE() AS CreateTs
					,GETDATE() AS UpdateTs
					--into #TempPatient
					FROM NRLBAN.Carelab_Ktm_104.[pat].[tbl_PatientInfo] pat
					WHERE 1=1 --MemberCode <> '' AND MemberCode <> 'N' AND MemberCode is not null --and ContactNo <> ''
					--and
					-- FirstName + ' ' + MiddleName + ' ' + LastName not in ('GRISHMA   BHATTARAI','JAMUNA  SHRESTHA')
					 and pat.IsSync = 0

				)t
		) as source
			ON TARGET.PatId = source.PatId
			and target.fiscalyear = @fiscalyear
			WHEN matched and
			(
					target.MemberCode   <> source.MemberCode
				 OR	target.FirstName    <> source.FirstName
				 OR target.MidName      <> source.MidName
				 OR target.LastName     <> source.LastName
				 OR target.FullName     <> source.FullName
				 OR target.Dob          <> source.Dob
				 OR target.Gender       <> source.Gender
				 OR target.Address1     <> source.Address1
				 OR target.Address2     <> source.Address2
				 OR target.Address3     <> source.Address3
				 OR target.ContactNo    <> source.ContactNo
				 OR target.EmailId      <> source.EmailId
				 OR target.IdentityID   <> source.IdentityID
				 OR target.IdentityType <> source.IdentityType
				 OR target.Salutation   <> source.Salutation
				 OR target.ContactNo2   <> source.ContactNo2
				 OR target.ContactNo3   <> source.ContactNo3
				 OR target.CrdtPrtyId   <> source.CrdtPrtyId
				 OR target.IsActive     <> source.IsActive
			)	
			 then
				update set 
				  target.MemberCode   = source.MemberCode
				 ,target.FirstName    = source.FirstName
				 ,target.MidName      = source.MidName
				 ,target.LastName     = source.LastName
				 ,target.FullName     = source.FullName
				 ,target.Dob          = source.Dob
				 ,target.Gender       = source.Gender
				 ,target.Address1     = source.Address1
				 ,target.Address2     = source.Address2
				 ,target.Address3     = source.Address3
				 ,target.ContactNo    = source.ContactNo
				 ,target.EmailId      = source.EmailId
				 ,target.IdentityID   = source.IdentityID
				 ,target.IdentityType = source.IdentityType
				 ,target.Salutation   = source.Salutation
				 ,target.ContactNo2   = source.ContactNo2
				 ,target.ContactNo3   = source.ContactNo3
				 ,target.CrdtPrtyId   = source.CrdtPrtyId
				 ,target.IsActive     = source.IsActive
				 ,target.UpdateTs     = getdate()
				 ,target.IsSync		  = 0

				when not matched then
				insert 
				values( source.MemberCode
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
					   ,0
					   ,getdate()
					   ,getdate()
					   ,source.PatId
					   ,@fiscalyear
					);
END
