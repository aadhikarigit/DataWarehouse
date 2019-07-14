USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[Int_PatientReportDetails]    Script Date: 7/8/2019 3:12:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Int_PatientReportDetails](
	[PatId] [int] NULL,
	[_OrigPatId] [int] NULL,
	[ReportDate] [varchar](10) NULL,
	[DiagId] [int] NULL,
	[_OrigDiagId] [int] NULL,
	[TestID] [int] NULL,
	[_OrigTestId] [int] NULL,
	[PanelId] [int] NULL,
	[_OrigPanelId] [int] NULL,
	[TestRange] [nvarchar](max) NULL,
	[IsExecutive] [char](1) NULL,
	[TestPrice] [money] NULL,
	[TestMethod] [varchar](max) NULL,
	[TestResult] [nvarchar](50) NULL,
	[SubTestId] [int] NULL,
	[_OrigSubTestId] [int] NULL,
	[SubTest] [nvarchar](150) NULL,
	[SubTestRange] [nvarchar](max) NULL,
	[SubTestUnits] [nvarchar](max) NULL,
	[SubTestActive] [int] NULL,
	[SubTestResult] [nvarchar](max) NULL,
	[Note] [nvarchar](max) NULL,
	[PanelName] [nvarchar](max) NULL,
	[SubMethod] [nvarchar](max) NULL,
	[D_Group] [int] NULL,
	[GroupId] [int] NULL,
	[GroupName] [nvarchar](max) NULL,
	[DigId] [int] NULL,
	[rownum] [int] NULL,
	[IsSync] [bit] NULL,
	[SyncStatus] [bit] NULL,
	[TestRecordId] [int] NOT NULL,
	[IsFactLoaded] [int] NOT NULL,
	[IsHideOnPrint] [bit] NULL,
	[fiscalyear] [varchar](10) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Int_PatientReportDetails] ADD  DEFAULT ((0)) FOR [IsSync]
GO

ALTER TABLE [dbo].[Int_PatientReportDetails] ADD  DEFAULT ((0)) FOR [SyncStatus]
GO

ALTER TABLE [dbo].[Int_PatientReportDetails] ADD  DEFAULT ((0)) FOR [TestRecordId]
GO

ALTER TABLE [dbo].[Int_PatientReportDetails] ADD  DEFAULT ((0)) FOR [IsFactLoaded]
GO

ALTER TABLE [dbo].[Int_PatientReportDetails] ADD  DEFAULT ((0)) FOR [IsHideOnPrint]
GO