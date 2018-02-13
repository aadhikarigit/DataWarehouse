INSERT INTO DataWareHouse..FactPatientDiagnosis

SELECT
  '' AS MemberCode
, Rec.Id AS _PatientID
, Info.ContactNo AS MobileNo
, bm.ID AS BillID
, '' AS Doctor
, '' AS CheckedBy
, DG.ID /*Diagnosis*/ AS DiagnosisID	-- Shall We keep ID or Name
, Tst.ID /*Testname*/ AS TestID		-- Shall We keep ID or Name
, Tst.Method AS Method
, Rec.TestRange AS Range
, Rec.TestResult AS Result
, Bill.billPriceFinal AS Price
, '' AS Remarks
, '' AS AttachmentLink
, getdate() AS CreateTs
, getdate() AS UpdateTs
FROM PAT.tbl_PatientTestRecord Rec
JOIN tbl_Test_DiagnosisGroup tdg ON tdg.Id = Rec.IndividualTestId
JOIN tbl_DiagnosisGroup DG on tdg.DGId = dg.Id 
JOIN tbl_NRLTests Tst ON tdg.Id = Tst.Id
JOIN pat.tbl_PatientInfo info ON Rec.PatId = Info.Id
JOIN pat.tbl_Bill_Details Bill ON BIll.TestID =  tdg.Id
JOIN DataWareHouse..BillLoginMaster BM ON BM._PatientID = info.Id

select * from DataWareHouse..FactPatientDiagnosis