INSERT INTO DataWareHouse.[dbo].[MemberMaster]

SELECT DISTINCT
 NULL AS MemberCode
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
,ContactNo AS ContactNo
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
FROM Carelab_Ktm_Current.[pat].[tbl_PatientInfo] pat
WHERE MemberCode <> '' AND MemberCode <> 'N' AND ContactNo <> ''