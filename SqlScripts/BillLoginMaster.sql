
INSERT INTO BillLoginMaster

SELECT 
 Id AS _PatientID
,CAST(id as varchar(10) )+ 'LOG' AS BillLogin
,CAST(id as varchar(10) )+ 'PWD' AS BillPassword
,1 AS ClientID
,1 AS IsActive
,0 AS IsMemberMapped
,1 AS IsDocSharable
,GETDATE() AS CreateTs
,GETDATE() AS UpdateTs
FROM Carelab_Ktm_Current.[pat].[tbl_PatientInfo] pat
WHERE MemberCode <> '' AND MemberCode <> 'N' AND ContactNo <> ''