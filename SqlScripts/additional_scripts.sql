  -- new
  create table DataWarehouse.dbo.PanelMaster (Id int primary key Identity(1,1),_OrigPanelId int,PanelName varchar(100), PanelType varchar(100),CreateTs datetime,UpdateTs datetime)

  insert into DataWarehouse.dbo.PanelMaster
  select tppg.Id as _OrigPanelId,tppg.Description as PanelName,ttgt.TestType as PanelType,getdate() as CreateTs,getdate() as UpdateTs from tbl_Panel_ProfileGroup tppg
  join tbl_Test_GroupType ttgt on tppg.TypeId = ttgt.Id
  
  -- new

  create table DataWarehouse.dbo.FFPanelDiagnosisTest(Id int primary key identity(1,1),_OrigPanId int,_OrigDiagId int,_OrigTestId int,
  PanelName varchar(100), DiagnosisName varchar(100),TestName varchar(100),CreateTs datetime,UpdateTs datetime)

insert into DataWarehouse.dbo.FFPanelDiagnosisTest(_OrigPanId,_OrigDiagId,_OrigTestId,PanelName,DiagnosisName,TestName,CreateTs,UpdateTs)
  select ttppg.PanId as _OrigPanId
  ,ttdg.DgId as _OrigDiagId
  ,ttdg.TestId as _OrigTestId
  ,tppg.Description as PanelName
  ,tdg.Diagnosis as DiagnosisName
  ,tnt.Testname as TestName
  ,getdate() as CreateTs
  ,getdate() as UpdateTs
   from tbl_TestPanel_ProfileGroup ttppg
  join tbl_Test_DiagnosisGroup ttdg on ttppg.DGId = ttdg.Id
  join tbl_Panel_ProfileGroup tppg on ttppg.PanId = tppg.Id
  join tbl_DiagnosisGroup tdg on ttdg.DgId = tdg.Id
  join tbl_NRLTests tnt on ttdg.TestId=tnt.Id
  
  -- MasterSpecialist
  
Insert into DataWareHouse.dbo.MasterSpecialist
select distinct s.*
from
  (
    select
      ptpr.Name as Name,
      case when ptpr.Name like 'Dr%' then 'Doctor'
 when ptpr.Name like '%Hospital%' THEN 'Hospital'
 when ptpr.Name like '%Health%Care%' THEN  'HealthCare' else 'Other' end as Designation, '0' as NMCRegID, '0' as NHPCRegID, '0' as OtherReg, '' AS PrimarySpeciality
, '' as SecondarySpeciality
, case when Hospital='N' or Hospital='' or Hospital is null THEN ''
 ELSE Hospital END as PrimaryHospital
 , 1 AS IsActive
 , 1 as IsReferrer
, 0 as _OrigTabId
    from pat.tbl_PatReferDoctor ptpr
  union
    select
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
    from tbl_PatTestCheckedBy tptc
    where tptc.Name NOT IN ('' ,'SELECT')
) as s
order by s.Name

-- change in creditparty to string for name instead of id
alter table DataWarehouse.dbo.PatientMaster add  CreditParty varchar(100)

update pm 
set pm.CreditParty=tcp.PartyType
from DataWareHouse.dbo.PatientMaster pm 
join tbl_CreditPartyType tcp on pm.CrdtPrtyId = tcp.TypeId

-- Add bill number to PatientBillMaster

create table DataWareHouse..Int_PatientBillReport -- First intermediate table
(
  ClientId int
        ,
  PatId int
        ,
  _OrigPatId int
  ,MemberCode VARCHAR(20)      
        ,
  BillId int
        ,
  _OrigBillId int
        ,
  BillNo nvarchar(12)
        ,
  BillDate VARCHAR(10)
        ,
  ReportDate VARCHAR(10)
        ,
  EnteredBy varchar(50)
        ,
  SpecialistId int
        ,
  SecondSpecialistId INT
  ,
  IsReportTaken char(1) -- y or n
        ,
  IsDone char(1)   -- y or n
        ,
  IsPartiallyDone char(1)  -- y or n
        ,
  BillPriceFinal money
)

INSERT INTO DataWareHouse..Int_PatientBillReport
SELECT DISTINCT
  1 AS ClientId
