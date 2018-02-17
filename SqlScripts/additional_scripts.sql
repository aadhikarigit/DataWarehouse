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
select
ptpr.Name as Name,
case when ptpr.Name like 'Dr%' then 'Doctor'
 when ptpr.Name like '%Hospital%' THEN 'Hospital'
 when ptpr.Name like '%Health%Care%' THEN  'HealthCare' else 'Other' end as Designation,'0' as NMCRegID,'0' as NHPCRegID,'0' as OtherReg,'' AS PrimarySpeciality
,'' as SecondarySpeciality
,case when Hospital='N' or Hospital='' or Hospital is null THEN ''
 ELSE Hospital END as PrimaryHospital
 ,IsActive
 ,1 as IsReferrer
,ptpr.Id as _OrigTabId
from pat.tbl_PatReferDoctor ptpr
union all
select 
tptc.Name as Name,
tptc.Designation,
case when Reg_No like '%NMC%' then Reg_No 
   when tptc.Designation like '%NMC%' THEN Designation else '' end as NMCRegID
,case when Reg_No like '%nhpc%' then Reg_No else '' end as NHPCRegID
,case when Reg_No Not Like '%nmc%' and Reg_No not like '%nhpc%' then Reg_No else '' end as OtherReg
,case when tptc.Designation like '%lab%' or tptc.Designation like '%patholog%' then 'Pathologist'
   when tptc.Designation like '%biochem%' then 'BioChemist'
   when tptc.Designation like '%techno%' then 'Technologist'
   when tptc.Designation like '%microbio%' then 'Microbiologist'
   else ''
end as PrimarySpeciality
,case when tptc.Designation like '%consult%' then 'Consultant'
  else ''
 end as SecondarySpeciality
,'' as PrimaryHospital
,1 as IsActive
,0 as IsReferrer
,tptc.Id as _OrigTabId
from tbl_PatTestCheckedBy tptc
where tptc.Name NOT IN ('' ,'SELECT')

-- change in creditparty to string for name instead of id
alter table DataWarehouse.dbo.PatientMaster add  CreditParty varchar(100)

update pm 
set pm.CreditParty=tcp.PartyType
from DataWareHouse.dbo.PatientMaster pm 
join tbl_CreditPartyType tcp on pm.CrdtPrtyId = tcp.TypeId