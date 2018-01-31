select * from INFORMATION_SCHEMA.TABLES

SELECT TOP 10 * FROM tbl_MemberShip
SELECT top 10 * FROM pat.tbl_PatientHistoRecord

select top 10 * from pat.tbl_PatientInfo

select top 10 * from pat.tbl_PatientHistoReport Rep
inner join pat.tbl_PatientHistoRecord Rec on rep.Id = rec.HistoTestId -- cytology test
inner join pat.tbl_PatientInfo pat on pat.Id=  rec.PatId
inner join pat.tbl_Bill_Details bill on bill.TestID = rep.Id
inner join pat.tbl_PatReferDoctor Rdoc on rdoc.Id =  pat.ReferredDoctorId
inner join pat.tbl_PatientTestRecord Trec on Trec.PatId =  pat.Id --- pathological blood urine
--inner join pat.tbl_PatientOutGoingTests [Out] on [out].PatId =  pat.Id What is the relation?

select top 100 * from dbo.tbl_MemberShip a -- used to record outgoing test 
inner join pat.tbl_PatientInfo p on p.MemberCode =  a.MemberCode

1	0001 A demographics 
	select top 10 * from [pat].[tbl_PatReferDoctor]
1	0002 B demographics
	
1	0003 C demographics


raw.
stage.
repo.

select top 10 * from [pat].[tbl_PatientHistoRecord]
select * from tbl_NRLHistoTests

select top 1 * from tbl_DiagnosisGroup
select top 1 * from [tbl_Antimicrobial Agents]
select top 1 * from tbl_DifferentialTestList
select top 1 * from tbl_NRLTests
select top 1 * from tbl_NRLHistoTests
select top 1 * from tbl_HistoTestType
select top 1 * from tbl_Test_DiagnosisGroup
select top 1 * from tbl_Test_GroupType
select top 1 * from tbl_TestPanel_ProfileGroup
select top 1 * from tbl_Panel_ProfileGroup
select top 1 * from tbl_TestResultForReport
select top 1 * from tbl_SubTests
select top 1 * from tbl_ExecutivePanel
select top 1 * from tbl_ExecutiveTestGroup
select top 1 * from tbl_RangeOfTests



select  FirstName+LastName, count(*)
from pat.tbl_PatientInfo
group by FirstName+LastName
having count (*) >1 
order by 1

select top 10 * from tbl_MemberShip


select  FirstName+LastName,*
from pat.tbl_PatientInfo
where FirstName+LastName = 'AADARSHAPOUDEL'
group by FirstName+LastName
having count (*) >1

select *
from [pat].[tbl_PatientTestRecord]
where PatId in (12841,12842,18210)
order by 1

Select top 10 * from [dbo].[tbl_NRLTests]  where SubGroupType  <> ''
select top 10 * from [dbo].[tbl_NRLHistoTests]

select * from [dbo].[tbl_TestRangeHistory] a
left join tbl_NRLTests b on b.Id = a.DgId
order by a.DgId, a.ModifiedDate desc

select * from pat.tbl_PatientHistoReport
select * from pat.tbl_PatientHistoRecord