, ISNULL(pm.ID,'') AS PatId
, ISNULL(pm.MainPatID,'') AS _OrigPatId
,pm.MemberCode AS MemberCode
, ISNULL(bm.BillMasterID,'') AS BillId
, 0 AS _OrigBillId
, bm.BillNo AS BillNo
, CASE WHEN bm.BillDate IS NULL OR bm.BillDate='' THEN convert(varchar(10),getdate(),105) ELSE convert(varchar(10),bm.BillDate,105) END AS BillDate
, CASE WHEN tptr.ResultDate IS NULL OR tptr.ResultDate='' THEN convert(varchar(10),getdate(),105) ELSE convert(varchar(10),tptr.ResultDate,105) END AS ReportDate
, au.usrFullName AS EnteredBy
, ms.ID AS SpecialistId
, ms2.ID AS SecondSpecialistId
, CASE WHEN tptr.IstakenByPatient = 1 THEN 'Y' ELSE 'N' END AS IsReportTaken
, CASE WHEN tptr.IsReportDone=1 THEN 'Y' ELSE 'N' END AS IsDone
, CASE WHEN tptr.IspartiallyDone=1 THEN 'Y' ELSE 'N' END AS IsPartiallyDone
, ISNULL(bm.BillTotal,0) AS BillPriceFinal
FROM pat.tbl_PatientTestRecord tptr
  LEFT JOIN DataWareHouse.dbo.PatientMaster pm ON pm.MainPatId=tptr.PatId
  LEFT JOIN DataWareHouse.dbo.BillMaster bm ON bm.PatientId=tptr.PatId
  LEFT JOIN tbl_PatTestCheckedBy ptcb ON ptcb.Id=tptr.CheckedBy
  LEFT JOIN DataWareHouse.dbo.MasterSpecialist ms ON ms.Name=ptcb.Name
  --LEFT JOIN tbl_PatTestCheckedBy ptcb2 ON ptcb2.Id=tptr.SecondCheckedBy
  LEFT JOIN DataWareHouse.dbo.MasterSpecialist ms2 ON ms2.Name=ptcb.Name
  LEFT JOIN tbl_appUsers au on au.usruserid=tptr.UserId
WHERE bm.BIllNo IS NOT NULL OR bm.BILLNO <> ''
ORDER BY bm.BillNo;

-- Second intermediate table for test details

drop table DataWareHouse..Int_PatientReportDetails

create table DataWareHouse..Int_PatientReportDetails
(
  PatId int
        ,
  _OrigPatId int
        ,
  ReportDate varchar(10)
  ,DiagId INT
  ,_OrigDiagId INT
        ,
  TestID int
        ,
  _OrigTestId int
        ,
  PanelId int
        ,
  _OrigPanelId int
        ,
  TestRange nvarchar(max)
        ,
  IsExecutive char(1)  -- y or n
        ,
  TestPrice money
        ,
  TestResult nvarchar(50)
);

select pm.MainPatId,tdg.Diagnosis,tdg.Id as diagnosisid,tnt.Id as testid,tnt.TestCode,tnt.Testname
FROM pat.tbl_PatientTestRecord tptr
  LEFT JOIN DataWareHouse.dbo.PatientMaster pm on pm.MainPatId=tptr.PatId
  LEFT JOIN tbl_TestPanel_ProfileGroup tppg on tptr.TestPanId=tppg.Id
  LEFT JOIN tbl_Test_DiagnosisGroup ttdg on tppg.DGId=ttdg.Id
  LEFT JOIN tbl_DiagnosisGroup tdg on ttdg.DGId=tdg.Id
  LEFT JOIN tbl_NRLTests tnt on ttdg.TestId=tnt.Id
  --LEFT JOIN DataWareHouse.dbo.PanelMaster panm on tptr.TestPan

 drop table #TestWithoutPanel
select pm.ID as PatientId
, tptr.PatId as _OrigPatientId
, pm.MemberCode as MemberCode
, pm.ContactNo as MobileNo
, bm.BillMasterID as BillID
, 0 as PanelId
, '' as PanelName
, tptr.IndividualTestId IndividualTestId
, tdg.Id as DiagnosisId
, tdg.Diagnosis as DiagnosisName
, ttdg.TestId as TestId
, tptr.ResultDate
, tnt.TestName
, tbd.TestId as billtestid
, tbd.billPrice as TestPrice
, tptr.TestResult
, tptr.TestRange
, case when tptr.IsExecutive=1 then 'Y' else 'N' end as IsExecutive
into #TestWithoutPanel
from pat.tbl_PatientTestRecord tptr
  left join DataWareHouse.dbo.PatientMaster pm on pm.MainPatId=tptr.PatId
  left join tbl_Test_DiagnosisGroup ttdg on ttdg.Id=tptr.IndividualTestId
  left join tbl_DiagnosisGroup tdg on tdg.Id=ttdg.DgId
  left join tbl_NRLTests tnt on ttdg.TestId=tnt.Id
  left join pat.tbl_PatientBill tpb on tpb.PatId=tptr.PatId
  left join DataWareHouse.dbo.BillMaster bm on bm.BillNo=tpb.BillNo
  left join pat.tbl_Bill_Details tbd on tbd.BillNo=tpb.BillNo and tbd.TestID=ttdg.Id
where tptr.IndividualTestId <> 0
order by tptr.PatId

-- Queries for intermediate table for fact table

