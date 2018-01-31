select getdate() - 365

select * from  DataWareHouse.[dbo].[LoginInfo]

insert into  DataWareHouse.[dbo].[LoginInfo] (LoginType,LoginID,LoginPw,CreateTs,UpdateTS,IsActive)

SELECT
 CASE WHEN IsMember = 0 then 'Patient' ELSE 'Member' end AS LoginType
,CASE WHEN IsMember = 0 then cast(id as varchar) ELSE MemberCode END AS LoginID
,SUBSTRING(CONVERT(varchar(40), NEWID()),0,9) AS LoginPw
,GETDATE() AS CreateTs
,GETDATE() AS UpdateTS
,IsActive AS IsActive
FROM DataWareHouse..PatientMaster

select * from DataWareHouse..PatientMaster

INSERT INTO DataWareHouse..PatientMaster (MainPatID,IsMember,MemberCode,FirstName,MidName,LastName,FullName,Dob,Gender,Address1,Address2,Address3,ContactNo,EmailId,IdentityID,IdentityType,Salutation,ContactNo2,ContactNo3,CrdtPrtyId,IsActive,CreateTs,UpdateTs)

SELECT 
Id AS MainPatID
,CASE WHEN MemberCode IS NULL OR MemberCode = '' OR MemberCode = 'N' THEN 0 ELSE 1 END AS IsMember
,CASE WHEN MemberCode IS NULL OR MemberCode = '' OR MemberCode = 'N' THEN NULL ELSE MemberCode END AS MemberCode
,FirstName AS FirstName
,MiddleName AS MidName
,LastName AS LastName
,FirstName + ' ' + MiddleName  + ' ' + LastName AS FullName
,CAST(getdate() AS DATE) AS Dob
,CASE Sex WHEN 'Male' THEN 'M'
	WHEN 'Female' THEN 'F'
	ELSE 'O' END AS Gender
,'' AS Address1
,'' AS Address2
,'' AS Address3
,ContactNo AS ContactNo
,'' AS EmailId
,'' AS IdentityID
,'' AS IdentityType
,Designation AS Salutation
,'' AS ContactNo2
,'' AS ContactNo3
,CrdtPrtyId AS CrdtPrtyId
,1 AS IsActive
,CAST(getdate() AS DATE) AS CreateTs
,CAST(getdate() AS DATE) AS UpdateTs
FROM pat.tbl_PatientInfo

SELECT MAX(LEN()) FROM pat.tbl_PatientInfo
SELECT MAX(LEN(MiddleName)) FROM pat.tbl_PatientInfo
SELECT MAX(LEN(Designation)) FROM pat.tbl_PatientInfo



