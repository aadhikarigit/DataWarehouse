

JOIN tbl_TestPanel_ProfileGroup testGroup ON pat.TestPanId=testGroup.Id
					   JOIN tbl_Panel_ProfileGroup pGroup ON testGroup.PanId=pGroup.Id
					   JOIN tbl_Test_DiagnosisGroup testDiagnosis ON testGroup.DGId=testDiagnosis.Id

	SELECT TOP 1 * FROM branch.[tbl_BranchPatientTestRecord]
	select top 1 * from branch.tbl_BranchTestResultForReport
	SELECT * FROM tbl_TestPanel_ProfileGroup order by panID --where DGId = 49
	SELECT * FROM tbl_Test_DiagnosisGroup where id = 49
	SELECT * FROM tbl_Panel_ProfileGroup where id = 5
	select * from tbl_NRLTests where id = 352
	select * from tbl_DiagnosisGroup where id = 2

	select top 1 * from tbl_NRLTests
	select top 1 * from tbl_NRLHistoTests
	select top 1 * from tbl_HistoTestType

	select top 100 * from pat.tbl_patientHistoRecord

	<b>Note:</b> The opinion or diagnosis is based on the tissue submitted and may or may not represent entire lesion   and should not be interpreted in isolation. A correlation with clinical, radiological and other laboratory    parameters is strongly recommended before therapeutic intervention.  
