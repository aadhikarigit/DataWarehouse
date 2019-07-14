USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[Int_BranchPatientReportDetails]    Script Date: 7/8/2019 3:11:54 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Int_BranchPatientReportDetails](
	[ID] [int] IDENTITY(1,1) NOT NULL,
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
	[SyncStatus] [bit] NULL,
	[IsSync] [int] NOT NULL,
	[TestRecordId] [int] NULL,
	[fiscalyear] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Int_BranchPatientReportDetails] ADD  DEFAULT ((0)) FOR [IsSync]
GO