-- Test with panel
drop table #TestWithPanel
select pm.ID as PatientId
, tptr.PatId as _OrigPatientId
, pm.MemberCode as MemberCode
, pm.ContactNo as MobileNo
, bm.BillMasterID as BillID
, ttppg.PanId as PanelId
, tppg.Description as PanelName
, ttdg.Id as IndividualTestId
, tdg.Id as DiagnosisId
, tdg.Diagnosis as DiagnosisName
, ttdg.TestId as TestId
, tptr.ResultDate
, tnt.TestName
, tbd.TestId as billtestid
, tbd.billPrice as TestPrice
, tptr.TestResult
, tptr.TestRange
, case when tptr.IsExecutive=1 then 'Y' else 'N' end as IsExecutive
into #TestWithPanel
from pat.tbl_patientTestRecord tptr
  left join DataWareHouse.dbo.PatientMaster pm on pm.MainPatId=tptr.PatId
  left join tbl_TestPanel_ProfileGroup ttppg on ttppg.Id = tptr.TestPanId
  left join tbl_Panel_ProfileGroup tppg on tppg.Id=ttppg.PanId
  left join tbl_Test_DiagnosisGroup ttdg on ttdg.Id=ttppg.DGId
  left join tbl_DiagnosisGroup tdg on tdg.Id=ttdg.DgId
  left join tbl_NRLTests tnt on tnt.Id=ttdg.TestId
  left join pat.tbl_PatientBill tpb on tpb.PatId=tptr.PatId
  left join DataWareHouse.dbo.BillMaster bm on bm.BillNo=tpb.BillNo
  left join pat.tbl_Bill_Details tbd on tbd.BillNo=tpb.BillNo and tbd.TestID=ttdg.Id
where tptr.TestPanId <> 0
order by tptr.PatId

-- Query for #TestWithoutPanel

drop table #TestWithoutPanel
select pm.ID as PatientId
, tptr.PatId as _OrigPatientId
, pm.MemberCode as MemberCode
, 0 as PanelId
, '' as PanelName
, tptr.IndividualTestId IndividualTestId
, tdg.Id as DiagnosisId
, tdg.Diagnosis as DiagnosisName
, ttdg.TestId as TestId
, tptr.ResultDate
, tnt.TestName
, tbd.TestId as billtestid
, tbd.billPrice as TestPrice
, tptr.TestResult
, tptr.TestRange
into #TestWithoutPanel
from pat.tbl_PatientTestRecord tptr
  left join DataWareHouse.dbo.PatientMaster pm on pm.MainPatId=tptr.PatId
  left join tbl_Test_DiagnosisGroup ttdg on ttdg.Id=tptr.IndividualTestId
  left join tbl_DiagnosisGroup tdg on tdg.Id=ttdg.DgId
  left join tbl_NRLTests tnt on ttdg.TestId=tnt.Id
  left join pat.tbl_PatientBill tpb on tpb.PatId=tptr.PatId
  left join pat.tbl_Bill_Details tbd on tbd.BillNo=tpb.BillNo and tbd.TestID=ttdg.Id
where tptr.IndividualTestId <> 0
order by tptr.PatId

-- Mixed TestDetails with and without panel
drop table #AllDiagnosisTest

select *
into #AllDiagnosisTest
from
  (
    select *
    from #TestWithoutPanel
  union
    select *
    from #TestWithPanel
) as t
order by t.PatientId

-- Query for inserting


-- Query for inserting data from #AllDiagnosisTest into Int_PatientReportDetails
TRUNCATE table DataWareHouse.dbo.Int_PatientReportDetails  -- truncate table query

Insert into DataWareHouse.dbo.Int_PatientReportDetails
select PatientId as PatId
, _OrigPatientId as _OrigPatId
, convert(varchar(10),ResultDate,105) as ReportDate
, DiagnosisId as DiagId
, DiagnosisId as _OrigDiagId
, TestId as TestID
, TestId as _OrigTestId
, PanelId as PanelId
, PanelId as _OrigPanelId
, TestRange as TestRange
, IsExecutive as IsExecutive
, IsNull(TestPrice,0) as TestPrice
, TestResult as TestResult
from #AllDiagnosisTest

-- Query for inserting data from Int_PatientBillReport and Int_PatientReportDetails into FactPatientDiagnosis

Insert into DataWareHouse.dbo.FactPatientDiagnosis
--select max(len(t.Price)) as maxlen from
--(
select ipbr.MemberCode
, ipbr.PatId as _PatientID
, pm.ContactNo as MobileNo
, ipbr.BillId as BillID
, SpecialistId as DoctorId
, SecondSpecialistId as CheckedByID
, DiagId as DiagnosisID
, TestID as TestID
, tm.Method as Method
, TestRange as Range
, TestResult as Result
, TestPrice as Price
, '' as Remarks
, '' as AttachmentLink
, getdate() as CreateTs
, getdate() as UpdateTs
from DataWareHouse.dbo.Int_PatientBillReport ipbr
  join DataWareHouse.dbo.Int_PatientReportDetails iprd on iprd.PatId=ipbr.PatId and iprd.ReportDate=ipbr.ReportDate
  left join DataWareHouse.dbo.TestMaster tm on tm.ID = iprd.TestID
  left join DataWareHouse.dbo.PatientMaster pm on pm.ID=ipbr.PatId
