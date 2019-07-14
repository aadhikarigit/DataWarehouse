-- Add fiscalyear column to all the tables of staging
	--alter table PatientMaster drop column fiscalyear

	-- PatientMaster
	alter table PatientMaster add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from PatientMaster;

	-- TestMaster
	alter table TestMaster add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from TestMaster;

	-- SubTestMaster
	alter table SubTestMaster add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from SubTestMaster;

	-- tbl_QuadrupleLookUp
	alter table tbl_QuadrupleLookUp add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from tbl_QuadrupleLookUp;

	-- tbl_MolecularBiologyLookUp
	alter table tbl_MolecularBiologyLookUp add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from tbl_MolecularBiologyLookUp;

	-- StoneReport
	alter table StoneReport add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from StoneReport;

	-- Roles
	alter table Roles add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from Roles;

	-- Role_Rights
	alter table Role_Rights add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from Role_Rights;

	-- Rights
	alter table Rights add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from Rights;

	-- RequestorMaster
	alter table RequestorMaster add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from RequestorMaster;

	-- PatientHistoMaster
	alter table PatientHistoMaster add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from PatientHistoMaster;

	-- PanelMaster
	alter table PanelMaster add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from PanelMaster;

	-- New_PatientTestRecordResult
	alter table New_PatientTestRecordResult add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from New_PatientTestRecordResult;

	-- MemberMaster
	alter table MemberMaster add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from MemberMaster;

	-- MasterSpecialist
	alter table MasterSpecialist add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from MasterSpecialist;

	-- LoginMaster
	alter table LoginMaster add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from LoginMaster;

	-- LoginInfo
	alter table LoginInfo add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from LoginInfo;

	-- Int_PatientReportDetails
	alter table Int_PatientReportDetails add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from Int_PatientReportDetails;

	-- Int_PatientHistoDetails
	alter table Int_PatientHistoDetails add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from Int_PatientHistoDetails;

	-- Int_PatientBillReport
	alter table Int_PatientBillReport add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from Int_PatientBillReport;

	-- Int_BranchPatientReportDetails
	alter table Int_BranchPatientReportDetails add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from Int_BranchPatientReportDetails;

	-- Int_BranchPatientHistoDetails
	alter table Int_BranchPatientHistoDetails add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from Int_BranchPatientHistoDetails;

	-- Int_BranchPatientBilleport
	alter table Int_BranchPatientBillReport add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from Int_BranchPatientBillReport;

	-- FactPatientHistoRecords
	alter table FactPatientHistoRecords add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from FactPatientHistoRecords;

	-- FactPatientDiagnosis
	alter table FactPatientDiagnosis add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from FactPatientDiagnosis;

	-- FactBranchPatientHistoRecords
	alter table FactBranchPatientHistoRecords add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from FactBranchPatientHistoRecords;

	-- FactBranchPatientDiagnosis
	alter table FactBranchPatientDiagnosis add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from FactBranchPatientDiagnosis;

	-- DiagnosisMaster
	alter table DiagnosisMaster add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from DiagnosisMaster;

	-- BranchPatientMaster
	alter table BranchPatientMaster add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from BranchPatientMaster;

	-- BranchPatientHistoMaster
	alter table BranchPatientHistoMaster add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from BranchPatientHistoMaster;

	-- BillMaster
	alter table BillMaster add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from BillMaster;

	-- BillLoginMaster
	alter table BillLoginMaster add fiscalyear varchar(10) not null default '2075-76';
	select top 2 * from BillLoginMaster;





-- Add fiscalyear column to all the tables of DataWarehouse

-- Add fiscal year column to all the sync queries of staging

-- Add fiscal year column to all the sync queries of DataWarehouse

-- Add fiscal year column to all the executing queries