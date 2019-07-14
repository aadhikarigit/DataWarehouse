USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[PatientHistoMaster]    Script Date: 7/8/2019 3:15:34 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PatientHistoMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[HistoRecordId] [int] NULL,
	[_OrigPatId] [int] NULL,
	[HistoTestId] [int] NULL,
	[CheckedByFirstId] [int] NULL,
	[CheckedByFirstName] [varchar](max) NULL,
	[CheckedByFirstDesignation] [varchar](max) NULL,
	[CheckedByFirstRegNo] [varchar](max) NULL,
	[CheckedBySecondId] [int] NULL,
	[CheckedBySecondName] [varchar](max) NULL,
	[CheckedBySecondDesignation] [varchar](max) NULL,
	[CheckedBySecondRegNo] [varchar](max) NULL,
	[ReportDate] [varchar](10) NULL,
	[IsFinished] [int] NULL,
	[HistoTestTypeId] [int] NULL,
	[HistoTestType] [varchar](max) NULL,
	[IsTaken] [int] NULL,
	[UserId] [int] NULL,
	[UserName] [varchar](max) NULL,
	[ReportTakenBy] [varchar](max) NULL,
	[HistoCode] [varchar](max) NULL,
	[ResultDate] [datetime] NULL,
	[ReportNepaliDate] [varchar](10) NULL,
	[Note] [varchar](max) NULL,
	[IsSync] [bit] NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTs] [datetime] NULL,
	[fiscalyear] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[PatientHistoMaster] ADD  DEFAULT ((0)) FOR [IsSync]
GO