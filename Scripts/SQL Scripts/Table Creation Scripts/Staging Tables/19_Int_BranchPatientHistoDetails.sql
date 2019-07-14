USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[Int_BranchPatientHistoDetails]    Script Date: 7/8/2019 3:11:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Int_BranchPatientHistoDetails](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PatId] [int] NULL,
	[PatHistoRecId] [int] NULL,
	[ResultId] [int] NULL,
	[TestTitle] [varchar](max) NULL,
	[TestParent] [varchar](max) NULL,
	[Result] [varchar](max) NULL,
	[HistoTestId] [int] NULL,
	[HistoTestName] [varchar](max) NULL,
	[HistoTestTypeId] [int] NULL,
	[HistoType] [varchar](max) NULL,
	[IsFinished] [int] NULL,
	[IsTaken] [int] NULL,
	[ReportTakenBy] [varchar](max) NULL,
	[CheckedBy] [varchar](max) NULL,
	[Designation] [varchar](max) NULL,
	[Reg_No] [varchar](max) NULL,
	[Nrl_Reg_No] [int] NULL,
	[HistoCode] [varchar](max) NULL,
	[InvoiceNumber] [varchar](max) NULL,
	[ResultDate] [varchar](100) NULL,
	[CheckedById] [int] NULL,
	[CheckedBySecond] [int] NULL,
	[HistoNote] [varchar](max) NULL,
	[IsHistoRecord] [int] NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTs] [datetime] NULL,
	[SyncStatus] [bit] NULL,
	[IsSync] [int] NOT NULL,
	[fiscalyear] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Int_BranchPatientHistoDetails] ADD  DEFAULT ((0)) FOR [IsSync]
GO
